//
//  TabataCustomCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/2/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class TabataCustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    @IBOutlet weak var exTextField: UITextField!
    @IBOutlet weak var exLabel: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getExercise() -> String{
        let exercise:String = exTextField.text!
        return exercise
    }

}
