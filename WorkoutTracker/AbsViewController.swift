//
//  AbsViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// Displays a list of Ab exercises

import UIKit

class AbsViewController: UIViewController {

    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var stringExercise:String = ""
    
    let absExercises = ["-- Abs --", "Bicycle Crunches", "Crunches", "Decline Crunches","Knee Raises", "Planch", "Russian Twists", "Sit-ups", "V-ups"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return absExercises.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return absExercises[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let exercise = absExercises[row]
        let temp = (exercise)
        stringExercise = String(temp)
    }
    
    @IBAction func addExercise(sender: UIButton) {
        
        myExercise.name = stringExercise
        myExercise.exerciseDescription = "4 sets | 20 reps"
        
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
