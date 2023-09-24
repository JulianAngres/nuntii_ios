//
//  AaaNewPushNotification.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 27/01/2023.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseFunctions


class AaaNewPushNotification {
    
    
    func receptionNotification(nuntiusId: String) {
        
        Database.database().reference().child("userData").child(nuntiusId).child("messagingToken").observeSingleEvent(of: .value, with: {snapshot in
            
            let nuntiusToken = snapshot.value
            
            functions.httpsCallable("iosUpstreamReception").call(["title": "Woohoo!", "boody": "The reception of your parcel is confirmed. You can now retrieve your earnings.", "message": "The reception of your parcel is confirmed. You can now retrieve your earnings.", "token": nuntiusToken]) { result, error in
                
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        _ = FunctionsErrorCode(rawValue: error.code)
                        _ = error.localizedDescription
                        _ = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
            }
            
        })
        
    }
    
    
    func chatNotification(senderId: String, nuntiusId: String, receiverId: String, role: String, message: String) {
        
        Database.database().reference().child("userData").child(senderId).child("messagingToken").observeSingleEvent(of: .value, with: {snapshot in
            
            let senderToken = snapshot.value
            
            Database.database().reference().child("userData").child(nuntiusId).child("messagingToken").observeSingleEvent(of: .value, with: {snapshot in
                
                let nuntiusToken = snapshot.value
                
                Database.database().reference().child("userData").child(receiverId).child("messagingToken").observeSingleEvent(of: .value, with: {snapshot in
                    
                    let receiverToken = snapshot.value
                    
                    if role != "sender" {
                        functions.httpsCallable("iosUpstreamChat").call(["title": "New Nuntii Message", "boody": message, "message": message, "token": senderToken]) { result, error in
                            
                            if let error = error as NSError? {
                                if error.domain == FunctionsErrorDomain {
                                    _ = FunctionsErrorCode(rawValue: error.code)
                                    _ = error.localizedDescription
                                    _ = error.userInfo[FunctionsErrorDetailsKey]
                                }
                            }
                        }
                    }
                    
                    if role != "nuntius" {
                        functions.httpsCallable("iosUpstreamChat").call(["title": "New Nuntii Message", "boody": message, "message": message, "token": nuntiusToken]) { result, error in
                            
                            if let error = error as NSError? {
                                if error.domain == FunctionsErrorDomain {
                                    _ = FunctionsErrorCode(rawValue: error.code)
                                    _ = error.localizedDescription
                                    _ = error.userInfo[FunctionsErrorDetailsKey]
                                }
                            }
                        }
                    }
                    
                    if role != "receiver" {
                        functions.httpsCallable("iosUpstreamChat").call(["title": "New Nuntii Message", "boody": message, "message": message, "token": receiverToken]) { result, error in
                            
                            if let error = error as NSError? {
                                if error.domain == FunctionsErrorDomain {
                                    _ = FunctionsErrorCode(rawValue: error.code)
                                    _ = error.localizedDescription
                                    _ = error.userInfo[FunctionsErrorDetailsKey]
                                }
                            }
                        }
                    }
                    
                })
                
            })
            
        })
        
    }
    
    
    func matchNotification(ownNewEmail: String, newEmail: String, id: String, date: String, nuntiusId: String) {
        print(ownNewEmail)
        print(nuntiusId)
            
            Database.database().reference().child("userData").child(ownNewEmail).child("messagingToken").observeSingleEvent(of: .value, with: {snapshot1 in
                
                let ownToken = snapshot1.value
                
                Database.database().reference().child("userData").child(newEmail).child("messagingToken").observeSingleEvent(of: .value, with: {snapshot2 in
                    
                    let partnerToken = snapshot2.value
                    
                    Database.database().reference().child("userData").child(nuntiusId).child("messagingToken").observeSingleEvent(of: .value, with: {snapshot3 in
                        
                        let nuntiusToken = snapshot3.value
                        
                        functions.httpsCallable("iosUpstreamMatch").call(["title": "Congratulations", "boody": "You just got a Nuntii match on your journey!", "message": "You just got a Nuntii match on your journey!", "token": nuntiusToken]) { result, error in
                            
                            if let error = error as NSError? {
                                if error.domain == FunctionsErrorDomain {
                                    _ = FunctionsErrorCode(rawValue: error.code)
                                    _ = error.localizedDescription
                                    _ = error.userInfo[FunctionsErrorDetailsKey]
                                }
                            }
                        }
                        
                        functions.httpsCallable("iosUpstreamMatch").call(["title": "Congratulations", "boody": "You have been pointed out by your partner to be part of a Nuntii match!", "message": "You have been pointed out by your partner to be part of a Nuntii match!", "token": partnerToken]) { result, error in
                            
                            if let error = error as NSError? {
                                if error.domain == FunctionsErrorDomain {
                                    _ = FunctionsErrorCode(rawValue: error.code)
                                    _ = error.localizedDescription
                                    _ = error.userInfo[FunctionsErrorDetailsKey]
                                }
                            }
                        }
                        
                        functions.httpsCallable("iosUpstreamMatch").call(["title": "Congratulations", "boody": "You just created a Nuntii match!", "message": "You just created a Nuntii match!", "token": ownToken]) { result, error in
                            
                            if let error = error as NSError? {
                                if error.domain == FunctionsErrorDomain {
                                    _ = FunctionsErrorCode(rawValue: error.code)
                                    _ = error.localizedDescription
                                    _ = error.userInfo[FunctionsErrorDetailsKey]
                                }
                            }
                        }
                        
                    })
                    
                })
                
            })
            
        
        
        
        
    }
    
}
