//
//  SupersetTableViewCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/28/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class SupersetTableViewCell: UITableViewCell {


    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var numLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
