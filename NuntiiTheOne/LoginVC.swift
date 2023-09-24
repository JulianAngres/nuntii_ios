//
//  ViewController.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 22/01/2022.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
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
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.layer.borderWidth = 1
        passwordField.isSecureTextEntry = true
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return passwordField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log In", for: .normal)
        return button
    }()
    
    private let newPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("New Password", for: .normal)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Register", for: .normal)
        return button
    }()
    
    /*private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
    }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(button)
        view.addSubview(newPasswordButton)
        view.addSubview(registerButton)
        view.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        newPasswordButton.addTarget(self, action: #selector(didTapNewPasswordButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        emailField.delegate = self
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .done
        
        passwordField.delegate = self
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    /*@objc private func logOutTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            label.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            button.isHidden = false
            
        }
        catch {
            print("An error occurred")
        }
    }*/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        
        emailField.frame = CGRect(x: 20, y: label.frame.origin.y + label.frame.size.height + 10, width: view.frame.size.width - 40, height: 50)
        
        passwordField.frame = CGRect(x: 20, y: emailField.frame.origin.y + emailField.frame.size.height + 10, width: view.frame.size.width - 40, height: 50)
        
        button.frame = CGRect(x: 20, y: passwordField.frame.origin.y + passwordField.frame.size.height + 30, width: view.frame.size.width - 40, height: 52)
        
        newPasswordButton.frame = CGRect(x: 20, y: button.frame.origin.y + button.frame.size.height + 30, width: view.frame.size.width - 40, height: 52)
        
        registerButton.frame = CGRect(x: 20, y: newPasswordButton.frame.origin.y + newPasswordButton.frame.size.height + 30, width: view.frame.size.width - 40, height: 52)
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
    
    
    @objc private func didTapButton() {
        print("Continue button tapped")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
                  print("Missing field data")
                  return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            
            if error == nil {
                strongSelf.openMainVC()
                print("You have signed in")
            } else {
                // show account creation
                print("Wrong Credentials")
                return
            }
            
        })
        
        
    }
    
    
    @objc private func didTapRegisterButton() {
        openRegisterVC()
    }
    
    @objc private func didTapNewPasswordButton() {
        openNewPasswordVC()
    }
    
    
    @IBAction func openMainVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func openRegisterVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func openNewPasswordVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    


}


