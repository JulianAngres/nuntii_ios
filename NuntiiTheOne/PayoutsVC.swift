//
//  PayoutsVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 27/01/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PayoutsVC: UIViewController {
    
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var textView9: UILabel!
    @IBOutlet var emailPhoneTextField: UITextField!
    @IBOutlet var amountPayoutTextView: UILabel!
    @IBOutlet var payoutButton: UIButton!
    @IBOutlet var toastLabel: UILabel!
    //@IBOutlet var backToStartButton: UIButton!
    @IBOutlet var backToStartLabel: UILabel!
    
    var valuue: String!
    var email: String!
    
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
        
        backToStartLabel.isHidden = true
        //backToStartButton.isHidden = true
        toastLabel.text = ""
        imageView2.image = UIImage(named: "vipps")
        
        let emailRaw = Auth.auth().currentUser?.email
        self.email = (emailRaw?.replacingOccurrences(of: ".", with: "__DOT__"))!
        
        Database.database().reference().child("userData").child(email).child("payoutBalance").observeSingleEvent(of: .value, with: {snapshot in
            
            let getPayoutBalance = snapshot.value as! Double
            let deductedPriceRaw = String(getPayoutBalance)
            
            if deductedPriceRaw == "0.0" {
                
                self.amountPayoutTextView.text = "Nothing to pay out currently ;-)"
                self.payoutButton.isHidden = true
                
            }
            else {
                
                var cents = "cents"
                var dollars = "dollars"
                var cutOffCents = "cutOffCents"
                
                if deductedPriceRaw.contains(".") {
                    let splitDeductedPrice = deductedPriceRaw.components(separatedBy: ".")
                    dollars = splitDeductedPrice[0]
                    cents = splitDeductedPrice[1]
                    
                    if cents.count == 1 {
                        cutOffCents = cents + "0"
                    }
                    else {
                        let index = cutOffCents.index(cutOffCents.startIndex, offsetBy: 2)
                        cutOffCents = String(cutOffCents[..<index])
                    }
                    
                }
                else {
                    dollars = deductedPriceRaw
                    cutOffCents = "00"
                }
                
                self.valuue = dollars + "." + cutOffCents
                
                self.amountPayoutTextView.text = "You deserved yourself " + self.valuue + " NOK"
                print("You deserved yourself " + self.valuue + " NOK")
                
            }
            
        })
        
    }
    
    @IBAction func payout() {
        
        toastLabel.text = ""
        
        var recipient_type = "recipient_type"
        
        if emailPhoneTextField.text == "" {
            toastLabel.text = "Please enter your Vipps phone number"
        }
        else if emailPhoneTextField.text!.count != 8 {
            toastLabel.text = "Please enter your 8-digit Norwegian Vipps phone number without blank spaces"
        }
        else {
            let receiver = emailPhoneTextField.text
            if receiver!.contains("@") {
                recipient_type = "EMAIL"
            }
            else {
                recipient_type = "PHONE"
            }
            
            Database.database().reference().child("payoutCount").observeSingleEvent(of: .value, with: {snapshot in
                
                let id = snapshot.value as! Int + 1
                Database.database().reference().child("payoutCount").setValue(id)
                let stringId = "Payout" + String(id)
                
                let sender_batch_id = stringId
                let email_subject = "Congrats! You Received a Nuntii Payout!"
                let email_message = "It's so great that you are a part of our vision!"
                let currency = "NOK"
                let note = "Thank you for being a Nuntius!"
                let sender_item_id = stringId
                
                
                self.curlString(sender_batch_id: sender_batch_id, email_subject: email_subject, email_message: email_message, currency: currency, note: note, sender_item_id: sender_item_id, receiver: receiver!, recipient_type: recipient_type)
                
                Database.database().reference().child("userData").child(self.email).child("payoutBalance").setValue(0)
                
                self.backToStartLabel.isHidden = false
                //self.backToStartButton.isHidden = false
                self.emailPhoneTextField.isHidden = true
                self.toastLabel.isHidden = true
                self.amountPayoutTextView.isHidden = true
                self.payoutButton.isHidden = true
                
            })
        }
        
    }
    
    @IBAction func openMainVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func curlString(sender_batch_id: String, email_subject: String, email_message: String, currency: String, note: String, sender_item_id: String, receiver: String, recipient_type: String) {
        
        var todaysDate:NSDate = NSDate()
        var dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var localDate:String = dateFormatter.string(from: todaysDate as Date)
        
        let dataNew1 = "{\"recipient_type\": \"" + recipient_type
        let dataNew2 = "\",\"amount\": {\"value\": \"" + self.valuue + "\",\"currency\": \""
        let dataNew3 = currency + "\" },\"note\": \"" + note + "\",\"sender_item_id\": \"" + sender_item_id + "\",\"receiver\": \"" + receiver + "\" }, "
        let dataNew = dataNew1 + dataNew2 + dataNew3
        
        Database.database().reference().child("payoutData").child(localDate).observeSingleEvent(of: .value, with: {snapshot in
            
            var newCurlString = "newCurlString"
            let count = snapshot.childrenCount
            
            let oldCurlString = snapshot.childSnapshot(forPath: "curlString" + String(count)).value as! String
            
            let l = oldCurlString.count
            
            if l > 1000000 {
                
                Database.database().reference().child("payoutData").child(localDate).child("curlString" + String(count + 1)).setValue(newCurlString)
            }
            else {
                
                newCurlString = oldCurlString + dataNew
                Database.database().reference().child("payoutData").child(localDate).child("curlString" + String(count)).setValue(newCurlString)
            }
            
        })

        
    }

}
