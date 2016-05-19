//
//  BackViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// Displays a list of Back exercises

import UIKit

class BackViewController: UIViewController {

    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    
    let backExercises = ["Back Extensions", "Bent Over Row", "Lat PullDown", "Seated Cable Row"]
    
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
        return backExercises.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return backExercises[row]
    }
    
    @IBAction func addExercise(sender: UIButton) {
        
        let id:Int = pickerOutlet.selectedRowInComponent(0)
        myExercise.name = backExercises[id]
        myExercise.exerciseDescription = "4 sets , 12 reps"
        
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
