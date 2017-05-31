//
//  CustomBodybuildingViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/30/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class CustomBodybuildingViewController: UIViewController {
        
    @IBOutlet weak var exName: UITextField!
        @IBOutlet weak var pickerOutlet: UIPickerView!
        @IBOutlet weak var add: UIButton!
        
        let exerciseKey:String = "exerciseKey"
        var myExercise = Exercise()
        
       let bodyParts = ["--Category--", "Arms", "Chest", "Back", "Abs", "Legs"]
        
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
        
        func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
            
                return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         
                return bodyParts.count
            
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
                return bodyParts[row]
        }
        
        @IBAction func addExercise(_ sender: UIButton) {
            
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            myExercise.name = exName.text!
            myExercise.category = bodyParts[id]
            
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
            
            dismiss(animated: true, completion: nil)
        }
        
    }



