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
    
    @IBOutlet weak var exTreeOutlet: UITextField!
    @IBOutlet weak var exTwoOutlet: UITextField!
    @IBOutlet weak var exOneOutlet: UITextField!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    var clickCount:Int = 0
    let exerciseKey:String = "exerciseKey"
    var stringExercise:String = ""
    var myExercise = Exercise()
    
    let time = ["Time", "1 minute", "1min 30sec", "2 minutes", "2min 30sec", "3 minutes", "4 minutes", "5 minutes", "6 minutes", "7 minutes", "8 minutes", "9 minutes", "10 minutes", "15 minutes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exTwoOutlet.hidden = true
        exTreeOutlet.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addExercise(sender: UIBarButtonItem) {
        clickCount += 1
        if clickCount == 1{
            exTwoOutlet.hidden = false
        }
        if clickCount == 2{
            exTreeOutlet.hidden = false
        }
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let pickerTime = time[pickerView.selectedRowInComponent(0)]
        let temp = pickerTime
        stringExercise = String(temp)
    }

    @IBAction func addMetcon(sender: UIButton) {
        myExercise.name = "Armrap"
        myExercise.exerciseDescription = (stringExercise + " | " + exOneOutlet.text! + " | " + exTwoOutlet.text! + " | " + exTreeOutlet.text!)
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
