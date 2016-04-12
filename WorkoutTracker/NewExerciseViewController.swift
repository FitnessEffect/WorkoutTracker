//
//  CreateWorkoutViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 1/31/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  The NewExerciseViewController creates a new workout and returns it to the
//  ExercisesViewController

import UIKit

protocol createExerciseDelegate{
   func addExercise(exercise:Exercise)
}

class NewExerciseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var workout: UIPickerView!
    @IBOutlet weak var nameOutlet: UITextField!
   
    var myExercise = Exercise()
    var stringWorkout:String = ""
    var incomingExerciseArray:[String] = []
    var incomingExerciseIndex:Int = -1
    var delegate:createExerciseDelegate! = nil
    
    let reps = ["Reps", "1 rep", "5 reps", "6 reps", "7 reps", "8 reps", "9 reps", "10 reps", "11 reps", "12 reps", "13 reps", "14 reps", "15 reps", "16 reps", "17 reps", "18 reps", "19 reps", "20 reps", "21 reps", "25 reps", "30 reps", "100 reps"]
    
    let sets = ["Sets", "1 set", "2 sets", "3 sets", "4 sets", "5 sets","6 sets", "7 sets", "8 sets", "9 sets", "10 sets", "11 sets", "12 sets", "13 sets", "14 sets", "15 sets", "20 sets"]
    
    let time = ["Time", "15 seconds", "30 seconds", "45 seconds","1 minute", "2 minutes", "3 minutes", "4 minutes", "5 minutes","6 minutes", "7 minutes", "8 minutes", "9 minutes", "10 minutes", "11 minutes", "12 minutes", "13 minutes", "14 minutes", "15 minutes", "30 minutes", "45 minutes", "1 hour", "2 hours"]
    
    let distance = ["Distance", "100 meters", "200 meters", "300 meters", "400 meters", "500 meters", "1 mile", "2 miles", "3 miles", "4 miles", "5 miles", "6 miles", "7 miles", "8 miles", "9 miles", "10 miles", "13 miles", "26 miles"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return reps.count
        }else if component == 1{
            return sets.count
        }else if component == 2{
            return time.count
        }else {
            return distance.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return reps[row]
        }else if component == 1{
            return sets[row]
        }else if component == 2{
            return time[row]
        }else{
            return distance[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerElementReps = reps[pickerView.selectedRowInComponent(0)]
        print(pickerElementReps)
        let pickerElementSets = sets[pickerView.selectedRowInComponent(1)]
        print(pickerElementSets)
        let pickerElementTime = time[pickerView.selectedRowInComponent(2)]
        print(pickerElementTime)
        let pickerElementDistance = distance[pickerView.selectedRowInComponent(3)]
        print(pickerElementDistance)

         let temp = (pickerElementReps, pickerElementSets, pickerElementTime, pickerElementDistance)
            stringWorkout = String(temp)
    }
    
    @IBAction func addExercise(sender: UIButton) {
        myExercise.name = nameOutlet.text!
        myExercise.exerciseDescription = stringWorkout
    
        delegate.addExercise(myExercise)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
