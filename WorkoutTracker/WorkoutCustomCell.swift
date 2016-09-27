//
//  WorkoutCustomCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/4/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  WorkoutCustomCell holds the custome cell for the TableView in workoutsViewController

import UIKit

class WorkoutCustomCell: UITableViewCell {

    
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var numberOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
