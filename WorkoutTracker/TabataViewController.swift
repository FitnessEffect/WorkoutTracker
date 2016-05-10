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
    
    @IBOutlet weak var picketOutlet: UIPickerView!
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var textFieldOutlet2: UITextField!
    @IBOutlet weak var textFieldOutlet3: UITextField!
    
    let exerciseKey:String = "exerciseKey"
    var stringExercise:String = ""
    var myExercise = Exercise()
    var clickCount:Int = 0
    var exerciseNumber:Int = 1
    var exerciseList:[Int] = [1]
    
    
    let rest = ["Rest", "5 seconds", "10 seconds", "15 seconds", "20 seconds", "25 seconds", "30 seconds"]
    let work = ["Work", "15 seconds", "30 seconds", "45 seconds", "1 minute", "1min 30sec", "2 minutes", "2min 30sec", "3 minutes"]
    let totalTime = ["Time", "1 minute", "1min 30sec", "2 minutes", "2min 30sec", "3 minutes", "4 minutes", "5 minutes", "6 minutes", "7 minutes", "8 minutes", "9 minutes", "10 minutes", "15 minutes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldOutlet2.hidden = true
        textFieldOutlet3.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func add(sender: UIBarButtonItem) {
        clickCount += 1
        if clickCount == 1{
            textFieldOutlet2.hidden = false
        }
        if clickCount == 2{
            textFieldOutlet3.hidden = false
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return rest.count
        }else if component == 1{
            return work.count
        }else{
            return totalTime.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return rest[row]
        }else if component == 1{
            return work[row]
        }else{
            return totalTime[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
           let pickerRest = rest[pickerView.selectedRowInComponent(0)]
            print(pickerRest)
           let pickerWork = work[pickerView.selectedRowInComponent(1)]
        print(pickerWork)
           let pickerTotalTime = totalTime[pickerView.selectedRowInComponent(2)]
        print(pickerTotalTime)
        
        let temp = (pickerRest + " rest - " + pickerWork + " work - " + pickerTotalTime + " total")
        stringExercise = String(temp)
    }

    @IBAction func addTabata(sender: UIButton) {
        myExercise.name = "Tabata"
        
       
         myExercise.exerciseDescription = (textFieldOutlet.text! + " | " + textFieldOutlet2.text! + " | " + textFieldOutlet3.text! + " (" + stringExercise + ")")
        
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TabataCell", forIndexPath: indexPath) as! TabataCustomCell
            
        let exercise = exerciseList[indexPath.row]
            cell.exLabel.text = "Exercise " + String(exercise) + ":"
        return cell
    }
}

