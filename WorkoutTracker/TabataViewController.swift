//
//  TabataViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/15/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  This controller allows the user to create a Tabata

import UIKit

class TabataViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exerciseNumber:Int = 1
    var exerciseList:[String] = [""]
    
    let rest = ["-- Rest --", "5 sec", "10 sec", "15 sec", "20 sec", "25 sec", "30 sec"]
    let work = ["-- Work --", "15 sec", "30 sec", "45 sec", "1 min", "1m 30s", "2 min", "2m 30s", "3 min"]
    let totalTime = ["-- Time -- ", "1 min", "1m 30s", "2 min", "2m 30s", "3 min", "4 min", "5 min", "6 min", "7 min", "8 min", "9 min", "10 min", "15 min"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        exerciseNumber += 1
        exerciseList.append("")
        tableView.reloadData()
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return rest.count
        }else if component == 1{
            return work.count
        }else{
            return totalTime.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return rest[row]
        }else if component == 1{
            return work[row]
        }else{
            return totalTime[row]
        }
    }
    
    @IBAction func addTabata(_ sender: UIButton) {
        
        myExercise.name = "Tabata"
        let id:Int = pickerOutlet.selectedRow(inComponent: 2)
        var tabataString = ""
        for exercise in exerciseList{
            if !exercise.isEmpty {
                tabataString.append(exercise)
                tabataString.append(" | ")
            }
        }
        
        myExercise.category = "Tabata"
        
        myExercise.exerciseDescription = rest[id] + " rest" + " - " + work[id] + " work" + " - " + totalTime[id] +  " total" + " | " + tabataString
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabataCell", for: indexPath) as! TabataCustomCell
        
        var text = exerciseList[(indexPath as NSIndexPath).row]
//        if text.isEmpty{
//            text = "Exercise: " + String((indexPath as NSIndexPath).row + 1)
//        }

        cell.exTextField.text = text
        cell.exTextField.tag = (indexPath as NSIndexPath).row
        cell.exTextField.addTarget(self, action: #selector(TabataViewController.textFieldDidChange(_:)), for:UIControlEvents.editingChanged)
        
        return cell
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        let index = textField.tag
        exerciseList[index] = textField.text!
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()

                if component == 0 {
                    label.text = rest[row]
                }else if component == 1{
                    label.text = work[row]
                }else{
                    label.text = totalTime[row]
                }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day Demo", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 20.0
//    }
}

