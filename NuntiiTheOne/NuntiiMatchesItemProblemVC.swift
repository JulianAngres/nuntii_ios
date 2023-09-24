//
//  NuntiiMatchesItemProblemVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 06/02/2023.
//

import UIKit

class NuntiiMatchesItemProblemVC: UIViewController {
    
    var selectedNuntiiMatchesList = [NuntiiMatchesItem]()
    @IBOutlet var problemLabel: UILabel!
    
    @IBOutlet var backToMainButton: UIButton!
    
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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToMain() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NuntiiMatchesItemVC") as! NuntiiMatchesItemVC
        vc.modalPresentationStyle = .fullScreen
        vc.selectedNuntiiMatchesList = selectedNuntiiMatchesList
        present(vc, animated: true)
    }

}
