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
    

    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    
    let OneRM = ["Back Squat", "Front Squat", "Overhead Squat", "Snatch", "Clean & Jerk", "Clean", "Deadlift", "Bench Press"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        add.layer.cornerRadius = 10.0
        add.clipsToBounds = true
        add.layer.borderWidth = 1
        add.layer.borderColor = UIColor.black.cgColor
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return OneRM.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return OneRM[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        
        let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        myExercise.name = ("1 Rep Max")
        myExercise.exerciseDescription = (OneRM[id])
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
       
        label.text = OneRM[row]
        
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day Demo", size: 28.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
}
