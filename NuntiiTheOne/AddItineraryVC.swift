//
//  AddItineraryVC.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 27/01/2022.
//

import UIKit
import CoreTelephony
import DropDown

class AddItineraryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    /*private let backToMain: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back To Main", for: .normal)
        return button
    }()*/
    
    private let getYourFlight: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Get Your Flight", for: .normal)
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
        emailField.placeholder = "Origin"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()
    
    private let destinationField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Destination"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()
    
    private let flightNumberField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Flight Number, e.g. SK4414, WF963, DY371 ..."
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
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let menu1: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["OSL - Oslo Gardermoen", "AES - Ålesund", "ALF - Alta", "ANX - Andenes ", "BDU - Bardufoss", "BJF - Båtsfjord", "BGO - Bergen", "BVG - Berlevåg", "BOO - Bodø", "BNN - Brønnøysund", "FRO - Florø", "FDE - Førde", "HFT - Hammerfest", "EVE - Evenes (Harstad/Narvik)", "HAA - Hasvik", "HAU - Haugesund", "HVG - Honningsvåg", "KKN - Kirkenes", "KRS - Kristiansand", "KSU - Kristiansund", "LKL - Lakselv", "LKN - Leknes", "MEH - Mehamn", "MQN - Mo i Rana", "MOL - Molde", "MJF - Mosjøen", "RYG - Rygge", "OSL - Oslo Gardermoen", "OSY - Namsos", "NTB - Notodden", "HOV - Hovden (Ørsta/Volda)", "RRS - Røros", "RVK - Rørvik", "RET - Røst", "SDN - Sandane", "TRF - Sandefjord/Torp", "SSJ - Sandnessjøen", "SOG - Sogndal", "SOJ - Sørkjosen", "SVG - Stavanger", "SKN - Stokmarknes", "SRP - Stord", "LYR - Longyearbyen", "SVJ - Svolvær", "TOS - Tromsø", "TRD - Trondheim", "VDS - Vadsø", "VAW - Vardø"]
        return menu
    }()
    
    let menu2: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["OSL - Oslo Gardermoen", "AES - Ålesund", "ALF - Alta", "ANX - Andenes ", "BDU - Bardufoss", "BJF - Båtsfjord", "BGO - Bergen", "BVG - Berlevåg", "BOO - Bodø", "BNN - Brønnøysund", "FRO - Florø", "FDE - Førde", "HFT - Hammerfest", "EVE - Evenes (Harstad/Narvik)", "HAA - Hasvik", "HAU - Haugesund", "HVG - Honningsvåg", "KKN - Kirkenes", "KRS - Kristiansand", "KSU - Kristiansund", "LKL - Lakselv", "LKN - Leknes", "MEH - Mehamn", "MQN - Mo i Rana", "MOL - Molde", "MJF - Mosjøen", "RYG - Rygge", "OSL - Oslo Gardermoen", "OSY - Namsos", "NTB - Notodden", "HOV - Hovden (Ørsta/Volda)", "RRS - Røros", "RVK - Rørvik", "RET - Røst", "SDN - Sandane", "TRF - Sandefjord/Torp", "SSJ - Sandnessjøen", "SOG - Sogndal", "SOJ - Sørkjosen", "SVG - Stavanger", "SKN - Stokmarknes", "SRP - Stord", "LYR - Longyearbyen", "SVJ - Svolvær", "TOS - Tromsø", "TRD - Trondheim", "VDS - Vadsø", "VAW - Vardø"]
        return menu
    }()
    
    @IBOutlet var table: UITableView!
    
    private let confirmFlight: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Confirm Flight", for: .normal)
        return button
    }()
    
    var oneItemTableList = [TableViewFlight]()
    var allItemsTableList = [TableViewFlight]()
    var beginner = true
    
    
    
    
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
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        
        oneItemTableList.append(TableViewFlight(iataOrigin: "", iataDestination: "", airportOrigin: "", dateOrigin: "", timeOrigin: "", airportDestination: "", dateDestination: "", timeDestination: "", flightNumber: "", nuntius: "", price: "", oriLat: 0.00, oriLon: 0.00, desLat: 0.00, desLon: 0.00, id: ""))
        
        table.register(FlightTableViewCell.nib(), forCellReuseIdentifier: FlightTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        //view.addSubview(backToMain)
        view.addSubview(getYourFlight)
        view.addSubview(dateField)
        view.addSubview(originField)
        view.addSubview(destinationField)
        view.addSubview(flightNumberField)
        view.addSubview(label)
        //backToMain.addTarget(self, action: #selector(backToMainTapped), for: .touchUpInside)
        getYourFlight.addTarget(self, action: #selector(getYourFlightTapped), for: .touchUpInside)
        
        let date = Date() + 86400
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateField.text = formatter.string(from: date)
        dateField.textColor = .blue
        
        if !allItemsTableList.isEmpty {
            dateField.text = allItemsTableList[allItemsTableList.count - 1].dateDestination
            originField.text = allItemsTableList[allItemsTableList.count - 1].iataDestination
            beginner = false
        }
        
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
        
        originField.delegate = self
        originField.keyboardType = .default
        originField.autocapitalizationType = .allCharacters
        originField.autocorrectionType = .no
        originField.returnKeyType = .done
        
        destinationField.delegate = self
        destinationField.keyboardType = .default
        destinationField.autocapitalizationType = .allCharacters
        destinationField.autocorrectionType = .no
        destinationField.returnKeyType = .done
        
        flightNumberField.delegate = self
        flightNumberField.keyboardType = .default
        flightNumberField.autocapitalizationType = .allCharacters
        flightNumberField.autocorrectionType = .no
        flightNumberField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    internal static func instantiate(with allItemsTableList: [TableViewFlight]) -> AddItineraryVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItineraryVC") as! AddItineraryVC
        vc.allItemsTableList = allItemsTableList
        return vc
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //backToMain.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 80)
        
        getYourFlight.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 80)
        
        dateField.frame = CGRect(x: 20, y: getYourFlight.frame.origin.y + getYourFlight.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        originField.frame = CGRect(x: 20, y: dateField.frame.origin.y + dateField.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        destinationField.frame = CGRect(x: 20, y: originField.frame.origin.y + originField.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        flightNumberField.frame = CGRect(x: 20, y: destinationField.frame.origin.y + destinationField.frame.size.height + 10, width: view.frame.size.width - 40, height: 52)
        
        label.frame = CGRect(x: 0, y: flightNumberField.frame.origin.y + flightNumberField.frame.size.height + 80, width: view.frame.size.width, height: 80)
        
        confirmFlight.frame = CGRect(x: 0, y: view.frame.size.height - 100, width: view.frame.size.width, height: 50)
    }
    
    
    
    @objc private func getYourFlightTapped() {
        
        flightNumberField.resignFirstResponder()
        
        guard let date = dateField.text, !date.isEmpty else {
            label.text = "Please type in a valid date in the form YYYY-MM-DD"
            return
        }
        guard var origin = originField.text, !origin.isEmpty else {
            label.text = "Please type in a valid origin IATA code, e. g. TOS, OSL, BGO, etc."
            return
        }
        guard var destination = destinationField.text, !destination.isEmpty else {
            label.text = "Please type in a valid destination IATA code, e. g. TOS, OSL, BGO, etc."
            return
        }
        guard let flightNumber = flightNumberField.text, !flightNumber.isEmpty else {
            label.text = "Please type in a valid flight number like SK4414, WF963, LH2457 ..."
            return
        }
        label.text = ""
        
        let origin0 = originField.text ?? ""
        let destination0 = destinationField.text ?? ""
        
        origin = String(origin0[origin0.startIndex..<origin0.index(origin0.startIndex, offsetBy: 3)])
        destination = String(destination0[destination0.startIndex..<destination0.index(destination0.startIndex, offsetBy: 3)])
        
        
        if let url = URL(string: "https://aerodatabox.p.rapidapi.com/flights/number/" + flightNumber + "/" + date) {
            
            print("Landmark Request")
            
            var request = URLRequest(url: url)
            request.setValue("", forHTTPHeaderField: "x-rapidapi-key")
            request.setValue("aerodatabox.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
            let completionHandler = { [self](data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                if let daten = data {
                    
                    let raw = String(decoding: daten, as: UTF8.self)
                    
                    let prepRaw = "{ \"legs\": " + raw + "}"
                    print(prepRaw)
                    let dataPrepRaw = Data(prepRaw.utf8)
                    
                    var json: FlightResponse?
                    do {
                        json = try JSONDecoder().decode(FlightResponse.self, from: dataPrepRaw)
                    }
                    catch {
                        DispatchQueue.main.async{
                            self.label.text = "Please check your details, otherwise email us with the date and flight number(s): info@nuntii.tech. Often times it helps to wait until one week before your flight."
                        }
                    }
                    
                    guard let result = json else {
                        return
                    }
                    
                    var origins: [String] = []
                    var destinations: [String] = []
                    var datesDestination: [String] = []
                    var timesDestination: [String] = []
                    var airportsDestination: [String] = []
                    var datesOrigin: [String] = []
                    var timesOrigin: [String] = []
                    var airportsOrigin: [String] = []
                    var originLat: [Double] = []
                    var originLon: [Double] = []
                    var destinationLat: [Double] = []
                    var destinationLon: [Double] = []
                    
                    for i in 0..<result.legs.count {
                        origins.append(result.legs[i].departure.airport.iata)
                        destinations.append(result.legs[i].arrival.airport.iata)
                        datesDestination.append(self.cutString(start: 0, end: 9, input: result.legs[i].arrival.scheduledTimeLocal))  //cut
                        timesDestination.append(self.cutString(start: 11, end: 15, input: result.legs[i].arrival.scheduledTimeLocal)) //cut
                        airportsDestination.append(result.legs[i].arrival.airport.name)
                        datesOrigin.append(self.cutString(start: 0, end: 9, input: result.legs[i].departure.scheduledTimeLocal))  //cut
                        timesOrigin.append(self.cutString(start: 11, end: 15, input: result.legs[i].departure.scheduledTimeLocal)) //cut
                        airportsOrigin.append(result.legs[i].departure.airport.name)
                        originLat.append(result.legs[i].departure.airport.location.lat)
                        originLon.append(result.legs[i].departure.airport.location.lon)
                        destinationLat.append(result.legs[i].arrival.airport.location.lat)
                        destinationLon.append(result.legs[i].arrival.airport.location.lon)
                        
                    }
                    
                    var permission = false
                    
                    if !destinations.isEmpty && !origins.isEmpty && !datesDestination.isEmpty && !timesDestination.isEmpty && !airportsDestination.isEmpty && !datesOrigin.isEmpty && !timesOrigin.isEmpty && !airportsOrigin.isEmpty && !originLat.isEmpty && !originLon.isEmpty && !destinationLat.isEmpty && !destinationLon.isEmpty {
                        if result.legs.count == 1 {
                            permission = true
                        }
                        else if destinations.firstIndex(of: destination) != nil {
                            
                            if destinations.firstIndex(of: destination)! >= origins.firstIndex(of: origin)! {
                                permission = true
                            }
                            
                        } else {
                            permission = false
                        }
                    }
                    else {
                        permission = false
                    }
                    
                    
                    
                    if permission {
                        var oriInd = 0
                        var desInd = 0
                        if destinations.count == 1 {
                        }
                        else {
                            oriInd = origins.firstIndex(of: origin)!
                            desInd = destinations.firstIndex(of: destination)!
                        }
                        
                        var proxyList: [String] = []
                        var doubleProxyList: [Double] = []
                        proxyList.append(origins[oriInd])
                        proxyList.append(destinations[desInd])
                        proxyList.append(datesDestination[desInd])
                        proxyList.append(timesDestination[desInd])
                        proxyList.append(airportsDestination[desInd])
                        proxyList.append(datesOrigin[oriInd])
                        proxyList.append(timesOrigin[oriInd])
                        proxyList.append(airportsOrigin[oriInd])
                        proxyList.append(result.legs[0].number)
                        doubleProxyList.append(originLat[oriInd])
                        doubleProxyList.append(originLon[oriInd])
                        doubleProxyList.append(destinationLat[desInd])
                        doubleProxyList.append(destinationLon[desInd])
                        
                        
                        if noPastFlights(dateOrigin: proxyList[5]) {
                            DispatchQueue.main.async {
                                self.label.text = "Your flight is in the past or it's too close to departure"
                            }
                        }
                        else if lessThanKm(beginner: beginner, allItemsTableList: allItemsTableList, newLat: doubleProxyList[0], newLon: doubleProxyList[1]) {
                            DispatchQueue.main.async {
                                self.label.text = "If you are connecting via a land transfer: Airports mustn't be more than 130 km apart"
                            }
                        }
                        else if threeHoursBetweenDifferentAirports(beginner: beginner, allItemsTableList: allItemsTableList, newAirport: proxyList[0], newAirportTime: proxyList[6], newAirportDate: proxyList[5]) {
                            DispatchQueue.main.async {
                                self.label.text = "If you are connecting via a land transfer: At least 3 h between flights required"
                            }
                        }
                        else if thirtyMinutesBetweenSameAirport(beginner: beginner, allItemsTableList: allItemsTableList, newAirport: proxyList[0], newAirportTime: proxyList[6], newAirportDate: proxyList[5]) {
                            DispatchQueue.main.async {
                                self.label.text = "There must be at least 30 minutes between two connecting flights"
                            }
                        }
                        else if fourtyeightHoursBetweenFlights(beginner: beginner, allItemsTableList: allItemsTableList, newAirport: proxyList[0], newAirportTime: proxyList[6], newAirportDate: proxyList[5]) {
                            DispatchQueue.main.async {
                                self.label.text = "There mustn't be more than 48 hours between two connecting flights"
                            }
                        }
                        else if onlyNorwegianAirports(iata1: proxyList[0], iata2: proxyList[1]) {
                            DispatchQueue.main.async {
                                self.label.text = "Only Norwegian Airports Allowed"
                            }
                        }
                        else {
                            self.oneItemTableList.removeFirst()
                            self.oneItemTableList.append(TableViewFlight(iataOrigin: proxyList[0], iataDestination: proxyList[1], airportOrigin: proxyList[7], dateOrigin: proxyList[5], timeOrigin: proxyList[6], airportDestination: proxyList[4], dateDestination: proxyList[2], timeDestination: proxyList[3], flightNumber: proxyList[8], nuntius: "", price: "", oriLat: doubleProxyList[0], oriLon: doubleProxyList[1], desLat: doubleProxyList[2], desLon: doubleProxyList[3], id: ""))
                            
                            if beginner && !self.allItemsTableList.isEmpty {
                                self.allItemsTableList.removeLast()
                            }
                            self.allItemsTableList.append(TableViewFlight(iataOrigin: proxyList[0], iataDestination: proxyList[1], airportOrigin: proxyList[7], dateOrigin: proxyList[5], timeOrigin: proxyList[6], airportDestination: proxyList[4], dateDestination: proxyList[2], timeDestination: proxyList[3], flightNumber: proxyList[8], nuntius: "", price: "", oriLat: doubleProxyList[0], oriLon: doubleProxyList[1], desLat: doubleProxyList[2], desLon: doubleProxyList[3], id: ""))
                            
                            DispatchQueue.main.async {
                                self.table.reloadData()
                                self.view.addSubview(self.confirmFlight)
                                self.confirmFlight.addTarget(self, action: #selector(self.confirmFlightTapped), for: .touchUpInside)
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.label.text = "Please check your details, otherwise email us with the date and flight number(s): info@nuntii.tech. Often times it helps to wait until one week before your flight."
                        }
                    }
                    
                }
                
            }
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        }
        else {
            label.text = "Please check your details, otherwise email us with the date and flight number(s): info@nuntii.tech. Often times it helps to wait until one week before your flight."
        }
        
    }
    

    
    /*@objc private func backToMainTapped() {
        openMainVC()
    }*/
    
    @objc private func confirmFlightTapped() {
        openItineraryOverviewVC()
    }
    
    @IBAction func openItineraryOverviewVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ItineraryOverviewVC") as! ItineraryOverviewVC
        
        vc.allItemsTableList = allItemsTableList
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    /*@IBAction func openMainVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }*/
    
    func cutString(start: Int, end: Int, input: String) -> String {
        let name = input
        let index1 = name.index(name.startIndex, offsetBy: start)
        let index2 = name.index(name.startIndex, offsetBy: end)
        let indexRange = index1...index2
        return String(name[indexRange])
    }
    
    // Table
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oneItemTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlightTableViewCell.identifier, for: indexPath) as! FlightTableViewCell
        cell.configure(with: oneItemTableList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 322
    }
    
    
    
    
    
    
    // DateTimeComparators
    
    func noPastFlightsInner(dateOrigin: String) throws -> Bool {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let departureDate = formatter.date(from: dateOrigin)
        
        let rawDate = Date()
        formatter.dateStyle = .short
        let currentDateRaw = formatter.string(from: rawDate)
        let arr = currentDateRaw.components(separatedBy: "/")
        
        if arr.count <= 3 {
            return false
        }
        
        else {
            
            
            let yearRaw = arr[2]
            let monthRaw = arr[0]
            let dayRaw = arr[1]
            
            var month = "01"
            var day = "01"
            if monthRaw.count == 1 {
                month = "0" + monthRaw
            }
            else {
                month = monthRaw
            }
            if dayRaw.count == 1 {
                day = "0" + dayRaw
            }
            else {
                day = dayRaw
            }
            
            formatter.dateFormat = "yyyy-MM-dd"
            let currentDate = "20" + yearRaw + "-" + month + "-" + day
            let finalCurrentDate = formatter.date(from: currentDate)
            
            if departureDate?.compare(finalCurrentDate!) == .orderedDescending {
                return false
            }
            
            return true
        }
        
    }
    
    func noPastFlights(dateOrigin: String) -> Bool {
        
        do {
            
            return try noPastFlightsInner(dateOrigin: dateOrigin)
            
        } catch {
            return false
        }
        
        
    }
    
    
    
    
    
    func lessThanKm(beginner: Bool, allItemsTableList: [TableViewFlight], newLat: Double, newLon: Double) -> Bool {
        
        if beginner {
            return false
        }
        
        let oldLat = allItemsTableList[allItemsTableList.count - 1].desLat
        let oldLon = allItemsTableList[allItemsTableList.count - 1].desLon
        
        if L_orth(phi_1: oldLat, phi_2: newLat, lambda_1: oldLon, lambda_2: newLon) < 130 {
            return false
        }
        
        return true
        
    }
    
    func L_orth(phi_1: Double, phi_2: Double, lambda_1: Double, lambda_2: Double) -> Double {
        
        print("\(String(phi_1)), \(String(lambda_1)) / \(String(phi_2)), \(String(lambda_2))")
        
        let phi_1_rad = phi_1*Double.pi/180
        let phi_2_rad = phi_2*Double.pi/180
        let lambda_1_rad = lambda_1*Double.pi/180
        let lambda_2_rad = lambda_2*Double.pi/180
        
        let distance = 6373.3 * acos(
            cos(phi_1_rad)*cos(phi_2_rad)*cos(lambda_1_rad - lambda_2_rad) + sin(phi_1_rad)*sin(phi_2_rad)
        )
        print("\(distance) km")
        return distance
        
    }
    
    func threeHoursBetweenDifferentAirports(beginner: Bool, allItemsTableList: [TableViewFlight], newAirport: String, newAirportTime: String, newAirportDate: String) -> Bool {
        
        if beginner {
            return false
        }
        else if allItemsTableList[allItemsTableList.count - 1].iataDestination == newAirport {
            return false
        }
        else {
            
            if timeDifference(date1: allItemsTableList[allItemsTableList.count - 1].dateDestination, time1: allItemsTableList[allItemsTableList.count - 1].timeDestination, date2: newAirportDate, time2: newAirportTime) < 180 {
                return true
            }
            else {
                return false
            }
            
        }
        
    }
    
    func thirtyMinutesBetweenSameAirport(beginner: Bool, allItemsTableList: [TableViewFlight], newAirport: String, newAirportTime: String, newAirportDate: String) -> Bool {
        
        if beginner {
            return false
        }
        else {
            if timeDifference(date1: allItemsTableList[allItemsTableList.count - 1].dateDestination, time1: allItemsTableList[allItemsTableList.count - 1].timeDestination, date2: newAirportDate, time2: newAirportTime) < 30 {
                return true
            }
            else {
                return false
            }
        }
        
    }
    
    
    
    func fourtyeightHoursBetweenFlights(beginner: Bool, allItemsTableList: [TableViewFlight], newAirport: String, newAirportTime: String, newAirportDate: String) -> Bool {
        
        if beginner {
            return false
        }
        else {
            if timeDifference(date1: allItemsTableList[allItemsTableList.count - 1].dateDestination, time1: allItemsTableList[allItemsTableList.count - 1].timeDestination, date2: newAirportDate, time2: newAirportTime) > 2880 {
                return true
            }
            else {
                return false
            }
        }
        
    }
    
    func onlyNorwegianAirports(iata1: String, iata2: String) -> Bool {
        
        let norwayIataList:[String] = ["AES", "ALF", "ANX", "BDU", "BJF", "BGO", "BVG", "BOO", "BNN", "VDB", "FAN", "FRO", "FDE", "DLD", "GLL", "HMR", "HFT", "EVE", "HAA", "HAU", "HVG", "QKX", "KKN", "KRS", "KSU", "LKL", "LKN", "MEH", "MQN", "MOL", "MJF", "RYG", "OSY", "NVK", "NTB", "OLA", "HOV", "FBU", "OSL", "RRS", "RVK", "RET", "SDN", "TRF", "SSJ", "SKE", "SOG", "SOJ", "SVG", "SKN", "SRP", "LYR", "SVJ", "TOS", "TRD", "VDS", "VRY", "VAW"]
        
        if norwayIataList.contains(iata1) && norwayIataList.contains(iata2) {
            return false
        }
        else {
            return true
        }
        
    }
    
    
    
    func timeDifference(date1: String, time1: String, date2: String, time2: String) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let zeitpunkt1 = date1 + " " + time1
        let zeitpunkt2 = date2 + " " + time2
        
        guard let timeDate1 = dateFormatter.date(from: zeitpunkt1) else { return 0 }
        guard let timeDate2 = dateFormatter.date(from: zeitpunkt2) else { return 0 }
        
        let calendar = Calendar.current
        
        let timeComponents1 = calendar.dateComponents([.day, .hour, .minute], from: timeDate1)
        let timeComponents2 = calendar.dateComponents([.day, .hour, .minute], from: timeDate2)
        
        let difference = calendar.dateComponents([.minute], from: timeComponents1, to: timeComponents2).minute!
        print("The time difference is \(String(difference))")
        
        return difference
        
    }
    
    
    
    
    
    
    
    

}



public struct TableViewFlight: Codable {
    let iataOrigin: String
    let iataDestination: String
    let airportOrigin: String
    let dateOrigin: String
    let timeOrigin: String
    let airportDestination: String
    let dateDestination: String
    let timeDestination: String
    let flightNumber: String
    let nuntius: String
    let price: String
    let oriLat: Double
    let oriLon: Double
    let desLat: Double
    let desLon: Double
    let id: String
}



public struct FlightResponse: Codable {
    let legs: [Leg]
}

public struct Leg: Codable {
    let greatCircleDistance: GreatCircleDistance?
    let departure: Departure
    let arrival: Arrival
    let location: Location?
    let lastUpdatedUtc: String?
    let number: String//!!!
    let status: String?
    let codeshareStatus: String?
    let isCargo: Bool?
    let aircraft: Aircraft?
    let airline: Airline?
}

public struct GreatCircleDistance: Codable {
    let meter: Double?
    let km: Double?
    let mile: Double?
    let nm: Double?
    let feet: Double?
}

public struct Departure: Codable {
    let airport: Airport
    let scheduledTimeLocal: String//!!!
    let actualTimeLocal: String?
    let runwayTimeLocal: String?
    let scheduledTimeUtc: String?
    let actualTimeUtc: String?
    let runwayTimeUtc: String?
    let terminal: String?
    let checkInDesk: String?
    let gate: String?
    let baggageBelt: String?
    let runway: String?
    let quality: [String]?
}

public struct Arrival: Codable {
    let airport: Airport
    let scheduledTimeLocal: String//!!!
    let actualTimeLocal: String?
    let runwayTimeLocal: String?
    let terminal: String?
    let checkInDesk: String?
    let gate: String?
    let baggageBelt: String?
    let runway: String?
    let scheduledTimeUtc: String?
    let quality: [String]?
}

public struct Airport: Codable {
    let icao: String?
    let iata: String//!!!
    let name: String//!!!
    let shortName: String?
    let municipalityName: String?
    let location: AirportLocation//!!!
    let countryCode: String?
}

public struct AirportLocation: Codable {
    let lat: Double
    let lon: Double
}

public struct Aircraft: Codable {
    let reg: String?
    let modeS: String?
    let model: String?
    let image: Image?
}

public struct Image: Codable {
    let url: String?
    let webUrl: String?
    let author: String?
    let title: String?
    let description: String?
    let license: [String]?
}

public struct Airline: Codable {
    let name: String?
}

public struct Location: Codable {
    let pressureAltFt: Int32?
    let gsKt: Int32?
    let trackDeg: Int32?
    let reportedAtUtc: String?
    let lat: Float?
    let lon: Float?
}
