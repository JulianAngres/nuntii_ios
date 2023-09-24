//
//  SettingsVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 27/01/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SettingsVC: UIViewController {
    
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var resetPasswordButton: UIButton!
    @IBOutlet var deleteAccountButton: UIButton!
    
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
        
        let ownEmail = Auth.auth().currentUser?.email
        
        userIdLabel.text = ownEmail
        
    }
    
    @IBAction func logout() {
        do {
            try Auth.auth().signOut()
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! ViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            
        }
        catch {
            print("An error occurred")
        }
        
    }
    
    @IBAction func resetPassword() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func deleteAccount() {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Account Deletion", message: "Are you sure you want to delete your account permanently?", preferredStyle: .alert)

        // Create the action for confirming
        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            Auth.auth().currentUser?.delete()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }

        // Create the action for canceling
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // Handle cancellation
        }

        // Add the actions to the alert controller
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)

    }
    
}
