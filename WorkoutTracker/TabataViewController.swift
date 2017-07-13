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
    @IBOutlet weak var scrollView: UIScrollView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exerciseNumber:Int = 1
    var exerciseList:[String] = [""]
    var categoryPassed:String!
    
    let rest = ["5 sec ", "10 sec", "15 sec", "20 sec", "25 sec", "30 sec", "35 sec ", "40 sec", "45 sec", "50 sec", "55 sec", "1 min", "1m 15s", "1m 30s", "1m 45s", "2 min", "2m 15s", "2m 30s", "2m 45s", "3 min", "3m 15s", "3m 30s", "3m 45s", "4 min", "4m 15s", "4m 30s", "4m 45s", "5 min", "5m 15s", "5m 30s", "5m 45s", "6 min", "6m 15s", "6m 30s", "6m 45s", "7 min", "7m 15s", "7m 30s", "7m 45s", "8 min", "8m 15s", "8m 30s", "8m 45s", "9 min", "9m 15s", "9m 30s", "9m 45s", "10 min", "10m 15s", "10m 30s", "10m 45s", "11 min", "11m 15s", "11m 30s", "11m 45s", "12 min", "12m 15s", "12m 30s", "12m 45s", "13 min", "13m 15s", "13m 30s", "13m 45s", "14 min", "14m 15s", "14m 30s", "14m 45s", "15 min", "15m 15s", "15m 30s", "15m 45s", "16 min", "16m 15s", "16m 30s", "16m 45s", "17 min", "17m 15s", "17m 30s", "17m 45s", "18 min", "18m 15s", "18m 30s", "18m 45s", "19 min", "19m 15s", "19m 30s", "19m 45s", "20 min", "20m 15s", "20m 30s", "20m 45s", "21 min", "21m 15s", "21m 30s", "21m 45s", "22 min", "22m 15s", "22m 30s", "22m 45s", "23 min", "23m 15s", "23m 30s", "23m 45s", "24 min", "24m 15s", "24m 30s", "24m 45s", "25 min", "25m 15s", "25m 30s", "25m 45s", "26 min", "26m 15s", "26m 30s", "26m 45s", "27 min", "27m 15s", "27m 30s", "27m 45s", "28 min", "28m 15s", "28m 30s", "28m 45s", "29 min", "29m 15s", "29m 30s", "29m 45s", "30 min"]
    let work = ["5 sec ", "10 sec", "15 sec", "20 sec", "25 sec", "30 sec", "35 sec ", "40 sec", "45 sec", "50 sec", "55 sec", "1 min", "1m 15s", "1m 30s", "1m 45s", "2 min", "2m 15s", "2m 30s", "2m 45s", "3 min", "3m 15s", "3m 30s", "3m 45s", "4 min", "4m 15s", "4m 30s", "4m 45s", "5 min", "5m 15s", "5m 30s", "5m 45s", "6 min", "6m 15s", "6m 30s", "6m 45s", "7 min", "7m 15s", "7m 30s", "7m 45s", "8 min", "8m 15s", "8m 30s", "8m 45s", "9 min", "9m 15s", "9m 30s", "9m 45s", "10 min", "10m 15s", "10m 30s", "10m 45s", "11 min", "11m 15s", "11m 30s", "11m 45s", "12 min", "12m 15s", "12m 30s", "12m 45s", "13 min", "13m 15s", "13m 30s", "13m 45s", "14 min", "14m 15s", "14m 30s", "14m 45s", "15 min", "15m 15s", "15m 30s", "15m 45s", "16 min", "16m 15s", "16m 30s", "16m 45s", "17 min", "17m 15s", "17m 30s", "17m 45s", "18 min", "18m 15s", "18m 30s", "18m 45s", "19 min", "19m 15s", "19m 30s", "19m 45s", "20 min", "20m 15s", "20m 30s", "20m 45s", "21 min", "21m 15s", "21m 30s", "21m 45s", "22 min", "22m 15s", "22m 30s", "22m 45s", "23 min", "23m 15s", "23m 30s", "23m 45s", "24 min", "24m 15s", "24m 30s", "24m 45s", "25 min", "25m 15s", "25m 30s", "25m 45s", "26 min", "26m 15s", "26m 30s", "26m 45s", "27 min", "27m 15s", "27m 30s", "27m 45s", "28 min", "28m 15s", "28m 30s", "28m 45s", "29 min", "29m 15s", "29m 30s", "29m 45s", "30 min"]
    var totalTime = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = categoryPassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        for i in 1...100{
            totalTime.append(String(i) + " min")
        }
        
        registerForKeyboardNotifications()
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
        if tableView.frame.contains(sender.location(in: view)) {
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
        if scrollView.contentOffset.y > 50{
            scrollView.contentOffset.y = 50
        }
        if scrollView.contentOffset.y < 0{
            scrollView.contentOffset.y = 0
        }
    }
    
    func setCategory(category:String){
        categoryPassed = category
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
        myExercise.type = "Crossfit"
        
        if tabataString == ""{
            let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            myExercise.exerciseDescription = rest[id] + " rest" + " - " + work[id] + " work" + " - " + totalTime[id] +  " total" + " | " + tabataString
            DBService.shared.setTabataTime(time:totalTime[id])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
            dismiss(animated: true, completion: nil)
        }
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabataCell", for: indexPath) as! TabataCustomCell
        let text = exerciseList[(indexPath as NSIndexPath).row]
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
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
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

