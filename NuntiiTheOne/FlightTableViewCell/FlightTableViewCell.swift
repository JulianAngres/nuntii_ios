//
//  FlightTableViewCell.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 31/01/2022.
//

import UIKit

class FlightTableViewCell: UITableViewCell {
    
    @IBOutlet var iataOriginLabel: UILabel!
    @IBOutlet var iataDestinationLabel: UILabel!
    @IBOutlet var airportOriginLabel: UILabel!
    @IBOutlet var airportDestinationLabel: UILabel!
    @IBOutlet var dateOriginLabel: UILabel!
    @IBOutlet var dateDestinationLabel: UILabel!
    @IBOutlet var timeOriginLabel: UILabel!
    @IBOutlet var timeDestinationLabel: UILabel!
    @IBOutlet var flightNumberLabel: UILabel!
    @IBOutlet var nuntiusLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        //backgroundColor = UIColor(red: 0x00, green: 0x80, blue: 0x80, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "FlightTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FlightTableViewCell", bundle: nil)
    }
    
    func configure(with model: TableViewFlight) {
        self.iataOriginLabel.text = model.iataOrigin
        self.iataDestinationLabel.text = model.iataDestination
        self.airportOriginLabel.text = model.airportOrigin
        self.dateOriginLabel.text = model.dateOrigin
        self.timeOriginLabel.text = model.timeOrigin
        self.airportDestinationLabel.text = model.airportDestination
        self.dateDestinationLabel.text = model.dateDestination
        self.timeDestinationLabel.text = model.timeDestination
        self.flightNumberLabel.text = model.flightNumber
        self.nuntiusLabel.text = model.nuntius
        self.priceLabel.text = model.price.replacingOccurrences(of: ".", with: ",") + " NOK"
    }
    
}
