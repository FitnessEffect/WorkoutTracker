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

    @IBOutlet weak var segmentedTypeOutlet: UISegmentedControl!
    @IBOutlet weak var workoutNameOutlet: UITextField!
    @IBOutlet weak var dateOutlet: UIDatePicker!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    var delegate:createWorkoutDelegate! = nil
    var myWorkout = Workout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageOutlet.image = UIImage(named: "rings.png")
        self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 250.0/255.0, blue: 180.0/255.0, alpha: 1.0)
    }

    @IBAction func typeSegmentedBar(sender: UISegmentedControl){
        if segmentedTypeOutlet.selectedSegmentIndex == 0 {
            imageOutlet.image = UIImage(named: "rings.png")
            self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 250.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        }else if segmentedTypeOutlet.selectedSegmentIndex == 1 {
            imageOutlet.image = UIImage(named: "dead.png")
            self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 225.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        }
    }
    //returns information to the delegate method addWorkout
    @IBAction func CreateWorkout(sender: UIButton) {
        
        let workoutName = workoutNameOutlet.text
        let rawDate = dateOutlet.date
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let dateStr = dateFormatter.stringFromDate(rawDate)
       
        if segmentedTypeOutlet.selectedSegmentIndex == 0 {
            myWorkout.type = "Crossfit"
        }else if segmentedTypeOutlet.selectedSegmentIndex == 1 {
            myWorkout.type = "Bodybuilding"
        }
        
        myWorkout.name = workoutName!
        myWorkout.date = dateStr
        
        delegate.addWorkout(myWorkout)
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
