//
//  NuntiiMatchesItemParcelVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 06/02/2023.
//

import UIKit

class NuntiiMatchesItemParcelVC: UIViewController {
    
    var selectedNuntiiMatchesList = [NuntiiMatchesItem]()
    var eigenPreis: Int = 1
    
    @IBOutlet var backToMainButton: UIButton!
    
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
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
        
        sizeLabel.text = selectedNuntiiMatchesList[0].parcelSize
        descriptionLabel.text = selectedNuntiiMatchesList[0].parcelDescription
        priceLabel.text = String(Int(Float(selectedNuntiiMatchesList[0].price)! - Float(eigenPreis))) + " NOK"
        
    }
    
    @IBAction func backToMain() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemVC") as! NuntiiMatchesItemVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }

}
