//
//  ForTimeViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/17/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class ForTimeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exerciseNumber:Int = 1
    var exerciseList:[String] = [""]
    var categoryPassed:String!
    var rounds = [String]()
    var sets = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundsLabel.isHidden = true
        setsLabel.isHidden = true
        
        if categoryPassed == "Superset"{
            setsLabel.isHidden = false
        }else{
            roundsLabel.isHidden = false
        }
        
        for x in 1...99{
            rounds.append(String(x))
            sets.append(String(x))
        }
        
        
        title = categoryPassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if exerciseNumber < 4{
            exerciseNumber += 1
            exerciseList.append("")
            tableView.reloadData()
        }
    }
    
    @IBAction func add(_ sender: UIButton) {
        let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        if categoryPassed == "Superset"{
            myExercise.name = "Superset"
            var supersetString = ""
            for exercise in exerciseList{
                if !exercise.isEmpty {
                    supersetString.append(exercise)
                    supersetString.append(" | ")
                }
            }
            myExercise.category = categoryPassed
            myExercise.type = "Bodybuilding"
            if supersetString == ""{
                let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                myExercise.exerciseDescription =  sets[id] + " set(s)" + " | " + supersetString
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                dismiss(animated: true, completion: nil)
            }
        }else{
            myExercise.name = "For Time"
            var forTimeString = ""
            for exercise in exerciseList{
                if !exercise.isEmpty {
                    forTimeString.append(exercise)
                    forTimeString.append(" | ")
                }
            }
            myExercise.category = "For Time"
            myExercise.type = "Crossfit"
            if forTimeString == ""{
                let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                myExercise.exerciseDescription = rounds[id] + " round(s)" + " | " + forTimeString
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categoryPassed == "Superset"{
          return sets.count
        }else{
            return rounds.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if categoryPassed == "Superset"{
            return sets[row]
        }else{
            return rounds[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if categoryPassed == "Superset"{
           label.text = sets[row]
        }else{
           label.text = rounds[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 23.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
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
}
