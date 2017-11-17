//
//  EnduranceSelectionViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/19/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class EnduranceSelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var metersLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var categoryPassed = ""
    var miles = [String]()
    var meters = ["500", "1000", "1500", "2000", "5000", "10000"]
    var hours = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    var minutes = [String]()
    var seconds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = categoryPassed
        metersLabel.alpha = 0
        milesLabel.alpha = 0
        hourLabel.alpha = 0
        minLabel.alpha = 0
        secLabel.alpha = 0
        
        for i in 0...59{
            minutes.append(String(i))
            seconds.append(String(i))
        }
        for i in 0...1000{
            miles.append(String(i))
        }
        
        if categoryPassed == "Rowing"{
            metersLabel.alpha = 1
        }else{
            milesLabel.alpha = 1
        }
        segmentedControl.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Have a Great Day", size: 20)!], for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if segmentedControl.selectedSegmentIndex == 0{
            return 1
        }else{
            return 3
        }
    }
    
    @IBAction func segmentedBtn(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if categoryPassed == "Rowing"{
                metersLabel.alpha = 1
            }else{
                milesLabel.alpha = 1
            }
            hourLabel.alpha = 0
            minLabel.alpha = 0
            secLabel.alpha = 0
            pickerOutlet.reloadAllComponents()
        }else if segmentedControl.selectedSegmentIndex == 1{
            milesLabel.alpha = 0
            metersLabel.alpha = 0
            hourLabel.alpha = 1
            minLabel.alpha = 1
            secLabel.alpha = 1
            pickerOutlet.reloadAllComponents()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0{
            if categoryPassed == "Rowing"{
                return meters.count
            }else{
                return miles.count
            }
        }else{
            if component == 0{
                return hours.count
            }else if component == 1{
                return minutes.count
            }else{
                return seconds.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if segmentedControl.selectedSegmentIndex == 0{
            if categoryPassed == "Rowing"{
                return meters[row]
            }else{
                return miles[row]
            }
        }else{
            if component == 0{
                return hours[row]
            }else if component == 1{
                return minutes[row]
            }else{
                return seconds[row]
            }
        }
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        myExercise.category = self.title!
        myExercise.type = "Endurance"
        
        if segmentedControl.selectedSegmentIndex == 0{
            myExercise.name = "Distance"
        }else{
            myExercise.name = "Time"
        }
        
        if segmentedControl.selectedSegmentIndex == 0{
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            if categoryPassed == "Rowing"{
                myExercise.exerciseDescription = "For " + meters[id] + " meter(s) "
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                dismiss(animated: true, completion: nil)
            }else{
                myExercise.exerciseDescription = miles[id] + " mile(s) "
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                dismiss(animated: true, completion: nil)
            }
        }else{
            let idHours:Int = pickerOutlet.selectedRow(inComponent: 0)
            let idMinutes:Int = pickerOutlet.selectedRow(inComponent: 1)
            let idSeconds:Int = pickerOutlet.selectedRow(inComponent: 2)
            myExercise.exerciseDescription = hours[idHours] + " hour(s) " + minutes[idMinutes] + " minute(s) " + seconds[idSeconds] + " second(s) "
            NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
            dismiss(animated: true, completion: nil)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if segmentedControl.selectedSegmentIndex == 0{
            if categoryPassed == "Rowing"{
                label.text = meters[row]
            }else{
                label.text = miles[row]
            }
        }else{
            if component == 0{
                label.text = hours[row]
            }else if component == 1{
                label.text = minutes[row]
            }else{
                label.text = seconds[row]
            }
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
