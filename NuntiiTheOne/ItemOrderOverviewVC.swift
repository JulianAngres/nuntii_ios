//
//  ItemOrderOverviewVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 14/02/2022.
//

import UIKit

class ItemOrderOverviewVC: UIViewController {
    
    @IBOutlet var DepartureIataLabel: UILabel!
    @IBOutlet var DepartureAirportLabel: UILabel!
    @IBOutlet var DepartureDateLabel: UILabel!
    @IBOutlet var DepartureTimeLabel: UILabel!
    @IBOutlet var ArrivalIataLabel: UILabel!
    @IBOutlet var ArrivalAirportLabel: UILabel!
    @IBOutlet var ArrivalDateLabel: UILabel!
    @IBOutlet var ArrivalTimeLabel: UILabel!
    @IBOutlet var NuntiusLabel: UILabel!
    @IBOutlet var PriceLabel: UILabel!
    
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
        
        DepartureIataLabel.text = allItemsTableList[0].iataOrigin
        DepartureAirportLabel.text = allItemsTableList[0].airportOrigin
        DepartureDateLabel.text = allItemsTableList[0].dateOrigin
        DepartureTimeLabel.text = allItemsTableList[0].timeOrigin
        ArrivalIataLabel.text = allItemsTableList[0].iataDestination
        ArrivalAirportLabel.text = allItemsTableList[0].airportDestination
        ArrivalDateLabel.text = allItemsTableList[0].dateDestination
        ArrivalTimeLabel.text = allItemsTableList[0].timeDestination
        NuntiusLabel.text = allItemsTableList[0].nuntius
        PriceLabel.text = allItemsTableList[0].price + " NOK"
    }
    
    internal static func instantiate(with allItemsTableList: [TableViewFlight]) -> ItineraryOverviewVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItineraryOverviewVC") as! ItineraryOverviewVC
        vc.allItemsTableList = allItemsTableList
        return vc
    }
    
    @IBAction func backToSelectionTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SendItemsVC") as! SendItemsVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func confirmTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrderSpecifyParcelVC") as! OrderSpecifyParcelVC
        vc.modalPresentationStyle = .fullScreen
        vc.allItemsTableList = allItemsTableList
        present(vc, animated: true)
    }

}
