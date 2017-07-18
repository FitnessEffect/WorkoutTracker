//
//  ChallengesTableViewCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/27/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class ChallengeCustomCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var numberOutlet: UILabel!
    @IBOutlet weak var challenger: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
