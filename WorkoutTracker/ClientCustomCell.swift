//
//  ClientCustomCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/8/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class ClientCustomCell: UITableViewCell {

    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var clientDetailBtnOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
