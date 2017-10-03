//
//  DurationPickerViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/31/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class DurationPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerViewOutlet: UIPickerView!
    
    var hours = [String]()
    var minutes = [String]()
    var tempMinutes = ""
    var tempHours = ""
    var passedDuration = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 0...24{
            hours.append(String(x))
        }
        
        for x in 0...59{
            minutes.append(String(x))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if passedDuration != ""{
            let tempArr = passedDuration.components(separatedBy: " ")
            if tempArr.count == 2{
                if tempArr[1] == "hour(s)"{
                    pickerViewOutlet.selectRow(Int(tempArr[0])!, inComponent: 0, animated: true)
                }else if tempArr[1] == "min(s)"{
                    pickerViewOutlet.selectRow(Int(tempArr[0])!, inComponent: 1, animated: true)
                }
            }else{
                pickerViewOutlet.selectRow(Int(tempArr[0])!, inComponent: 0, animated: true)
                pickerViewOutlet.selectRow(Int(tempArr[2])!, inComponent: 1, animated: true)
            }
        }
    }
    
    func setDuration(duration:String){
        passedDuration = duration
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return hours.count
        }else{
            return minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return hours[row]
        }else{
            return minutes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if component == 0{
            tempHours = hours[row]
        }else{
            tempMinutes = minutes[row]
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        let presenter = self.presentingViewController?.childViewControllers.last as! SessionDetailViewController
        
        if tempHours == ""{
            tempHours = "0"
        }
        if tempMinutes == ""{
            tempMinutes = "0"
        }
        let tempResult = tempHours + " hour(s) " + tempMinutes + " min(s)"
        
        presenter.saveResult(result: tempResult)
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if component == 0{
            label.text = hours[row]
        }else{
            label.text = minutes[row]
        }
        
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
