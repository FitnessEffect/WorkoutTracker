//
//  CreateWorkoutViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 1/31/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  The NewBodybuildingExerciseViewController allows the user to
//  create a custom bodybuilding exercise

import UIKit

protocol CreateExerciseDelegate{
   func addExercise(exercise:Exercise)
}

class NewBodybuildingExerciseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var workout: UIPickerView!
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var stringWorkout:String = ""
    var incomingExerciseArray:[String] = []
    
    let reps = ["Reps", "1 rep", "5 reps", "6 reps", "7 reps", "8 reps", "9 reps", "10 reps", "11 reps", "12 reps", "13 reps", "14 reps", "15 reps", "16 reps", "17 reps", "18 reps", "19 reps", "20 reps", "21 reps", "25 reps", "30 reps", "100 reps"]
    
    let sets = ["Sets", "1 set", "2 sets", "3 sets", "4 sets", "5 sets","6 sets", "7 sets", "8 sets", "9 sets", "10 sets", "11 sets", "12 sets", "13 sets", "14 sets", "15 sets", "20 sets"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
         backgroundImageOutlet.image = UIImage(named: "Background1.png")
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return reps.count
        }else{
            return sets.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return reps[row]
        }else {
            return sets[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerElementReps = reps[pickerView.selectedRowInComponent(0)]
        
        let pickerElementSets = sets[pickerView.selectedRowInComponent(1)]
        
         let temp = pickerElementReps + " | " + pickerElementSets
            stringWorkout = String(temp)
    }
    
    @IBAction func addExercise(sender: UIButton) {
    
        myExercise.name = nameOutlet.text!
        myExercise.exerciseDescription = stringWorkout
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
       
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
