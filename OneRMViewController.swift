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
    
    @IBOutlet weak var picketOutlet: UIPickerView!
    
    let exerciseKey:String = "exerciseKey"
    var stringExercise:String = ""
    var myExercise = Exercise()
    
    let OneRM = ["-- 1 Rep Back --", "Back Squat", "Front Squat", "Overhead Squat", "Snatch", "Clean & Jerk", "Clean", "Deadlift", "Bench Press"]

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        let exercise = OneRM[pickerView.selectedRowInComponent(0)]
        let temp = (exercise)
        stringExercise = String(temp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addExercise(sender: UIButton) {
        myExercise.name = ("1RM " + stringExercise)
        myExercise.exerciseDescription = ("1 Rep Max")
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
