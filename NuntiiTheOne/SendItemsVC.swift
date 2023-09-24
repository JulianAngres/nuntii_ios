//
//  SendItemsVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 27/01/2022.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth
import DropDown

class SendItemsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private let database = Database.database().reference()
    
    var allItemsTableList = [TableViewFlight]()
    var combinedDistances = [Double]()
    var sortedCombinedDistances = [Double]()
    var airDistances = [Double]()
    var sortedAirDistances = [Double]()
    var ids = [String]()
    var sortedIds = [String]()
    
    var originLats = [Double]()
    var originLons = [Double]()
    var destinationLats = [Double]()
    var destinationLons = [Double]()
    
    var iatasOrigin = [String]()
    var iatasDestination = [String]()
    var datesOrigin = [String]()
    var timesOrigin = [String]()
    var airportsOrigin = [String]()
    var datesDestination = [String]()
    var timesDestination = [String]()
    var airportsDestination = [String]()
    
    var fullNameDict: [String: String] = [:]
    var nuntiusIdDict: [String: String] = [:]
    
    var grund_preis: Double = 0.0
    var kmPreis = 1.11
    
    let spinnerView = UIActivityIndicatorView(style: .large)
    
    /*private let backToMain: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back To Main", for: .normal)
        return button
    }()*/

    private let search: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Search Nuntii Itineraries for Your Parcel", for: .normal)
        return button
    }()

    private let dateField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Date"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()

    private let originField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Origin City"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()

    private let destinationField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Destination City"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    let menu1: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Oslo", "Ålesund", "Alta", "Andenes", "Bardufoss", "Båtsfjord", "Bergen", "Berlevåg", "Bodø", "Brønnøysund", "Florø", "Førde", "Hammerfest", "Harstad", "Hasvik", "Haugesund", "Honningsvåg", "Kirkenes", "Kristiansand", "Kristiansund", "Lakselv", "Leknes", "Mehamn", "Mo i Rana", "Molde", "Mosjøen", "Namsos", "Narvik", "Notodden", "Oslo", "Røros", "Rørvik", "Røst", "Sandane", "Sandefjord/Torp", "Sandnessjøen", "Sogndal", "Sørkjosen", "Stavanger", "Stokmarknes", "Stord", "Longyearbyen", "Svolvær", "Tromsø", "Trondheim", "Vadsø", "Vardø", "Ørsta/Volda"]
        return menu
    }()
    
    let menu2: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Oslo", "Ålesund", "Alta", "Andenes", "Bardufoss", "Båtsfjord", "Bergen", "Berlevåg", "Bodø", "Brønnøysund", "Florø", "Førde", "Hammerfest", "Harstad", "Hasvik", "Haugesund", "Honningsvåg", "Kirkenes", "Kristiansand", "Kristiansund", "Lakselv", "Leknes", "Mehamn", "Mo i Rana", "Molde", "Mosjøen", "Namsos", "Narvik", "Notodden", "Oslo", "Røros", "Rørvik", "Røst", "Sandane", "Sandefjord/Torp", "Sandnessjøen", "Sogndal", "Sørkjosen", "Stavanger", "Stokmarknes", "Stord", "Longyearbyen", "Svolvær", "Tromsø", "Trondheim", "Vadsø", "Vardø", "Ørsta/Volda"]
        return menu
    }()
    
    let latDic = ["Oslo": 59.91406, "Ålesund": 62.46482, "Alta": 69.96595, "Andenes": 69.31778, "Bardufoss": 69.06782, "Båtsfjord": 70.63528, "Bergen": 60.38990, "Berlevåg": 70.85763, "Bodø": 67.28384, "Brønnøysund": 65.47369, "Florø": 61.60012, "Førde": 61.45563, "Hammerfest": 70.66434, "Harstad": 68.79864, "Hasvik": 70.48690, "Haugesund": 59.41437, "Honningsvåg": 70.98134, "Kirkenes": 69.72814, "Kristiansand": 58.14580, "Kristiansund": 63.11156, "Lakselv": 70.05198, "Leknes": 68.14616, "Mehamn": 71.03554, "Mo i Rana": 66.31201, "Molde": 62.73874, "Mosjøen": 65.83800, "Namsos": 64.46528, "Narvik": 68.43735, "Notodden": 59.56269, "Røros": 62.57376, "Rørvik": 64.86254, "Røst": 67.51914, "Sandane": 61.77650, "Sandefjord/Torp": 59.13421, "Sandnessjøen": 66.02234, "Sogndal": 61.15743, "Sørkjosen": 69.78860, "Stavanger": 58.97160, "Stokmarknes": 68.56378, "Stord": 59.77947, "Longyearbyen": 78.22498, "Svolvær": 68.23335, "Tromsø": 69.64893, "Trondheim": 63.43272, "Vadsø": 70.07472, "Vardø": 70.37037, "Ørsta/Volda": 62.17983]
    
    let lonDic = ["Oslo": 10.74878, "Ålesund": 6.35186, "Alta": 23.26972, "Andenes": 16.12108, "Bardufoss": 18.52147, "Båtsfjord": 29.71974, "Bergen": 5.32492, "Berlevåg": 29.08723, "Bodø": 14.37854, "Brønnøysund": 12.20814, "Florø": 5.03439, "Førde": 5.84682, "Hammerfest": 23.68031, "Harstad": 16.54112, "Hasvik": 22.16085, "Haugesund": 5.26698, "Honningsvåg": 25.96927, "Kirkenes": 30.03738, "Kristiansand": 7.99177, "Kristiansund": 7.73024, "Lakselv": 24.94816, "Leknes": 13.60984, "Mehamn": 27.84866, "Mo i Rana": 14.13743, "Molde": 7.16971, "Mosjøen": 13.19711, "Namsos": 11.49388, "Narvik": 17.43092, "Notodden": 9.25805, "Røros": 11.38398, "Rørvik": 11.23624, "Røst": 12.09256, "Sandane": 6.21523, "Sandefjord/Torp": 10.21167, "Sandnessjøen": 12.63361, "Sogndal": 7.13556, "Sørkjosen": 20.94688, "Stavanger": 5.73261, "Stokmarknes": 14.91113, "Stord": 5.49788, "Longyearbyen": 15.62591, "Svolvær": 14.56197, "Tromsø": 18.95776, "Trondheim": 10.39783, "Vadsø": 29.75042, "Vardø": 31.10828, "Ørsta/Volda": 6.07987]

    @IBOutlet var table: UITableView!
    
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
        
        view.addSubview(label)
        //view.addSubview(backToMain)
        view.addSubview(search)
        view.addSubview(dateField)
        view.addSubview(originField)
        view.addSubview(destinationField)
        //backToMain.addTarget(self, action: #selector(backToMainTapped), for: .touchUpInside)
        search.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        table.register(FlightTableViewCell.nib(), forCellReuseIdentifier: FlightTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        let date = Date() + 86400
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateField.text = formatter.string(from: date)
        dateField.textColor = .blue
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date() + 86400
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        dateField.inputView = datePicker
        
        let myView1 = originField
        
        menu1.anchorView = myView1
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem1))
        gesture1.numberOfTapsRequired = 1
        gesture1.numberOfTouchesRequired = 1
        myView1.addGestureRecognizer(gesture1)
        
        menu1.selectionAction = { index, title in
            self.originField.text = title
        }
        
        let myView2 = destinationField
        
        menu2.anchorView = myView2
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem2))
        gesture2.numberOfTapsRequired = 1
        gesture2.numberOfTouchesRequired = 1
        myView2.addGestureRecognizer(gesture2)
        
        menu2.selectionAction = { index, title in
            self.destinationField.text = title
        }
        
        Database.database().reference().child("grundpreis").observeSingleEvent(of: .value, with: { snapshot in
            
            self.grund_preis = snapshot.value as! Double
            
            self.kmPreis = self.grund_preis/1115
            
        })
        
    }
    
    @objc func didTapTopItem1() {
        menu1.show()
    }
    
    @objc func didTapTopItem2() {
        menu2.show()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateField.text = formatter.string(from: sender.date)
        sender.removeFromSuperview()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //backToMain.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 80)
        
        search.frame = CGRect(x: 20, y: 100, width: view.frame.size.width - 40, height: 52)
        
        dateField.frame = CGRect(x: 20, y: search.frame.origin.y + search.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        originField.frame = CGRect(x: 20, y: dateField.frame.origin.y + dateField.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        destinationField.frame = CGRect(x: 20, y: originField.frame.origin.y + originField.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        label.frame = CGRect(x: 0, y: destinationField.frame.origin.y + destinationField.frame.size.height + 70, width: view.frame.size.width, height: 80)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ItemOrderOverviewVC") as! ItemOrderOverviewVC
        vc.modalPresentationStyle = .fullScreen
        vc.allItemsTableList = [allItemsTableList[indexPath.row]]
        present(vc, animated: true)
    }
    
    @objc private func backToMainTapped() {
        openMainVC()
    }
    
    @IBAction func openMainVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    
    @objc private func searchTapped() {
        
        let spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .gray
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
        spinnerView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            spinnerView.stopAnimating()
        }
        
        label.text = ""
        
        self.allItemsTableList.removeAll()
        self.table.reloadData()
        
        self.combinedDistances.removeAll()
        self.sortedCombinedDistances.removeAll()
        self.airDistances.removeAll()
        self.sortedAirDistances.removeAll()
        self.sortedIds.removeAll()
        self.ids.removeAll()
        
        let startingLoc = originField.text!
        let endingLoc = destinationField.text!
        let givenDate = dateField.text!
        
        guard !noPastFlights(dateOrigin: givenDate + " 06:00") else {
            label.text = "Earliest possible date of booking: tomorrow"
            return
        }
        guard !givenDate.isEmpty else {
            label.text = "Please Provide a Date"
            return
        }
        guard !startingLoc.isEmpty else {
            label.text = "Please Provide a Start City"
            return
        }
        guard !endingLoc.isEmpty else {
            label.text = "Please Provide an Destination City"
            return
        }
        
        //CLGeocoder().geocodeAddressString(startingLoc, completionHandler: { (placemarks, error) -> Void in
        //    if error == nil {
        //        let coordinate = placemarks?.first?.location?.coordinate
                
                //let startingLat : String = coordinate?.latitude.description ?? "0.0"
                //let startingLon : String = coordinate?.longitude.description ?? "0.0"
                
                //CLGeocoder().geocodeAddressString(endingLoc, completionHandler: { (placemarks, error) -> Void in
                //    if error == nil {
                //        let coordinate2 = placemarks?.first?.location?.coordinate
                        
                //        let endingLat : String = coordinate2?.latitude.description ?? "1.0"
                //        let endingLon : String = coordinate2?.longitude.description ?? "1.0"
                        
                        /*let startLat = Double(startingLat)
                        let startLon = Double(startingLon)
                        let endLat = Double(endingLat)
                        let endLon = Double(endingLon)*/
                        
                        
                        
                        self.database.child("proposedItineraries").child(givenDate).observeSingleEvent(of: .value, with: { snapshot in
                            
                            self.originLats.removeAll()
                            self.originLons.removeAll()
                            self.destinationLats.removeAll()
                            self.destinationLons.removeAll()
                            
                            for child in snapshot.children {
                                let child = child as! DataSnapshot
                                
                                for grandChild in child.childSnapshot(forPath: "legs").children {
                                    let grandChild = grandChild as! DataSnapshot
                                    
                                    var originLat = ""
                                    var originLon = ""
                                    var destinationLat = ""
                                    var destinationLon = ""
                                    
                                    if let nestedData = grandChild.value as? [String: String] {
                                        originLat = nestedData["originLat"]!
                                        originLon = nestedData["originLon"]!
                                        destinationLat = nestedData["destinationLat"]!
                                        destinationLon = nestedData["destinationLon"]!
                                        
                                    }
                                    
                                    self.originLats.append(Double(originLat)!)
                                    self.originLons.append(Double(originLon)!)
                                    self.destinationLats.append(Double(destinationLat)!)
                                    self.destinationLons.append(Double(destinationLon)!)
                                    
                                }
                                
                                let size = self.originLats.count - 1
                                
                                let oriCooLat = self.originLats[0]
                                let oriCooLon = self.originLons[0]
                                let desCooLat = self.destinationLats[size]
                                let desCooLon = self.destinationLons[size]
                                
                                self.originLats.removeAll()
                                self.originLons.removeAll()
                                self.destinationLats.removeAll()
                                self.destinationLons.removeAll()
                                
                                let lat1 = self.originField.text ?? ""
                                let lat2 = self.destinationField.text ?? ""
                                
                                guard let startLat = self.latDic[lat1] else {
                                    self.label.text = "Please only use values from the drop down menu"
                                    return
                                }
                                guard let startLon = self.lonDic[lat1] else {
                                    self.label.text = "Please only use values from the drop down menu"
                                    return
                                }
                                guard let endLat = self.latDic[lat2] else {
                                    self.label.text = "Please only use values from the drop down menu"
                                    return
                                }
                                guard let endLon = self.lonDic[lat2] else {
                                    self.label.text = "Please only use values from the drop down menu"
                                    return
                                }
                                
                                let combinedDistance = self.L_orth(phi_1: startLat, phi_2: oriCooLat, lambda_1: startLon, lambda_2: oriCooLon) + self.L_orth(phi_1: endLat, phi_2: desCooLat, lambda_1: endLon, lambda_2: desCooLon)
                                let airDistance = self.L_orth(phi_1: oriCooLat, phi_2: desCooLat, lambda_1: oriCooLon, lambda_2: desCooLon)
                                
                                self.airDistances.append(airDistance)
                                
                                self.combinedDistances.append(combinedDistance)
                                self.sortedCombinedDistances.append(combinedDistance)
                                self.ids.append(child.key)
                                
                            }
                            
                            self.sortedCombinedDistances.sort()
                            self.sortedIds.removeAll()
                            
                            guard self.combinedDistances.count != 0 else {
                                self.label.text = "There are unfortunately no itineraries available on this date."
                                return
                            }
                            for i in 0...self.combinedDistances.count - 1 {
                                self.sortedIds.append(self.ids[self.combinedDistances.firstIndex(of: self.sortedCombinedDistances[i])!])
                                self.sortedAirDistances.append(self.airDistances[self.combinedDistances.firstIndex(of: self.sortedCombinedDistances[i])!])
                            }
                            
                            
                            self.allItemsTableList.removeAll()
                            for i in 0...self.sortedIds.count - 1 {
                                let j = self.sortedIds[i]
                                let greatCircle = self.sortedAirDistances[i]
                                let price1 = self.kmPreis*greatCircle*0.5 + 250
                                let price2 = Double(round(100*price1)/100)
                                
                                self.iatasOrigin.removeAll()
                                self.iatasDestination.removeAll()
                                self.datesOrigin.removeAll()
                                self.timesOrigin.removeAll()
                                self.airportsOrigin.removeAll()
                                self.datesDestination.removeAll()
                                self.timesDestination.removeAll()
                                self.airportsDestination.removeAll()
                                
                                self.database.child("proposedItineraries").child(givenDate).child(j).child("extra").observeSingleEvent(of: .value, with: { snapshot in
                                    
                                        if let nestedData = snapshot.value as? [String: String] {
                                            
                                            self.fullNameDict[j] = nestedData["fullName"]!
                                            self.nuntiusIdDict[j] = nestedData["userEmail"]!
                                        }
                                    
                                    self.database.child("proposedItineraries").child(givenDate).child(j).child("legs").observeSingleEvent(of: .value, with: { snapshot in
                                        
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
                                            
                                            if let nestedData = child.value as? [String: String] {
                                                iataOrigin = nestedData["iataOrigin"]!
                                                iataDestination = nestedData["iataDestination"]!
                                                dateDestination = nestedData["dateDestination"]!
                                                timeDestination = nestedData["timeDestination"]!
                                                airportDestination = nestedData["airportDestination"]!
                                                dateOrigin = nestedData["dateOrigin"]!
                                                timeOrigin = nestedData["timeOrigin"]!
                                                airportOrigin = nestedData["airportOrigin"]!
                                            }
                                            
                                            self.iatasOrigin.append(iataOrigin)
                                            self.iatasDestination.append(iataDestination)
                                            self.datesDestination.append(dateDestination)
                                            self.timesDestination.append(timeDestination)
                                            self.airportsDestination.append(airportDestination)
                                            self.datesOrigin.append(dateOrigin)
                                            self.timesOrigin.append(timeOrigin)
                                            self.airportsOrigin.append(airportOrigin)
                                            
                                        }
                                        
                                        let email = FirebaseAuth.Auth.auth().currentUser?.email
                                        let newEmail = email?.replacingOccurrences(of: ".", with: "__DOT__")
                                        
                                        if newEmail != self.nuntiusIdDict[j] {
                                            self.allItemsTableList.append(TableViewFlight(iataOrigin: self.iatasOrigin[0], iataDestination: self.iatasDestination[self.iatasOrigin.count - 1], airportOrigin: self.airportsOrigin[0], dateOrigin: self.datesOrigin[0], timeOrigin: self.timesOrigin[0], airportDestination: self.airportsDestination[self.iatasOrigin.count - 1], dateDestination: self.datesDestination[self.iatasOrigin.count - 1], timeDestination: self.timesDestination[self.iatasOrigin.count - 1], flightNumber: "", nuntius: self.fullNameDict[j] ?? "", price: String(price2), oriLat: 0, oriLon: 0, desLat: 0, desLon: 0, id: j))
                                        }
                                        
                                        self.iatasOrigin.removeAll()
                                        self.iatasDestination.removeAll()
                                        self.datesDestination.removeAll()
                                        self.timesDestination.removeAll()
                                        self.airportsDestination.removeAll()
                                        self.datesOrigin.removeAll()
                                        self.timesOrigin.removeAll()
                                        self.airportsOrigin.removeAll()
                                        
                                        self.table.reloadData()
                                        
                                    })
                                    
                                })
                                
                            }
                            
                        })
                        
                        
                    /*}
                    else {
                        self.label.text = "Something went wrong"
                    }*/
                //})
                
            /*}
            else {
                self.label.text = "Something went wrong"
            }*/
        //})
    }
    
    func noPastFlights(dateOrigin: String) -> Bool {
        
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let then = formatter.date(from: dateOrigin)!
        
        if then > now {
            return false
        }
        return true
        
    }
    
    func L_orth(phi_1: Double, phi_2: Double, lambda_1: Double, lambda_2: Double) -> Double {
        
        let phi_1_rad = phi_1*Double.pi/180
        let phi_2_rad = phi_2*Double.pi/180
        let lambda_1_rad = lambda_1*Double.pi/180
        let lambda_2_rad = lambda_2*Double.pi/180
        
        let distance = 6373.3 * acos(
            cos(phi_1_rad)*cos(phi_2_rad)*cos(lambda_1_rad - lambda_2_rad) + sin(phi_1_rad)*sin(phi_2_rad)
        )
        
        return distance + Double.random(in: 1...1000000)*1e-6
        
    }

}
