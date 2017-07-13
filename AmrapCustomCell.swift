//
//  AmrapCustomCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/19/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class AmrapCustomCell: UITableViewCell {

    @IBOutlet weak var exTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        exTextField.layer.cornerRadius = 5.0
        exTextField.clipsToBounds = true
        exTextField.layer.borderWidth = 1
        exTextField.layer.borderColor = UIColor.white.cgColor
        // Configure the view for the selected state
    }

}
