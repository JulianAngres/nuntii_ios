//
//  MainVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 23/01/2022.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging
import FirebaseFunctions
import UIKit


class MainVC: UIViewController {
    
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var sendItemButton: UIButton!
    @IBOutlet var matchesButton: UIButton!
    @IBOutlet var addItineraryButton: UIButton!
    @IBOutlet var yourItinerariesButton: UIButton!
    @IBOutlet var payoutsButton: UIButton!
    
    //var grundpreis = 111.111
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Nuntii"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    /*private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
    }()*/
    
    private let verifyEmailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Send Verification Email", for: .normal)
        return button
    }()
    
    /*private let settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Settings", for: .normal)
        return button
    }()
    
    private let sendItemButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Send Item", for: .normal)
        return button
    }()
    
    private let matchesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Matches", for: .normal)
        return button
    }()
    
    private let addItineraryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Add Itinerary", for: .normal)
        return button
    }()
    
    private let yourItinerariesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Your Itineraries", for: .normal)
        return button
    }()
    
    private let payoutsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Payouts", for: .normal)
        return button
    }()*/
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        payoutsButton.isHidden = true
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_2")
        backgroundImage.contentMode = .topLeft
        view.insertSubview(backgroundImage, at: 0)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if NetworkMonitor.shared.isConnected {
            
            if FirebaseAuth.Auth.auth().currentUser == nil {
                openLoginVC()
            }
            else if FirebaseAuth.Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
                //showMainScreen()
            }
            else {
                view.addSubview(verifyEmailButton)
                verifyEmailButton.addTarget(self, action: #selector(verifyEmail), for: .touchUpInside)
                self.settingsButton.isHidden = true
                self.sendItemButton.isHidden = true
                self.matchesButton.isHidden = true
                self.addItineraryButton.isHidden = true
                self.yourItinerariesButton.isHidden = true
                //self.payoutsButton.isHidden = true
            }
        }
        else {
            let alertController = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet to use this app.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 80)
        
        /*signOutButton.frame = CGRect(x: 20, y: label.frame.origin.y + label.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        settingsButton.frame = CGRect(x: 20, y: signOutButton.frame.origin.y + signOutButton.frame.size.height + 10, width: view.frame.size.width - 40, height: 50)
        
        sendItemButton.frame = CGRect(x: 20, y: settingsButton.frame.origin.y + settingsButton.frame.size.height + 10, width: view.frame.size.width - 40, height: 50)*/
        
        verifyEmailButton.frame = CGRect(x: 20, y: 80 + 10, width: view.frame.size.width - 40, height: 50)
        
        /*matchesButton.frame = CGRect(x: 20, y: verifyEmailButton.frame.origin.y + verifyEmailButton.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        addItineraryButton.frame = CGRect(x: 20, y: matchesButton.frame.origin.y + matchesButton.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        yourItinerariesButton.frame = CGRect(x: 20, y: addItineraryButton.frame.origin.y + addItineraryButton.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        payoutsButton.frame = CGRect(x: 20, y: yourItinerariesButton.frame.origin.y + yourItinerariesButton.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)*/
    }
    
    
    
    
    func showMainScreen() {
        print("Hello World")
        /*view.addSubview(label)
        view.addSubview(signOutButton)
        view.addSubview(settingsButton)
        view.addSubview(sendItemButton)
        view.addSubview(matchesButton)
        view.addSubview(addItineraryButton)
        view.addSubview(yourItinerariesButton)
        view.addSubview(payoutsButton)
        signOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        sendItemButton.addTarget(self, action: #selector(sendItemTapped), for: .touchUpInside)
        matchesButton.addTarget(self, action: #selector(matchesTapped), for: .touchUpInside)
        addItineraryButton.addTarget(self, action: #selector(addItineraryTapped), for: .touchUpInside)
        yourItinerariesButton.addTarget(self, action: #selector(yourItinerariesTapped), for: .touchUpInside)
        payoutsButton.addTarget(self, action: #selector(payoutsTapped), for: .touchUpInside)*/
    }
    
    
    
    
    /*@objc private func settingsTapped() {
        openSettingsVC()
    }
    
    @objc private func sendItemTapped() {
        openSendItemsVC()
    }
    
    @objc private func matchesTapped() {
        openMatchesVC()
    }
    
    @objc private func addItineraryTapped() {
        openAddItineraryVC()
    }
    
    @objc private func yourItinerariesTapped() {
        openYourItinerariesVC()
    }
    
    @objc private func payoutsTapped() {
        openPayoutsVC()
    }*/
    
    
    
    /*@IBAction func openSettingsVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }*/
    
    /*@IBAction func openSendItemsVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SendItemsVC") as! SendItemsVC
        vc.modalPresentationStyle = .fullScreen
        vc.grund_preis = self.grundpreis
        present(vc, animated: true)
    }*/
    
    /*@IBAction func openMatchesVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MatchesVC") as! MatchesVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func openAddItineraryVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddItineraryVC") as! AddItineraryVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func openYourItinerariesVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "YourItinerariesVC") as! YourItinerariesVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func openPayoutsVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PayoutsVC") as! PayoutsVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }*/
    
    
    
    
    
    @objc private func verifyEmail() {
        FirebaseAuth.Auth.auth().currentUser?.sendEmailVerification(completion: { [weak self] Error in
            guard let strongSelf = self else {
                return
            }
            strongSelf.logOutTapped()
        })
    }
    
    
    @IBAction func tryLogout() {
        logOutTapped()
    }
    
    @objc private func logOutTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            openLoginVC()
            
        }
        catch {
            print("An error occurred")
        }
    }
    
    @IBAction func openLoginVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}




