//
//  ProgressDataCustomCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 10/28/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class ProgressDataCustomCell: UITableViewCell {

    @IBOutlet weak var weightOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
