//
//  ArmViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// Displays a list of Arm exercises

import UIKit

class ArmViewController: UIViewController {
    
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    
     let armExercises = ["Barbell Curls", "Preacher Curl", "Standing Curls", " ", "-- Triceps --", "Extensions", "Pulldowns", "Skull Crushers", " ", "-- Shoulders --", "Front Raises", "Lateral Raises", "Reverse Flies", "Seated Barbell Raises", "Shrugs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
         backgroundImageOutlet.image = UIImage(named: "Background1.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return armExercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return armExercises[row]
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        //let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        myExercise.name = "Arms"
        myExercise.exerciseDescription = "4 sets - 12 reps"
    
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }
}
