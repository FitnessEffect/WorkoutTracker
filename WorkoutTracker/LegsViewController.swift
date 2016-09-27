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

    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    
    let legExercises = ["Leg Press", "Seated Leg Extensions", "Smith Machine Squats", "Squats", " ", "-- Hamstrings --", "Leg Curls", "Summo Deadlift", " ", "-- Glutes --", "Donkey Kicks", "Kick Back", "Lunges", ]
    
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
        return legExercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return legExercises[row]
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        
        let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        myExercise.name = legExercises[id]
        myExercise.exerciseDescription = "4 sets - 12 reps"
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }
}
