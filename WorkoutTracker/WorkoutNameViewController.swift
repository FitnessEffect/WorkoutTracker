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
    func addWorkout(_ workout:Workout)
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

    @IBAction func typeSegmentedBar(_ sender: UISegmentedControl){
        if segmentedTypeOutlet.selectedSegmentIndex == 0 {
            imageOutlet.image = UIImage(named: "rings.png")
            self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 250.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        }else if segmentedTypeOutlet.selectedSegmentIndex == 1 {
            imageOutlet.image = UIImage(named: "dead.png")
            self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 225.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        }
    }
    //returns information to the delegate method addWorkout
    @IBAction func CreateWorkout(_ sender: UIButton) {
        
        let workoutName = workoutNameOutlet.text
        let rawDate = dateOutlet.date
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let dateStr = dateFormatter.string(from: rawDate)
       
        if segmentedTypeOutlet.selectedSegmentIndex == 0 {
            myWorkout.type = "Crossfit"
        }else if segmentedTypeOutlet.selectedSegmentIndex == 1 {
            myWorkout.type = "Bodybuilding"
        }
        
        myWorkout.name = workoutName!
        myWorkout.date = dateStr
        
        delegate.addWorkout(myWorkout)
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
