//
//  NuntiiMatchesItemVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 03/02/2023.
//

import UIKit
import FirebaseDatabase

class NuntiiMatchesItemVC: UIViewController {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var headerSenderLabel: UILabel!
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var headerNuntiusLabel: UILabel!
    @IBOutlet var nuntiusLabel: UILabel!
    @IBOutlet var headerReceiverLabel: UILabel!
    @IBOutlet var receiverLabel: UILabel!
    @IBOutlet var chatGroupButton: UIButton!
    @IBOutlet var parcelDataButton: UIButton!
    @IBOutlet var itineraryDataButton: UIButton!
    @IBOutlet var confirmReceptionButton: UIButton!
    @IBOutlet var reportProblemButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    
    var eigenPreis: Int = 1
    var selectedNuntiiMatchesList = [NuntiiMatchesItem]()
    
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

        confirmReceptionButton.isHidden = true
        
        /*if selectedNuntiiMatchesList[0].role == "receiver" {
            confirmReceptionButton.isHidden = false
        }*/
        
        dateLabel.textColor = .blue
        dateLabel.text = selectedNuntiiMatchesList[0].date
        
        if selectedNuntiiMatchesList[0].role == "sender" {
            headerSenderLabel.text = "Sender (You):"
        }
        
        if selectedNuntiiMatchesList[0].role == "nuntius" {
            headerNuntiusLabel.text = "Nuntius (You):"
        }
        
        if selectedNuntiiMatchesList[0].role == "receiver" {
            headerReceiverLabel.text = "Receiver (You):"
        }
        
        senderLabel.text = selectedNuntiiMatchesList[0].senderFullName
        nuntiusLabel.text = selectedNuntiiMatchesList[0].nuntiusFullName
        receiverLabel.text = selectedNuntiiMatchesList[0].receiverFullName
        
        senderLabel.textColor = .brown
        nuntiusLabel.textColor = .brown
        receiverLabel.textColor = .brown
        
        Database.database().reference().child("eigenPreis").observeSingleEvent(of: .value, with: {snapshot in
            self.eigenPreis = snapshot.value as! Int
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination.title == "NuntiiMatchesItemChatGroupVC" {
            let vc = segue.destination as! NuntiiMatchesItemChatGroupVC
            vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        }
        else if segue.destination.title == "NuntiiMatchesItemItineraryDataVC" {
            let vc = segue.destination as! NuntiiMatchesItemItineraryDataVC
            vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        }
        else if segue.destination.title == "NuntiiMatchesItemParcelVC" {
            let vc = segue.destination as! NuntiiMatchesItemParcelVC
            vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
            vc.eigenPreis = eigenPreis
        }
        else if segue.destination.title == "NuntiiMatchesItemConfirmReceptionVC" {
            let vc = segue.destination as! NuntiiMatchesItemConfirmReceptionVC
            vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        }
        else if segue.destination.title == "NuntiiMatchesItemProblemVC" {
            let vc = segue.destination as! NuntiiMatchesItemProblemVC
            vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        }
    }
    
    /*@IBAction func chatGroup() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemChatGroupVC") as! NuntiiMatchesItemChatGroupVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }
    
    @IBAction func parcelData() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemParcelVC") as! NuntiiMatchesItemParcelVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }
    
    @IBAction func itineraryData() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemItineraryDataVC") as! NuntiiMatchesItemItineraryDataVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }
    
    @IBAction func confirmReception() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemConfirmReceptionVC") as! NuntiiMatchesItemConfirmReceptionVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }
    
    @IBAction func reportProblem() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemProblemVC") as! NuntiiMatchesItemProblemVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }*/
    
    @IBAction func backTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MatchesVC") as! MatchesVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}
