//
//  CreateBodybuildingExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/2/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class CreateBodybuildingExerciseViewController: UIViewController {

    @IBOutlet weak var exName: UITextField!
    @IBOutlet weak var add: UIButton!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addExercise(_ sender: UIButton) {
        
        
        myExercise.name = exName.text!
        //myExercise.category = categories[id]
        
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }
    
}
