//
//  MetconCustomCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/19/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class MetconCustomCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var exTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        exTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        exTextField.layer.cornerRadius = 5.0
        exTextField.clipsToBounds = true
        exTextField.layer.borderWidth = 1
        exTextField.layer.borderColor = UIColor.white.cgColor
    }

    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
