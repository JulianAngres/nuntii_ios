//
//  EmailCloudFunctions.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 20/01/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseFunctions

var originalSenderId = "senderId"
var originalReceiverId = "receiverId"
var functions = Functions.functions()

public func emailCloudFunctions(emailCloudFunctionsList: [EmailCloudFunctionsList], eigenPreis: String) {
    
    let userEmail = emailCloudFunctionsList[0].userEmail
    let partnerEmail = emailCloudFunctionsList[0].partnerEmail
    let sender = emailCloudFunctionsList[0].sender
    let itineraryId = emailCloudFunctionsList[0].itineraryId
    let parcelSize = emailCloudFunctionsList[0].parcelSize
    let parcelDescription = emailCloudFunctionsList[0].parcelDescription
    let price = emailCloudFunctionsList[0].price
    let date = emailCloudFunctionsList[0].date
    
    print("Weißbier ist eine gute Gabe Gottes.")
    
    if sender {
        originalSenderId = userEmail
        originalReceiverId = partnerEmail
    }
    else {
        originalSenderId = partnerEmail
        originalReceiverId = userEmail
    }
    
    let senderId = originalSenderId
    let receiverId = originalReceiverId
    
    Database.database().reference().child("proposedItineraries").child(date).child(itineraryId).child("extra").observeSingleEvent(of: .value, with: { snapshot in
        
        let nuntiusId = snapshot.childSnapshot(forPath: "userEmail").value
        let nuntiusFullName = snapshot.childSnapshot(forPath: "fullName").value
        
        Database.database().reference().child("userData").child(senderId).child("fullName").observeSingleEvent(of: .value, with: { snapshot in
            
            let senderFullName = snapshot.value
            
            Database.database().reference().child("userData").child(receiverId).child("fullName").observeSingleEvent(of: .value, with: { snapshot in
                
                let receiverFullName = snapshot.value
                
                Database.database().reference().child("nuntiiMatchesCount").observeSingleEvent(of: .value, with: { snapshot in
                    
                    let id = snapshot.value as! Int + 1
                    Database.database().reference().child("nuntiiMatchesCount").setValue(id)
                    let matchId = "Nuntii" + String(id)
                    
                    let map: [String: Any] = [
                        "senderId": senderId,
                        "senderFullName": senderFullName!,
                        "nuntiusId": nuntiusId!,
                        "nuntiusFullName": nuntiusFullName!,
                        "receiverId": receiverId,
                        "receiverFullName": receiverFullName!,
                        "itineraryId": itineraryId,
                        "parcelSize": parcelSize,
                        "parcelDescription": parcelDescription,
                        "price": price,
                        "date": date
                    ]
                    
                    Database.database().reference().child("nuntiiMatches").child(date).child(matchId).setValue(map)
                    
                    Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).setValue(map)
                    Database.database().reference().child("userData").child(nuntiusId as! String).child("nuntiiMatches").child(date).child(matchId).setValue(map)
                    Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).setValue(map)
                    
                    Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).child("role").setValue("sender")
                    Database.database().reference().child("userData").child(nuntiusId as! String).child("nuntiiMatches").child(date).child(matchId).child("role").setValue("nuntius")
                    Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).child("role").setValue("receiver")
                    
                    Database.database().reference().child("userData").child(nuntiusId as! String).child("proposedItineraries").child(date).child(itineraryId).setValue(nil)
                    Database.database().reference().child("proposedItineraries").child(date).child(itineraryId).setValue(nil)
                    
                    saveOriginDestination(date: date, itineraryId: itineraryId, matchId: matchId, senderId: senderId, nuntiusId: nuntiusId as! String, receiverId: receiverId, userEmail: userEmail, amount: price, eigenPreis: eigenPreis)
                    
                    
                    
                    
                    Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").setValue(0)
                    
                    Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").setValue(0)
                    Database.database().reference().child("userData").child(nuntiusId as! String).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").setValue(0)
                    Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").setValue(0)
                    
                    
                    
                    Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("confirmed").setValue("false")
                    
                    Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).child("confirmed").setValue("false")
                    Database.database().reference().child("userData").child(nuntiusId as! String).child("nuntiiMatches").child(date).child(matchId).child("confirmed").setValue("false")
                    Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).child("confirmed").setValue("false")
                    
                    emailMatch(recipientRaw: userEmail)
                    
                    emailMatch(recipientRaw: partnerEmail)
                    
                    emailMatch(recipientRaw: nuntiusId as! String)
                    
                    AaaNewPushNotification().matchNotification(ownNewEmail: userEmail, newEmail: partnerEmail, id: matchId, date: date, nuntiusId: nuntiusId as! String)
                    
                    
                    
                })
                
            })
            
        })
        
    })
    
}

