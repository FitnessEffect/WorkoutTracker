//
//  MetconViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/15/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  This controller allows the user to create a Metcon

import UIKit

class MetconViewController: UIViewController {

    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    var clickCount:Int = 0
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exerciseNumber:Int = 1
    var exerciseList:[Int] = [1]
    var textViews:[UITextField] = []
    
    let rounds = ["1 round", "2 rounds", "3 rounds", "4 rounds", "5 rounds", "6 rounds", "7 rounds", "8 rounds", "9 rounds", "10 rounds"]
    
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
        return rounds.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rounds[row]
    }
    
    @IBAction func addMetcon(sender: UIButton) {
        
        myExercise.name = "Metcon"
        let id:Int = pickerOutlet.selectedRowInComponent(0)
        var str = ""
        for textField in textViews{
            str.appendContentsOf(textField.text!)
            str.appendContentsOf(" | ")
        }
        myExercise.exerciseDescription = (rounds[id] + " | " + str)
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MetconCell", forIndexPath: indexPath) as! MetconCustomCell
        
        if textViews.count < indexPath.row + 1 {
            textViews.append(cell.exTextField)
        }
        
        let exerciseCount = indexPath.row + 1
        cell.exTextField.text = "Exercise " + String(exerciseCount) + ":"
        return cell
    }
}
