//
//  LegsViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// Displays a list of Leg exercises

import UIKit

class LegsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var add: UIButton!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    
    let legExercises = ["Leg Press", "Seated Leg Extensions", "Smith Machine Squats", "Squats", " ", "-- Hamstrings --", "Leg Curls", "Summo Deadlift", " ", "-- Glutes --", "Donkey Kicks", "Kick Back", "Lunges", ]
    
    let reps = ["Reps", "1 rep", "5 reps", "6 reps", "7 reps", "8 reps", "9 reps", "10 reps", "11 reps", "12 reps", "13 reps", "14 reps", "15 reps", "16 reps", "17 reps", "18 reps", "19 reps", "20 reps", "21 reps", "25 reps", "30 reps", "100 reps"]
    
    let sets = ["Sets", "1 set", "2 sets", "3 sets", "4 sets", "5 sets","6 sets", "7 sets", "8 sets", "9 sets", "10 sets", "11 sets", "12 sets", "13 sets", "14 sets", "15 sets", "20 sets"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add.layer.cornerRadius = 10.0
        add.clipsToBounds = true
        add.layer.borderWidth = 1
        add.layer.borderColor = UIColor.black.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0{
            return 1
        }else{
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return legExercises.count
        }else{
            if component == 0 {
                return reps.count
            }else{
                return sets.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return legExercises[row]
        }else{
            if component == 0 {
                return reps[row]
            }else {
                return sets[row]
            }
        }
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        
        let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        myExercise.name = "Legs"
        myExercise.exerciseDescription = legExercises[id] + "|" + reps[id] + " - " + sets[id]
        myExercise.category = "Legs"
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if pickerView.tag == 0 {
            label.text = legExercises[row]
        }else if component == 0{
            label.text = sets[row]
        }else{
            label.text = reps[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day Demo", size: 25.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
}
