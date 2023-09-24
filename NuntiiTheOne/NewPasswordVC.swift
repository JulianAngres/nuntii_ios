//
//  NewPasswordVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 27/01/2022.
//

import Firebase
import UIKit

class NewPasswordVC: UIViewController, UITextFieldDelegate {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Reset Password"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Reset Password", for: .normal)
        return button
    }()
    
    private let backToLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back To Login", for: .normal)
        return button
    }()
    
    private let toastLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(button)
        view.addSubview(backToLoginButton)
        view.addSubview(toastLabel)
        view.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapResetPasswordButton), for: .touchUpInside)
        backToLoginButton.addTarget(self, action: #selector(didTapBackToLoginButton), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        emailField.delegate = self
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .done
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        emailField.resignFirstResponder()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        
        emailField.frame = CGRect(x: 20, y: label.frame.origin.y + label.frame.size.height + 10, width: view.frame.size.width - 40, height: 50)
        
        button.frame = CGRect(x: 20, y: emailField.frame.origin.y + emailField.frame.size.height + 30, width: view.frame.size.width - 40, height: 52)
        
        backToLoginButton.frame = CGRect(x: 20, y: button.frame.origin.y + button.frame.size.height + 30, width: view.frame.size.width - 40, height: 52)
        
        toastLabel.frame = CGRect(x: 20, y: backToLoginButton.frame.origin.y + button.frame.size.height + 90, width: view.frame.size.width - 40, height: 52)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if NetworkMonitor.shared.isConnected {
            if FirebaseAuth.Auth.auth().currentUser == nil {
                emailField.becomeFirstResponder()
            }
        }
        else {
            let alertController = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet to use this app.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
    @objc private func didTapResetPasswordButton() {
        
        guard let email = emailField.text, !email.isEmpty, email.contains("@") else {
            toastLabel.text = "Please Provide Your Valid Email Address"
            return
        }
        
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            
            if error == nil {
                self.openLoginVC()
            }
            else {
                self.toastLabel.text = "Something went wrong :( Please check your internet connection"
            }
            
        })
        
        /*FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                return
            }
            
            let newEmail = email.replacingOccurrences(of: ".", with: "__DOT__")
            strongSelf.database.child("userData").child(newEmail).child("fullName").setValue(fullName)
            strongSelf.database.child("userData").child(newEmail).child("payoutBalance").setValue(0)
            
            print("You have signed in")
            strongSelf.openMainVC()
        })*/
        
    }
    
    
    @objc private func didTapBackToLoginButton() {
        openLoginVC()
    }
    
    @IBAction func openLoginVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}
