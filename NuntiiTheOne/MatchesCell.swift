//
//  MatchesCell.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 03/02/2023.
//

import UIKit

class MatchesCell: UITableViewCell {
    
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
    
    static let identifier = "MatchesCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MatchesCell", bundle: nil)
    }
    
    func configure(with model: NuntiiMatchesItem) {
        self.dateLabel.text = model.date
        self.originLabel.text = model.itineraryOrigin
        self.destinationLabel.text = model.itineraryDestination
    }
    
}
