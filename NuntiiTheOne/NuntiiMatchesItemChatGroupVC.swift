//
//  NuntiiMatchesItemChatGroupVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 06/02/2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseDatabase

class NuntiiMatchesItemChatGroupVC: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    
    
    //@IBOutlet var backToMainButton: UIButton!
    
    @IBOutlet var myTable: UITableView!
    
    @IBOutlet var backButton: UIButton!
    
    var selectedNuntiiMatchesList = [NuntiiMatchesItem]()
    
    var messages = [MessageType]()
 
    let currentUser = Sender(senderId: "self", displayName: "Nuntii")
    
    let otherUser = Sender(senderId: "other", displayName: "Julian Angres")
    
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
        
        let role = selectedNuntiiMatchesList[0].role
        let matchId = selectedNuntiiMatchesList[0].matchId
        let date = selectedNuntiiMatchesList[0].date
        
        fetchMessages(date: date, matchId: matchId, ownRole: role)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            /*layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.attributedTextMessageSizeCalculator.incomingAvatarSize = .zero
            layout.attributedTextMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.attributedTextMessageSizeCalculator.avatarLeadingTrailingPadding = .zero*/
            
            layout.setMessageIncomingCellTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: .zero))
            layout.setMessageOutgoingCellTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: .zero))
        }
        
    }
    
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        messageInputBar.invalidatePlugins()
        messageInputBar.inputTextView.resignFirstResponder()
        
        var authorId = "authorId"
        var authorFullName = "authorFullName"
        let senderId = selectedNuntiiMatchesList[0].senderId
        let senderFullName = selectedNuntiiMatchesList[0].senderFullName
        let nuntiusId = selectedNuntiiMatchesList[0].nuntiusId
        let nuntiusFullName = selectedNuntiiMatchesList[0].nuntiusFullName
        let receiverId = selectedNuntiiMatchesList[0].receiverId
        let receiverFullName = selectedNuntiiMatchesList[0].receiverFullName
        let role = selectedNuntiiMatchesList[0].role
        let matchId = selectedNuntiiMatchesList[0].matchId
        let date = selectedNuntiiMatchesList[0].date
        
        if role == "sender" {
            authorId = senderId
            authorFullName = senderFullName
        }
        if role == "nuntius" {
            authorId = nuntiusId
            authorFullName = nuntiusFullName
        }
        if role == "receiver" {
            authorId = receiverId
            authorFullName = receiverFullName
        }
        
        let finalAuthorId = authorId
        let finalAuthorFullName = authorFullName
        
        
        let massage = messageInputBar.inputTextView.text
        messageInputBar.inputTextView.text = ""
        if !massage!.isEmpty {
            let map: [String: Any] = [
                "authorId": finalAuthorId,
                "authorFullName": finalAuthorFullName,
                "authorRole": role,
                "message": massage as Any,
                "timestamp": "timestamp",
            ]
            
            AaaNewPushNotification().chatNotification(senderId: senderId, nuntiusId: nuntiusId, receiverId: receiverId, role: role, message: massage!)
            
            if role != "sender" {
                emailMessage(recipientRaw: senderId, role: role, name: finalAuthorFullName, message: massage!)
            }
            if role != "nuntius" {
                emailMessage(recipientRaw: nuntiusId, role: role, name: finalAuthorFullName, message: massage!)
            }
            if role != "receiver" {
                emailMessage(recipientRaw: receiverId, role: role, name: finalAuthorFullName, message: massage!)
            }
            
            Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").observeSingleEvent(of: .value, with: {snapshot in
                
                let index = snapshot.value
                let newIndex = index as! Int + 1
                let stringIndex = String(newIndex)
                
                Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").setValue(newIndex)
                
                Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").setValue(newIndex)
                Database.database().reference().child("userData").child(nuntiusId).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").setValue(newIndex)
                Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messageCount").setValue(newIndex)
                
                
                
                
                
                
                
                Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("chat").child("messages").child(stringIndex).setValue(map)
                
                Database.database().reference().child("userData").child(senderId).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messages").child(stringIndex).setValue(map)
                Database.database().reference().child("userData").child(nuntiusId).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messages").child(stringIndex).setValue(map)
                Database.database().reference().child("userData").child(receiverId).child("nuntiiMatches").child(date).child(matchId).child("chat").child("messages").child(stringIndex).setValue(map)
                
                
                
            })
            
        }
        
        
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        return
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        return
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        return
    }
    
    
    
    
    
    
    
    
    
    func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        
        //let paragraph = NSMutableParagraphStyle()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {    layout.setMessageIncomingCellTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: .zero))
            layout.setMessageOutgoingCellTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: .zero))
        }
        
        
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1),
                //.paragraphStyle: paragraph
            ]
        )
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 19
    }
    
    
    
    /*@IBAction func backToMain() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemVC") as! NuntiiMatchesItemVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }*/
    
    func fetchMessages(date: String, matchId: String, ownRole: String){
        
        Database.database().reference().child("nuntiiMatches").child(date).child(matchId).child("chat").child("messages").observe(.value, with: {snapshot in
            self.messages.removeAll()
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                
                let role = child.childSnapshot(forPath: "authorRole").value as! String
                var author = "author"
                
                let text = child.childSnapshot(forPath: "message").value as! String
                let timestamp = child.childSnapshot(forPath: "timestamp").value as! String
                
                if role  == ownRole {
                    author = "You (" +  role + ")"
                    
                    self.messages.append(Message(sender: Sender(senderId: "self", displayName: author), messageId: child.key, sentDate: Date(), kind: .text(text)))
                }
                else {
                    author = child.childSnapshot(forPath: "authorFullName").value as! String + " (" + role + ")"
                    
                    self.messages.append(Message(sender: Sender(senderId: "other", displayName: author), messageId: child.key, sentDate: Date(), kind: .text(text)))
                }
                
            }
            
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
            
        })
        
    }
    
    @IBAction func backTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemVC") as! NuntiiMatchesItemVC
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}

struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
    
    
}

struct Message: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    
}
