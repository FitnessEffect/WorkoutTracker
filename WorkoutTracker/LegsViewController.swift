//
//  LegsViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// Displays a list of Leg exercises

import UIKit

class LegsViewController: UIViewController {

    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var stringExercise:String = ""
    
    let legExercises = ["-- Quadriceps --", "Leg Press", "Seated Leg Extensions", "Smith Machine Squats", "Squats", " ", "-- Hamstrings --", "Leg Curls", "Summo Deadlift", " ", "-- Glutes --", "Donkey Kicks", "Kick Back", "Lunges", ]
    
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
        return legExercises.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return legExercises[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let exercise = legExercises[row]
        let temp = (exercise)
        stringExercise = String(temp)
    }
    
    @IBAction func addExercise(sender: UIButton) {
        
        myExercise.name = stringExercise
        myExercise.exerciseDescription = "4 sets | 12 reps"
        
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
