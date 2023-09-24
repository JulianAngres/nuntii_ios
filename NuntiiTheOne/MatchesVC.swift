//
//  MatchesVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 27/01/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MatchesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet var table: UITableView!
    
    var nuntiiMatchesList = [NuntiiMatchesItem]()
    
    /*private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Matches"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()*/
    
    /*private let backToMain: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back To Main", for: .normal)
        return button
    }()*/
    
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
        
        
        
        let nib = UINib(nibName: "MatchesCell", bundle: nil)
        self.table.register(nib, forCellReuseIdentifier: "MatchesCell")
        self.table.delegate = self
        self.table.dataSource = self
        
        
        //view.addSubview(label)
        //view.addSubview(backToMain)
        //backToMain.addTarget(self, action: #selector(backToMainTapped), for: .touchUpInside)
        
        let ownEmail = Auth.auth().currentUser?.email
        let ownNewEmail = (ownEmail?.replacingOccurrences(of: ".", with: "__DOT__"))!
        
        Database.database().reference().child("userData").child(ownNewEmail).child("nuntiiMatches").observeSingleEvent(of: .value, with: {snapshot in
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                
                for grandChild in child.children {
                    let grandChild = grandChild as! DataSnapshot
                    
                    let matchId = grandChild.key
                    let date = grandChild.childSnapshot(forPath: "date").value
                    let itineraryId = grandChild.childSnapshot(forPath: "itineraryId").value
                    let nuntiusFullName = grandChild.childSnapshot(forPath: "nuntiusFullName").value
                    let nuntiusId = grandChild.childSnapshot(forPath: "nuntiusId").value
                    let parcelDescription = grandChild.childSnapshot(forPath: "parcelDescription").value
                    let parcelSize = grandChild.childSnapshot(forPath: "parcelSize").value
                    let price = grandChild.childSnapshot(forPath: "price").value
                    let receiverFullName = grandChild.childSnapshot(forPath: "receiverFullName").value
                    let receiverId = grandChild.childSnapshot(forPath: "receiverId").value
                    let role = grandChild.childSnapshot(forPath: "role").value
                    let senderFullName = grandChild.childSnapshot(forPath: "senderFullName").value
                    let senderId = grandChild.childSnapshot(forPath: "senderId").value
                    let itineraryOrigin = grandChild.childSnapshot(forPath: "itineraryOrigin").value
                    let itineraryDestination = grandChild.childSnapshot(forPath: "itineraryDestination").value
                    
                    if !self.noPastMatches(dateOrigin: date as! String + " 11:00") {
                    self.nuntiiMatchesList.append(NuntiiMatchesItem(date: date as! String, matchId: matchId, itineraryId: itineraryId as! String, nuntiusFullName: nuntiusFullName as! String, nuntiusId: nuntiusId as! String, parcelDescription: parcelDescription as! String, parcelSize: parcelSize as! String, price: price as! String, receiverFullName: receiverFullName as! String, receiverId: receiverId as! String, role: role as! String, senderFullName: senderFullName as! String, senderId: senderId as! String, itineraryOrigin: itineraryOrigin as! String, itineraryDestination: itineraryDestination as! String))
                    }
                    
                    self.table.reloadData()
                    
                    
                }
            }
            
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //label.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 80)
        
        //backToMain.frame = CGRect(x: 20, y: table.frame.origin.y + table.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
    }
    
    @objc private func backToMainTapped() {
        openMainVC()
    }
    
    @IBAction func openMainVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchesCell", for: indexPath)
        cell.textLabel?.text = "Hello World!"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }*/
    
    
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nuntiiMatchesList.count
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: MatchesCell.identifier, for: indexPath) as! MatchesCell
        cell.configure(with: nuntiiMatchesList[indexPath.row])
        return cell
    }
    
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*let dateItinerary = nuntiiMatchesList[indexPath.row].date
        let itineraryOrigin = nuntiiMatchesList[indexPath.row].itineraryOrigin
        let itineraryDestination = nuntiiMatchesList[indexPath.row].itineraryDestination
        let id = nuntiiMatchesList[indexPath.row].matchId*/
        
        //let selectedNuntiiMatchesList = [nuntiiMatchesList[indexPath.row]]
        
        //let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemVC") as! NuntiiMatchesItemVC
        //vc.modalPresentationStyle = .fullScreen
        //vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        //present(vc, animated: true)
        
        //prepare(segue: UIStoryboardSegue(identifier: "matchItem", source: self, destination: NuntiiMatchesItemVC()), sender: nil, selectedNuntiiMatchesList: selectedNuntiiMatchesList)
        performSegue(withIdentifier: "matchItem", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! NuntiiMatchesItemVC
        let customIndexPath = self.table.indexPathForSelectedRow
        let selectedNuntiiMatchesList = [nuntiiMatchesList[customIndexPath!.row]]
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        
    }
    
    func noPastMatches(dateOrigin: String) -> Bool {
        
        let now = Date() - 259200
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let then = formatter.date(from: dateOrigin)!
        
        if then > now {
            return false
        }
        return true
        
    }

}


public struct NuntiiMatchesItem: Codable {
    let date: String
    let matchId: String
    let itineraryId: String
    let nuntiusFullName: String
    let nuntiusId: String
    let parcelDescription: String
    let parcelSize: String
    let price: String
    let receiverFullName: String
    let receiverId: String
    let role: String
    let senderFullName: String
    let senderId: String
    let itineraryOrigin: String
    let itineraryDestination: String
}
