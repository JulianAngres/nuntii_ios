//
//  NuntiiMatchesItemConfirmReceptionVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 06/02/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseFunctions

class NuntiiMatchesItemConfirmReceptionVC: UIViewController {
    
    var selectedNuntiiMatchesList = [NuntiiMatchesItem]()
    var functions = Functions.functions()
    
    var finalConfirmList = [FinalConfirmList]()
    
    @IBOutlet var backToMainButton: UIButton!
    
    @IBOutlet var confirmedReceptionLabel: UILabel!
    @IBOutlet var finalConfirmButton: UIButton!
    
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
        
        Database.database().reference().child("nuntiiMatches").child(selectedNuntiiMatchesList[0].date).child(selectedNuntiiMatchesList[0].matchId).child("confirmed").observeSingleEvent(of: .value, with: { snapshot in
            
            let confirmed = snapshot.value
            
            Database.database().reference().child("allItineraries").child(self.selectedNuntiiMatchesList[0].date).child(self.selectedNuntiiMatchesList[0].itineraryId).child("legs").observeSingleEvent(of: .value, with: {snapshot in
                
                let index = snapshot.childrenCount - 1
                let ind = String(index)
                
                let arrivalDate = snapshot.childSnapshot(forPath: ind).childSnapshot(forPath: "dateDestination").value as! String
                let arrivalTime = snapshot.childSnapshot(forPath: ind).childSnapshot(forPath: "timeDestination").value as! String
                let origin = snapshot.childSnapshot(forPath: ind).childSnapshot(forPath: "iataOrigin").value
                let destination = snapshot.childSnapshot(forPath: ind).childSnapshot(forPath: "iataDestination").value
                let dateCheck = arrivalDate + " " + arrivalTime
                
                
                if confirmed as! String == "true" {
                    
                    self.confirmedReceptionLabel.text = "Reception already confirmed"
                    self.finalConfirmButton.isHidden = true
                }
                else if self.receptionNotYet(dateOrigin: dateCheck) {
                    
                    self.confirmedReceptionLabel.text = "Earliest time of reception: ETA of last flight"
                    self.finalConfirmButton.isHidden = true
                }
                else if !self.receptionNotYet(dateOrigin: dateCheck) {
                
                    //self.finalConfirm(list: [self.selectedNuntiiMatchesList[0].date, self.selectedNuntiiMatchesList[0].nuntiusId, self.selectedNuntiiMatchesList[0].senderId, self.selectedNuntiiMatchesList[0].receiverId, self.selectedNuntiiMatchesList[0].matchId, self.selectedNuntiiMatchesList[0].price, origin as! String, destination as! String])
                    
                    self.finalConfirmList.append(FinalConfirmList(date: self.selectedNuntiiMatchesList[0].date, nuntiusId: self.selectedNuntiiMatchesList[0].nuntiusId, senderId: self.selectedNuntiiMatchesList[0].senderId, receiverId: self.selectedNuntiiMatchesList[0].receiverId, matchId: self.selectedNuntiiMatchesList[0].matchId, price: self.selectedNuntiiMatchesList[0].price, origin: origin as! String, destination: destination as! String))
                    
                    self.finalConfirmButton.isHidden = false
                    
                }
                else {
                    self.finalConfirmButton.isHidden = true
                    self.confirmedReceptionLabel.text = "Server Error"
                }
                
                
            })
            
        })
        
    }
    
    @IBAction func finalConfirm() {
        
        let date = finalConfirmList[0].date
        let nuntiusId = finalConfirmList[0].nuntiusId
        let senderId = finalConfirmList[0].senderId
        let receiverId = finalConfirmList[0].receiverId
        let matchId = finalConfirmList[0].matchId
        let price = finalConfirmList[0].price
        let origin = finalConfirmList[0].origin
        let destination = finalConfirmList[0].destination
        
        Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("confirmed").setValue("true")
        
        Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).child("confirmed").setValue("true")
        Database.database().reference().child("userData").child(nuntiusId).child("nuntiiMatches").child(date).child(matchId).child("confirmed").setValue("true")
        Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).child("confirmed").setValue("true")
        
        Database.database().reference().child("userData").child(nuntiusId).child("payoutBalance").observeSingleEvent(of: .value, with: { snapshot in
            
            let payoutBalanceOld = snapshot.value as! Double
            
            Database.database().reference().child("goldenRatio").observeSingleEvent(of: .value, with: {snapshot in
                
                let goldenRatio = snapshot.value as! Double
                
                let deductedPrice = Double(price)!*Double(goldenRatio)
                
                
                let payoutBalanceNew = payoutBalanceOld + deductedPrice
                
                Database.database().reference().child("userData").child(nuntiusId).child("payoutBalance").setValue(payoutBalanceNew)
                
                self.finalConfirmButton.isHidden = true
                
                AaaNewPushNotification().receptionNotification(nuntiusId: nuntiusId)
                
                self.emailReception(recipientRaw: nuntiusId, name: nuntiusId, origin: origin, destination: destination)
                
                self.backToMain()
            })
            
        })
        
    }
    
    func receptionNotYet(dateOrigin: String) -> Bool {
        
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let then = formatter.date(from: dateOrigin)!
        
        if then > now {
            return true
        }
        return false
        
    }
    
    func emailReception(recipientRaw: String, name: String, origin: String, destination: String) {
        
        var recipient = recipientRaw.replacingOccurrences(of: "__DOT__", with: ".")
        var nameNew = name.replacingOccurrences(of: "__DOT__", with: ".")
        
        functions.httpsCallable("emailReception").call(["subject": "subject", "text": "text", "recipient": recipient, "name": nameNew, "origin": origin, "destination": destination]) { result, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                  let code = FunctionsErrorCode(rawValue: error.code)
                  let message = error.localizedDescription
                  let details = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
        }
        
    }
    
    func backToMain() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}

public struct FinalConfirmList: Codable {
    let date: String
    let nuntiusId: String
    let senderId: String
    let receiverId: String
    let matchId: String
    let price: String
    let origin: String
    let destination: String
}
