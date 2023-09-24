//
//  OrderSpecifyParcelVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 14/02/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OrderSpecifyParcelVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var sizeTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var schalter: UISwitch!
    @IBOutlet var switchHeader: UILabel!
    @IBOutlet var partnerTextField: UITextField!
    @IBOutlet var label: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var senderReceiver: UILabel!
    @IBOutlet var validateEmailButtton: UIButton!
    @IBOutlet var changeSenderReceiverButton: UIButton!
    @IBOutlet var confirmOrderButton: UIButton!
    var sender = true
    
    var allItemsTableList = [TableViewFlight]()
    var emailCloudFunctionsList = [EmailCloudFunctionsList]()
    
    private let database = Database.database().reference()
    
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

        changeSenderReceiverButton.isHidden = true
        confirmOrderButton.isHidden = true
        label.isHidden = true
        emailLabel.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        partnerTextField.delegate = self
        partnerTextField.keyboardType = .emailAddress
        partnerTextField.autocapitalizationType = .none
        partnerTextField.autocorrectionType = .no
        partnerTextField.returnKeyType = .done
        
        descriptionTextField.delegate = self
        descriptionTextField.autocapitalizationType = .sentences
        descriptionTextField.returnKeyType = .done
        
        sizeTextField.delegate = self
        sizeTextField.autocapitalizationType = .sentences
        sizeTextField.returnKeyType = .done
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        descriptionTextField.resignFirstResponder()
        partnerTextField.resignFirstResponder()
    }
    
    internal static func instantiate(with allItemsTableList: [TableViewFlight]) -> ItineraryOverviewVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItineraryOverviewVC") as! ItineraryOverviewVC
        vc.allItemsTableList = allItemsTableList
        return vc
    }
    
    @IBAction func switchDidChange(_ chikiBrikiVDamku: UISwitch) {
        if chikiBrikiVDamku.isOn {
            switchHeader.text = "Specify the Receiver:"
            sender = true
        }
        else {
            switchHeader.text = "Specify the Sender:"
            sender = false
        }
    }
    
    @IBAction func validateEmail() {
        
        label.isHidden = true
        
        let email = partnerTextField.text!
        let size = sizeTextField.text!
        let description = descriptionTextField.text!
        
        guard !email.isEmpty else {
            label.text = "Please Provide the Email Address of your Receiving/Sending Partner. The partner has to be registered with Nuntii"
            label.isHidden = false
            return
        }
        guard !size.isEmpty else {
            label.text = "Please Provide the Size of Your Parcel"
            label.isHidden = false
            return
        }
        guard !description.isEmpty else {
            label.text = "Please Provide the Description of Your Parcel"
            label.isHidden = false
            return
        }
        
        let newEmail = email.replacingOccurrences(of: ".", with: "__DOT__")
        
        let ownEmail = Auth.auth().currentUser?.email
        let ownNewEmail = ownEmail?.replacingOccurrences(of: ".", with: "__DOT__")
        
        userLookup(newEmail: newEmail, ownNewEmail: ownNewEmail!, sender: sender, id: allItemsTableList[0].id, price: allItemsTableList[0].price, size: size, description: description, date: allItemsTableList[0].dateOrigin)
        
    }
    
    func userLookup(newEmail: String, ownNewEmail: String, sender: Bool, id: String, price: String, size: String, description: String, date: String) {
        
        label.isHidden = true
        
        database.child("userData").observeSingleEvent(of: .value, with: { dataSnapshot in
            
            self.database.child("proposedItineraries").child(date).child(id).child("extra").child("userEmail").observeSingleEvent(of: .value, with: { snapshot in
                
                let nuntiusId = snapshot.value as! String
                
                if ownNewEmail == nuntiusId {
                    self.label.text = "You can't book yourself"
                    self.label.isHidden = false
                }
                else if ownNewEmail == newEmail {
                    self.label.text = "You can't use your email address for your partner waiting hundreds or thousands of kilometers away. Your partner must be registered with Nuntii"
                    self.label.isHidden = false
                }
                else if newEmail == nuntiusId {
                    self.label.text = "Nuntius of this match can't be receiver or sender"
                    self.label.isHidden = false
                }
                else if dataSnapshot.hasChild(newEmail) {
                    
                    self.validateEmailButtton.isHidden = true
                    self.confirmOrderButton.isHidden = false
                    self.changeSenderReceiverButton.isHidden = false
                    self.partnerTextField.isHidden = true
                    self.emailLabel.text = newEmail.replacingOccurrences(of: "__DOT__", with: ".")
                    self.partnerTextField.isHidden = true
                    self.emailLabel.isHidden = false
                    self.switchHeader.isHidden = true
                    self.schalter.isHidden = true
                    self.label1.isHidden = true
                    self.label2.isHidden = true
                    self.senderReceiver.isHidden = true
                    
                    self.emailCloudFunctionsList.removeAll()
                    self.emailCloudFunctionsList.append(EmailCloudFunctionsList(userEmail: ownNewEmail, partnerEmail: newEmail, sender: sender, itineraryId: id, parcelSize: size, parcelDescription: description, price: price, date: date))
                    
                }
                else {
                    self.label.text = "Please make sure that your partner is registered with Nuntii, or check whether you spelled the email address correctly"
                    self.label.isHidden = false
                }
                
            })
            
        })
        
    }
    
    @IBAction func changeSenderReceiver() {
        
        self.label.isHidden = true
        self.validateEmailButtton.isHidden = false
        self.confirmOrderButton.isHidden = true
        self.changeSenderReceiverButton.isHidden = true
        self.partnerTextField.isHidden = false
        self.partnerTextField.isHidden = false
        self.emailLabel.isHidden = true
        self.switchHeader.isHidden = false
        self.schalter.isHidden = false
        self.label1.isHidden = false
        self.label2.isHidden = false
        self.senderReceiver.isHidden = false
        
    }
    
    @IBAction func confirmOrder() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        vc.modalPresentationStyle = .fullScreen
        vc.emailCloudFunctionsList = emailCloudFunctionsList
        present(vc, animated: true)
    }

}


public struct EmailCloudFunctionsList: Codable {
    let userEmail: String
    let partnerEmail: String
    let sender: Bool
    let itineraryId: String
    let parcelSize: String
    let parcelDescription: String
    let price: String
    let date: String
}
