//
//  AMRAPViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/15/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  This controller allows the user to create an Amrap

import UIKit

class AmrapViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var emomMinutesLabel: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exerciseNumber:Int = 1
    var exerciseList:[String] = [""]
    var categoryPassed:String!
    
    var minutes = [String]()
    var seconds = [String]()
    
    var emomTime = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 0...59{
            minutes.append(String(x))
            seconds.append(String(x))
        }
        
        secondsLabel.alpha = 0
        minutesLabel.alpha = 0
        emomMinutesLabel.alpha = 0
        
        title = categoryPassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
                
        for i in 1...100{
            emomTime.append(String(i))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    @IBAction func addExercise(_ sender: UIBarButtonItem) {
        exerciseNumber += 1
        exerciseList.append("")
        tableView.reloadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if categoryPassed == "Emom"{
            return 1
        }else{
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categoryPassed == "Emom"{
            return emomTime.count
        }else{
            if component == 0{
               return seconds.count
            }else{
               return minutes.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if categoryPassed == "Emom"{
            return emomTime[row]
        }else{
            if component == 0{
                return seconds[row]
            }else{
                return minutes[row]
            }
        }
    }

    @IBAction func addMetcon(_ sender: UIButton) {
        if categoryPassed == "Amrap"{
        myExercise.name = "Amrap"
        let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        var amrapString = ""
        for exercise in exerciseList{
            if !exercise.isEmpty {
                amrapString.append(exercise)
                amrapString.append(" | ")
            }
        }
        myExercise.category = "Amrap"
        myExercise.type = "Crossfit"
        myExercise.exerciseDescription = (seconds[id] + minutes[id] + " | " + amrapString)

        }else{
            myExercise.name = "Emom"
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            var emomString = ""
            for exercise in exerciseList{
                if !exercise.isEmpty {
                    emomString.append(exercise)
                    emomString.append(" | ")
                }
            }
            myExercise.category = "Emom"
            myExercise.type = "Crossfit"
            myExercise.exerciseDescription = (emomTime[id] + " | " + emomString)
            DBService.shared.setEmomTime(time:emomTime[id])
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AmrapCell", for: indexPath) as! AmrapCustomCell
        let text = exerciseList[(indexPath as NSIndexPath).row]
        cell.exTextField.text = text
        cell.exTextField.tag = (indexPath as NSIndexPath).row
        cell.exTextField.addTarget(self, action: #selector(MetconViewController.textFieldDidChange(_:)), for:UIControlEvents.editingChanged)
        return cell
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        let index = textField.tag
        exerciseList[index] = textField.text!
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        secondsLabel.alpha = 0
        minutesLabel.alpha = 0
        emomMinutesLabel.alpha = 0
        
        if categoryPassed == "Emom"{
            emomMinutesLabel.alpha = 1
            let label = UILabel()
            label.text = emomTime[row]
            let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
            label.attributedText = myTitle
            label.textAlignment = NSTextAlignment.center
            return label
        }else{
            secondsLabel.alpha = 1
            minutesLabel.alpha = 1
            let label = UILabel()
            if component == 0{
                label.text = seconds[row]
            }else if component == 1{
                label.text = minutes[row]
            }
            
            let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
            label.attributedText = myTitle
            label.textAlignment = NSTextAlignment.center
            return label
        }
    }
}
