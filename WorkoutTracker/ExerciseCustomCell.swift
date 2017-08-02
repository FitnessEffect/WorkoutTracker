//
//  ExerciseCustomCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/25/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class ExerciseCustomCell: UITableViewCell {

    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var numberOutlet: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    
    var exerciseKey = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setExerciseKey(key:String){
        exerciseKey = key
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
