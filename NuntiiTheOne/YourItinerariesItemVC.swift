//
//  YourItinerariesItemVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 10/02/2022.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

class YourItinerariesItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let database = Database.database().reference()
    
    @IBOutlet var table: UITableView!
    
    var allItemsTableList = [TableViewFlight]()
    
    var selectedProposedItineraryList = [ProposedItineraryItem]()
    
    
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
        
        table.register(FlightTableViewCell.nib(), forCellReuseIdentifier: FlightTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        let email = FirebaseAuth.Auth.auth().currentUser?.email
        let newEmail = email?.replacingOccurrences(of: ".", with: "__DOT__")
        
        database.child("userData").child(newEmail!).child("proposedItineraries").child(selectedProposedItineraryList[0].dateItinerary).child(selectedProposedItineraryList[0].id).observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                
                var iataOrigin = ""
                var iataDestination = ""
                var dateDestination = ""
                var timeDestination = ""
                var airportDestination = ""
                var dateOrigin = ""
                var timeOrigin = ""
                var airportOrigin = ""
                var flightNumber = ""
                
                if let nestedData = child.value as? [String: String] {
                    iataOrigin = nestedData["iataOrigin"]!
                    iataDestination = nestedData["iataDestination"]!
                    dateDestination = nestedData["dateDestination"]!
                    timeDestination = nestedData["timeDestination"]!
                    airportDestination = nestedData["airportDestination"]!
                    dateOrigin = nestedData["dateOrigin"]!
                    timeOrigin = nestedData["timeOrigin"]!
                    airportOrigin = nestedData["airportOrigin"]!
                    flightNumber = nestedData["flightNumber"]!
                }
                
                self.allItemsTableList.append(TableViewFlight(iataOrigin: iataOrigin, iataDestination: iataDestination, airportOrigin: airportOrigin, dateOrigin: dateOrigin, timeOrigin: timeOrigin, airportDestination: airportDestination, dateDestination: dateDestination, timeDestination: timeDestination, flightNumber: flightNumber, nuntius: "", price: "", oriLat: 0, oriLon: 0, desLat: 0, desLon: 0, id: ""))
                
                self.table.reloadData()
                
            }
            
        })
        
    }
    
    
    internal static func instantiate(with selectedProposedItineraryList: [ProposedItineraryItem]) -> YourItinerariesItemVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YourItinerariesItemVC") as! YourItinerariesItemVC
        vc.selectedProposedItineraryList = selectedProposedItineraryList
        return vc
    }
    
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItemsTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FlightTableViewCell.identifier, for: indexPath) as! FlightTableViewCell
        cell.configure(with: allItemsTableList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 322
    }
    
    
    @IBAction func openMainVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "YourItinerariesVC") as! YourItinerariesVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func deleteItinerary() {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Deletion", message: "Are you sure you want to delete the itinerary?", preferredStyle: .alert)

        // Create the action for confirming
        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            let email = FirebaseAuth.Auth.auth().currentUser?.email
            let newEmail = email?.replacingOccurrences(of: ".", with: "__DOT__")
            self.database.child("userData").child(newEmail!).child("proposedItineraries").child(self.selectedProposedItineraryList[0].dateItinerary).child(self.selectedProposedItineraryList[0].id).setValue(nil)
            self.database.child("proposedItineraries").child(self.selectedProposedItineraryList[0].dateItinerary).child(self.selectedProposedItineraryList[0].id).setValue(nil)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        }

        // Create the action for canceling
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // Handle cancellation
        }

        // Add the actions to the alert controller
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }

}


