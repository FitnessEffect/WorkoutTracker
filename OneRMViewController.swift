//
//  1RMViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/15/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  This controller displays a list of 1 Rep Max exercises 

import UIKit

class OneRMViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    
    let OneRM = ["Back Squat", "Front Squat", "Overhead Squat", "Snatch", "Clean & Jerk", "Clean", "Deadlift", "Bench Press"]

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageOutlet.image = UIImage(named: "Background1.png")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return OneRM.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return OneRM[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addExercise(sender: UIButton) {
        
        let id:Int = pickerOutlet.selectedRowInComponent(0)
        myExercise.name = ("1RM" + OneRM[id])
        myExercise.exerciseDescription = ("1 Rep Max" + " | " + OneRM[id])
        
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
