//
//  WodsViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class WodsViewController: UIViewController {
    
    let wods = ["-- Wods --", "Fran", "Grace", "Murph"]
    let exerciseKey:String = "exerciseKey"
    var stringExercise:String = ""
    var myExercise = Exercise()
    
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageOutlet.image = UIImage(named: "Background1.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wods.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wods[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let exercise = wods[row]
        let temp = (exercise)
        stringExercise = String(temp)
    }
    
    @IBAction func addWod(sender: UIButton) {
        
        myExercise.name = stringExercise
        
        if stringExercise == "Fran"{
           myExercise.exerciseDescription = ("21-15-9 reps for time | thrusters (95lbs) | pull-ups")
        }else if stringExercise == "Grace"{
            myExercise.exerciseDescription = ("30 reps for time | 135lbs clean and jerk")
        }else if stringExercise == "Murph"{
            myExercise.exerciseDescription = ("1 mile run | 100 pull-ups | 200 push-ups | 300 air squats | 1 mile run")
        }
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
