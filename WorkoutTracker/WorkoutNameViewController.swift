//
//  DateViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  The WorkoutNameViewController creates a new workout and returns it to the 
//  WorkoutsViewController

import UIKit

protocol createWorkoutDelegate{
    func addWorkout(workout:Workout)
}

class WorkoutNameViewController: UIViewController {

    @IBOutlet weak var workoutNameOutlet: UITextField!
    @IBOutlet weak var dateOutlet: UIDatePicker!
    
    var delegate:createWorkoutDelegate! = nil
    var myWorkout = Workout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func CreateWorkout(sender: UIButton) {
        let workoutName = workoutNameOutlet.text
        let workoutDate = dateOutlet.date
        
        myWorkout.name = workoutName!
        myWorkout.date = String(workoutDate)
        
        delegate.addWorkout(myWorkout)
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
