//
//  DurationPickerViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/31/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class DurationPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hours = [String]()
    var minutes = [String]()
    var tempMinutes = ""
    var tempHours = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 0...24{
            hours.append(String(x))
        }
        
        for x in 0...59{
            minutes.append(String(x))
        }
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
