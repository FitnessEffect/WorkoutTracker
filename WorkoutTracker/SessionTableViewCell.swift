//
//  SessionTableViewCell.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/30/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class SessionCustomCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var paidOutlet: UILabel!

    var sessionKey = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setSessionKey(key:String){
        sessionKey = key
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
