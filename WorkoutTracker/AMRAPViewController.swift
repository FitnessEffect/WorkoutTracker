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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    var clickCount:Int = 0
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exerciseNumber:Int = 1
    var exerciseList:[Int] = [1]
    var textViews:[UITextField] = []
    
    let time = ["1 minute", "1min 30sec", "2 minutes", "2min 30sec", "3 minutes", "4 minutes", "5 minutes", "6 minutes", "7 minutes", "8 minutes", "9 minutes", "10 minutes", "15 minutes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageOutlet.image = UIImage(named: "Background1.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addExercise(sender: UIBarButtonItem) {
        exerciseNumber += 1
        exerciseList.append(exerciseNumber)
        tableView.reloadData()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return time.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return time[row]
    }

    @IBAction func addMetcon(sender: UIButton) {
        
        myExercise.name = "Amrap"
        let id:Int = pickerOutlet.selectedRowInComponent(0)
        var str = ""
        for textField in textViews{
            str.appendContentsOf(textField.text!)
            str.appendContentsOf(" | ")
        }

        myExercise.exerciseDescription = (time[id] + " | " + str)
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AmrapCell", forIndexPath: indexPath) as! AmrapCustomCell
        
        if textViews.count < indexPath.row + 1 {
            textViews.append(cell.exTextField)
        }
        
        let exerciseCount = indexPath.row + 1
        cell.exTextField.text = "Exercise " + String(exerciseCount) + ":"
        return cell
    }
}
