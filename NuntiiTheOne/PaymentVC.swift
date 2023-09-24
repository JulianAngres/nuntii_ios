//
//  PaymentVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 17/02/2022.
//

import UIKit
import StripePaymentSheet
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

let currency = "NOK"

class PaymentVC: UIViewController {
    
    var allItemsTableList = [TableViewFlight]()
    var emailCloudFunctionsList = [EmailCloudFunctionsList]()
    
    var eigenPreis: Int = 1
    
    var paymentSheet: PaymentSheet?
    let backendCheckoutUrl = URL(string: "https://us-central1-iospaymenttest-f3456.cloudfunctions.net/iosPaymentIntent")! // Your backend endpoint
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    var checkoutButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Checkout", for: .normal)
        return button
    }()
    
    var mainButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back To Main", for: .normal)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if NetworkMonitor.shared.isConnected {
        }
        else {
            let alertController = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet to use this app.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(emailCloudFunctionsList[0])

        // MARK: Fetch the PaymentIntent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: backendCheckoutUrl)
        
        //let json: [String: Any] = ["amount": amount, "currency": currency]
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        Database.database().reference().child("eigenPreis").observeSingleEvent(of: .value, with: { snapshot in
            
            self.eigenPreis = snapshot.value as! Int
            self.showMainScreen()
            
            self.checkoutButton.addTarget(self, action: #selector(self.didTapCheckoutButton), for: .touchUpInside)
            self.checkoutButton.isEnabled = false
            self.mainButton.addTarget(self, action: #selector(self.didTapMainButton), for: .touchUpInside)
            self.mainButton.isHidden = true
            
            let body = "amount=\(Int(self.eigenPreis*100))&currency=\(currency)"
            let finalBody = body.data(using: .utf8)
            
            request.httpMethod = "POST"
            request.httpBody = finalBody
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
              guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let customerId = json["customer"] as? String,
                    let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                    let paymentIntentClientSecret = json["paymentIntent"] as? String,
                    let publishableKey = json["publishableKey"] as? String,
                    let self = self else {
                // Handle error
                return
              }

              STPAPIClient.shared.publishableKey = publishableKey
              // MARK: Create a PaymentSheet instance
              var configuration = PaymentSheet.Configuration()
              configuration.defaultBillingDetails.address.country = "NO"
              configuration.merchantDisplayName = "Nuntii AS"
              configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
              // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
              // methods that complete payment after a delay, like SEPA Debit and Sofort.
              configuration.allowsDelayedPaymentMethods = true
              //configuration.returnURL = "Nuntii://stripe-redirect"
              self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)

              DispatchQueue.main.async {
                  self.checkoutButton.isEnabled = true
                  
                  let auth_id = Auth.auth().currentUser!.uid
                  Firestore.firestore().document("ios_stripe_customers/\(auth_id)").setData(["customer_id": customerId])
              }
            })
            task.resume()
            
        })
        
        
        
    }
    
    internal static func instantiate(with emailCloudFunctionsList: [EmailCloudFunctionsList]) -> PaymentVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        vc.emailCloudFunctionsList = emailCloudFunctionsList
        return vc
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 80)
        
        checkoutButton.frame = CGRect(x: 20, y: label.frame.origin.y + label.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        mainButton.frame = CGRect(x: 20, y: checkoutButton.frame.origin.y + checkoutButton.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
    }
    
    
    
    
    func showMainScreen() {
        print("Hello World")
        view.addSubview(label)
        view.addSubview(checkoutButton)
        view.addSubview(mainButton)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Product: Nuntii Order, price: \(emailCloudFunctionsList[0].price) \(currency)"
        label.text = "Hello, Please Pay \(eigenPreis) \(currency) now, pay \(Int(Float(emailCloudFunctionsList[0].price)! - Float(eigenPreis))) \(currency) later"
    }
    
    
    
    @objc
    func didTapCheckoutButton() {
      // MARK: Start the checkout process
      paymentSheet?.present(from: self) { paymentResult in
        // MARK: Handle the payment result
        switch paymentResult {
        case .completed:
          print("Your order is confirmed")
            self.checkoutButton.isHidden = true
            self.mainButton.isHidden = false
            self.fetchData {
                self.label.text = "Payment succeeded, look at your order in the matches segment"
            }
            
        case .canceled:
          print("Canceled!")
            self.checkoutButton.isHidden = true
            self.mainButton.isHidden = false
            self.label.text = "Payment canceled, please start the order process again :-("
            
        case .failed(let error):
          print("Payment failed: \(error)")
            self.checkoutButton.isHidden = true
            self.mainButton.isHidden = false
            self.label.text = "Payment failed: \(error), please start the order process again :-("
            
        }
      }
    }
    
    
    @objc
    func didTapMainButton() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func fetchData(completion: @escaping () -> Void) {
        // Show activity indicator while task is executing
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)

        // Perform asynchronous task to fetch data
        // ...
        emailCloudFunctions(emailCloudFunctionsList: self.emailCloudFunctionsList, eigenPreis: String(self.eigenPreis))

        // Call completion handler when task is complete
        completion()

        // Hide activity indicator when task is complete
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

}


/*
 
 
 func fetchData(completion: @escaping () -> Void) {
     // Show activity indicator while task is executing
     let activityIndicator = UIActivityIndicatorView(style: .large)
     activityIndicator.center = view.center
     activityIndicator.startAnimating()
     view.addSubview(activityIndicator)

     // Perform asynchronous task to fetch data
     // ...

     // Call completion handler when task is complete
     completion()

     // Hide activity indicator when task is complete
     activityIndicator.stopAnimating()
     activityIndicator.removeFromSuperview()
 }

 // Call fetchData with completion handler
 fetchData {
     // Completion handler code
 }



*/