func saveOriginDestination(date: String, itineraryId: String, matchId: String, senderId: String, nuntiusId: String, receiverId: String, userEmail: String, amount: String, eigenPreis: String) {
    
    Database.database().reference().child("allItineraries").child(date).child(itineraryId).child("legs").observeSingleEvent(of: .value, with: { snapshot in
        
        let count = snapshot.childrenCount
        let lastIndex = String(count - 1)
        
        let itineraryOrigin = snapshot.childSnapshot(forPath: "0").childSnapshot(forPath: "iataOrigin").value
        let itineraryDestination = snapshot.childSnapshot(forPath: lastIndex).childSnapshot(forPath: "iataDestination").value
        
        
        
        emailBill(recipientRaw: userEmail, amount: eigenPreis, origin: itineraryOrigin as! String, destination: itineraryDestination as! String)
        
        Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("itineraryOrigin").setValue(itineraryOrigin)
        Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).child("itineraryOrigin").setValue(itineraryOrigin)
        Database.database().reference().child("userData").child(nuntiusId).child("nuntiiMatches").child(date).child(matchId).child("itineraryOrigin").setValue(itineraryOrigin)
        Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).child("itineraryOrigin").setValue(itineraryOrigin)
        Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("itineraryDestination").setValue(itineraryDestination)
        Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).child("itineraryDestination").setValue(itineraryDestination)
        Database.database().reference().child("userData").child(nuntiusId).child("nuntiiMatches").child(date).child(matchId).child("itineraryDestination").setValue(itineraryDestination)
        Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).child("itineraryDestination").setValue(itineraryDestination)
        
    })
    
}

func emailMatch(recipientRaw: String) {
    
    var recipient = recipientRaw.replacingOccurrences(of: "__DOT__", with: ".")
    
    functions.httpsCallable("emailMatch").call(["subject": "subject", "text": "text", "recipient": recipient]) { result, error in
        if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let code = FunctionsErrorCode(rawValue: error.code)
              let message = error.localizedDescription
              let details = error.userInfo[FunctionsErrorDetailsKey]
            }
        }
    }
    
}

func emailBill(recipientRaw: String, amount: String, origin: String, destination: String) {
    
    var recipient = recipientRaw.replacingOccurrences(of: "__DOT__", with: ".")
    
    functions.httpsCallable("emailBill").call(["amount": amount, "origin": origin, "destination": destination, "recipient": recipient]) { result, error in
        if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let code = FunctionsErrorCode(rawValue: error.code)
              let message = error.localizedDescription
              let details = error.userInfo[FunctionsErrorDetailsKey]
            }
        }
    }
    
}

public func emailMessage(recipientRaw: String, role: String, name: String, message: String) {
    
    var recipient = recipientRaw.replacingOccurrences(of: "__DOT__", with: ".")
    
    functions.httpsCallable("emailMessage").call(["role": role, "name": name, "message": message, "recipient": recipient]) { result, error in
        if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let code = FunctionsErrorCode(rawValue: error.code)
              let message = error.localizedDescription
              let details = error.userInfo[FunctionsErrorDetailsKey]
            }
        }
    }
    
}
