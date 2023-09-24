//
//  YourItinerariesVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 27/01/2022.
//

import FirebaseDatabase
import FirebaseAuth
import UIKit

class YourItinerariesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let database = Database.database().reference()
    
    @IBOutlet var table: UITableView!
    
    var proposedItineraryList = [ProposedItineraryItem]()
    
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
        
        table.register(ProposedItinerariesTableViewCell.nib(), forCellReuseIdentifier: ProposedItinerariesTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        showTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
   /* @IBAction func openMainVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proposedItineraryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProposedItinerariesTableViewCell.identifier, for: indexPath) as! ProposedItinerariesTableViewCell
        cell.configure(with: proposedItineraryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*let dateItinerary = proposedItineraryList[indexPath.row].dateItinerary
        let itineraryOrigin = proposedItineraryList[indexPath.row].itineraryOrigin
        let itineraryDestination = proposedItineraryList[indexPath.row].itineraryDestination
        let id = proposedItineraryList[indexPath.row].id
        
        let selectedProposedItineraryList = [ProposedItineraryItem(dateItinerary: dateItinerary, itineraryOrigin: itineraryOrigin, itineraryDestination: itineraryDestination, id: id)]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "YourItinerariesItemVC") as! YourItinerariesItemVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedProposedItineraryList = selectedProposedItineraryList
        present(vc, animated: true)*/
        performSegue(withIdentifier: "itineraryItem", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! YourItinerariesItemVC
        let customIndexPath = self.table.indexPathForSelectedRow
        
        let dateItinerary = proposedItineraryList[customIndexPath!.row].dateItinerary
        let itineraryOrigin = proposedItineraryList[customIndexPath!.row].itineraryOrigin
        let itineraryDestination = proposedItineraryList[customIndexPath!.row].itineraryDestination
        let id = proposedItineraryList[customIndexPath!.row].id
        
        let selectedProposedItineraryList = [ProposedItineraryItem(dateItinerary: dateItinerary, itineraryOrigin: itineraryOrigin, itineraryDestination: itineraryDestination, id: id)]
        vc.selectedProposedItineraryList = selectedProposedItineraryList
        
    }
    
    
    @objc private func showTable() {
        let email = FirebaseAuth.Auth.auth().currentUser?.email
        guard let newEmail = email?.replacingOccurrences(of: ".", with: "__DOT__") else { return }
        
        var datesOrigin = [String]()
        var iatasOrigin = [String]()
        var iatasDestination = [String]()
        
        self.database.child("userData").child(newEmail).child("proposedItineraries").observeSingleEvent(of: .value, with: { snapshot in
            
            datesOrigin.removeAll()
            iatasOrigin.removeAll()
            iatasDestination.removeAll()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                for child in childSnapshot.children {
                    let grandChildSnapshot = child as! DataSnapshot
                    let key = grandChildSnapshot.key
                    
                    for child in grandChildSnapshot.children {
                        let greatGrandChildSnapshot = child as! DataSnapshot
                        
                        var dateOrigin = ""
                        var iataOrigin = ""
                        var iataDestination = ""
                        
                        if let nestedData = greatGrandChildSnapshot.value as? [String: String] {
                            dateOrigin = nestedData["dateOrigin"]!
                            iataOrigin = nestedData["iataOrigin"]!
                            iataDestination = nestedData["iataDestination"]!
                            
                            datesOrigin.append(dateOrigin)
                            iatasOrigin.append(iataOrigin)
                            iatasDestination.append(iataDestination)
                        }
                    }
                    
                    if !self.noPastItineraries(dateOrigin: datesOrigin[0] + " 11:00") {
                        self.proposedItineraryList.append(ProposedItineraryItem(dateItinerary: datesOrigin[0], itineraryOrigin: iatasOrigin[0], itineraryDestination: iatasDestination[iatasDestination.count - 1], id: key))
                    }
                    
                    datesOrigin.removeAll()
                    iatasOrigin.removeAll()
                    iatasDestination.removeAll()
                    
                }
                
            }
            
            self.table.reloadData()
            
        })
        
        
    }
    
    func noPastItineraries(dateOrigin: String) -> Bool {
        
        let now = Date() - 86400
        
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

struct ProposedItineraryItem: Codable {
    let dateItinerary: String
    let itineraryOrigin: String
    let itineraryDestination: String
    let id: String
}
