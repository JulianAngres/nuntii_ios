//
//  NuntiiMatchesItemItineraryDataVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 06/02/2023.
//

import UIKit
import FirebaseDatabase

class NuntiiMatchesItemItineraryDataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var backToMainButton: UIButton!
    
    var selectedNuntiiMatchesList = [NuntiiMatchesItem]()
    var allItemsTableViewList = [TableViewFlight]()
    
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
        
        let id = selectedNuntiiMatchesList[0].itineraryId
        let date = selectedNuntiiMatchesList[0].date
        
        Database.database().reference().child("allItineraries").child(date).child(id).child("legs").observeSingleEvent(of: .value, with: {snapshot in
            
            for child in snapshot.children {
                let child = child as! DataSnapshot
                
                self.allItemsTableViewList.append(TableViewFlight(iataOrigin: child.childSnapshot(forPath: "iataOrigin").value as! String, iataDestination: child.childSnapshot(forPath: "iataDestination").value as! String, airportOrigin: child.childSnapshot(forPath: "airportOrigin").value as! String, dateOrigin: child.childSnapshot(forPath: "dateOrigin").value as! String, timeOrigin: child.childSnapshot(forPath: "timeOrigin").value as! String, airportDestination: child.childSnapshot(forPath: "airportDestination").value as! String, dateDestination: child.childSnapshot(forPath: "dateDestination").value as! String, timeDestination: child.childSnapshot(forPath: "timeDestination").value as! String, flightNumber: child.childSnapshot(forPath: "flightNumber").value as! String, nuntius: "", price: "", oriLat: 0, oriLon: 0, desLat: 0, desLon: 0, id: ""))
            }
            
            let nib = UINib(nibName: "FlightTableViewCell", bundle: nil)
            self.table.register(nib, forCellReuseIdentifier: "FlightTableViewCell")
            self.table.delegate = self
            self.table.dataSource = self
            
            self.table.reloadData()
            
        })
        
    }
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItemsTableViewList.count
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: FlightTableViewCell.identifier, for: indexPath) as! FlightTableViewCell
        cell.configure(with: allItemsTableViewList[indexPath.row])
        return cell
    }
    
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 322
    }
    
    @IBAction func backToMain() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemVC") as! NuntiiMatchesItemVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }

}
