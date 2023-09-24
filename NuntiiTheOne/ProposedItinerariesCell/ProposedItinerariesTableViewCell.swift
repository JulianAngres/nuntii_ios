//
//  ProposedItinerariesTableViewCell.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 08/02/2022.
//

import UIKit

class ProposedItinerariesTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var originLabel: UILabel!
    @IBOutlet var destinationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "ProposedItinerariesTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProposedItinerariesTableViewCell", bundle: nil)
    }
    
    func configure(with model: ProposedItineraryItem) {
        self.dateLabel.text = model.dateItinerary
        self.originLabel.text = model.itineraryOrigin
        self.destinationLabel.text = model.itineraryDestination
    }
    
}
