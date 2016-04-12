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

    @IBOutlet weak var typeOutlet: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
