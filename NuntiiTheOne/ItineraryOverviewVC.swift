//
//  ItineraryOverviewVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 02/02/2022.
//

import FirebaseDatabase
import FirebaseAuth
import UIKit

class ItineraryOverviewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let database = Database.database().reference()
    
    @IBOutlet var table: UITableView!
    
    var allItemsTableList = [TableViewFlight]()
    
    
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
    }
    
    
    internal static func instantiate(with allItemsTableList: [TableViewFlight]) -> ItineraryOverviewVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItineraryOverviewVC") as! ItineraryOverviewVC
        vc.allItemsTableList = allItemsTableList
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
    
    
    
    
    
    
    @IBAction func addConnectionTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddItineraryVC") as! AddItineraryVC
        
        vc.allItemsTableList = allItemsTableList
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func deleteItineraryTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddItineraryVC") as! AddItineraryVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func confirmItineraryTapped() {
        
        saveToDB()
        
    }
    
    @objc private func saveToDB() {
        
        self.database.child("proposedItinerariesCount").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? Int else {
                return
            }
            let id = value + 1
            let email = FirebaseAuth.Auth.auth().currentUser?.email
            let newEmail = email?.replacingOccurrences(of: ".", with: "__DOT__")
            let date = self.allItemsTableList[0].dateOrigin
            
            self.database.child("proposedItinerariesCount").setValue(id)
            
            for i in 0...self.allItemsTableList.count - 1 {
                let map: [String: Any] = [
                    "iataOrigin": self.allItemsTableList[i].iataOrigin as NSObject,
                    "airportOrigin": self.allItemsTableList[i].airportOrigin,
                    "dateOrigin": self.allItemsTableList[i].dateOrigin,
                    "timeOrigin": self.allItemsTableList[i].timeOrigin,
                    "iataDestination": self.allItemsTableList[i].iataDestination,
                    "airportDestination": self.allItemsTableList[i].airportDestination,
                    "dateDestination": self.allItemsTableList[i].dateDestination,
                    "timeDestination": self.allItemsTableList[i].timeDestination,
                    "flightNumber": self.allItemsTableList[i].flightNumber,
                    "originLat": String(self.allItemsTableList[i].oriLat),
                    "originLon": String(self.allItemsTableList[i].oriLon),
                    "destinationLat": String(self.allItemsTableList[i].desLat),
                    "destinationLon": String(self.allItemsTableList[i].desLon)
                ]
                
                self.database.child("proposedItineraries").child(date).child(String(id)).child("legs").child(String(i)).setValue(map)
                self.database.child("allItineraries").child(date).child(String(id)).child("legs").child(String(i)).setValue(map)
                self.database.child("userData").child(newEmail!).child("proposedItineraries").child(date).child(String(id)).child(String(i)).setValue(map)
            }
            self.database.child("proposedItineraries").child(date).child(String(id)).child("extra").child("userEmail").setValue(newEmail)
            self.database.child("allItineraries").child(date).child(String(id)).child("extra").child("userEmail").setValue(newEmail)
            
            self.database.child("userData").child(newEmail!).child("fullName").observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value as? String else {
                    return
                }
                self.database.child("proposedItineraries").child(date).child(String(id)).child("extra").child("fullName").setValue(value)
                self.database.child("allItineraries").child(date).child(String(id)).child("extra").child("fullName").setValue(value)
                
                self.backToMain()
            })
        })
        
    }
    
    @IBAction func backToMain() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}
