//
//  WodsViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class WodsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let wods = ["Fran", "Grace", "Murph"]
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wods[row]
    }

    @IBAction func addWod(_ sender: UIButton) {
        
        let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        myExercise.name = wods[id]
        
        if myExercise.name == "Fran"{
           myExercise.exerciseDescription = ("21-15-9 reps for time | thrusters (95lbs) | pull-ups")
        }else if myExercise.name == "Grace"{
            myExercise.exerciseDescription = ("30 reps for time | 135lbs clean and jerk")
        }else if myExercise.name == "Murph"{
            myExercise.exerciseDescription = ("1 mile run | 100 pull-ups | 200 push-ups | 300 air squats | 1 mile run")
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
    
        label.text = wods[row]
        
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Avenir Next", size: 18.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
}
