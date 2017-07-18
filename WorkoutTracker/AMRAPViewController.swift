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
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        
        registerForKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.x<0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.y > 60{
            scrollView.contentOffset.y = 60
        }
        if scrollView.contentOffset.y < 0{
            scrollView.contentOffset.y = 0
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
    
    @IBAction func add(_ sender: UIButton) {
        if categoryPassed == "Amrap"{
            myExercise.name = "Amrap"
            let idMin:Int = pickerOutlet.selectedRow(inComponent: 0)
            let idSec:Int = pickerOutlet.selectedRow(inComponent: 1)
            var amrapString = ""
            for exercise in exerciseList{
                if !exercise.isEmpty {
                    amrapString.append(exercise)
                    amrapString.append(" | ")
                }
            }
            myExercise.category = "Amrap"
            myExercise.type = "Crossfit"
            if amrapString == ""{
                let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                myExercise.exerciseDescription = (minutes[idMin] + " min(s) " + seconds[idSec] + " sec(s)" + " | " + amrapString)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                dismiss(animated: true, completion: nil)
            }
            
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
            if emomString == ""{
                let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                myExercise.exerciseDescription = (emomTime[id] + " minute(s)" + " | " + emomString)
                DBService.shared.setEmomTime(time:emomTime[id])
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                dismiss(animated: true, completion: nil)
            }
        }
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
            
            let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 23.0)!,NSForegroundColorAttributeName:UIColor.black])
            label.attributedText = myTitle
            label.textAlignment = NSTextAlignment.center
            return label
        }
    }
    
    func keyboardWasShown(notification: NSNotification){
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
