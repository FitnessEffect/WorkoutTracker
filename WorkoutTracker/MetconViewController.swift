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
    
    @IBOutlet weak var exOneOutlet: UITextField!
    @IBOutlet weak var exTwoOutlet: UITextField!
    @IBOutlet weak var exTreeOutlet: UITextField!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    var clickCount:Int = 0
    let exerciseKey:String = "exerciseKey"
    var stringExercise:String = ""
    var myExercise = Exercise()
    
    let rounds = ["Rounds", "1 round", "2 rounds", "3 rounds", "4 rounds", "5 rounds", "6 rounds", "7 rounds", "8 rounds", "9 rounds", "10 rounds"]
    
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
        return rounds.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rounds[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let pickerRound = rounds[pickerView.selectedRowInComponent(0)]
        
        let temp = pickerRound
        stringExercise = String(temp)
    }
    
    @IBAction func addMetcon(sender: UIButton) {
        myExercise.name = "Metcon"
        myExercise.exerciseDescription = (stringExercise + " | " + exOneOutlet.text! + " | " + exTwoOutlet.text! + " | " + exTreeOutlet.text!)
        
        NSNotificationCenter.defaultCenter().postNotificationName("getExerciseID", object: nil, userInfo: [exerciseKey:myExercise])
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
