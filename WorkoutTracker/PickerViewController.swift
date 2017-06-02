//
//  PickerViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/15/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var saveBtn: UIButton!
    
    var namesPassed:[String]!
    var weights = [String]()
    var reps = [String]()
    var minutes = ["minutes","1","2","3", "4", "5", "6", "7", "8", "9", "10", "15"]
    var hours = ["hours","1", "2"]
    var seconds = ["seconds","1", "2"]
    var tagPassed = 0
    var tempHours = ""
    var tempMinutes = ""
    var tempSeconds = ""
    var tempResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = 10.0
        saveBtn.clipsToBounds = true
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = UIColor.black.cgColor
        
        weights.append("lbs")
        reps.append("reps")
        
        for i in 0...500{
            weights.append(String(i))
            reps.append(String(i))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setClients(clients:[String]){
        namesPassed = clients
    }
    
    func setTag(tag: Int){
        tagPassed = tag
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if tagPassed == 2{
            return 3
        }else{
        return 1
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if tagPassed == 1{
        return namesPassed.count
        }else if tagPassed == 2{
            if component == 0{
                 return hours.count
            }else if component == 1{
                return minutes.count
            }else{
                 return seconds.count
            }
        }else if tagPassed == 3{
            return weights.count
        }else{
            return reps.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if tagPassed == 1{
            return namesPassed[row]
        }else if tagPassed == 2{
            if component == 0{
                return hours[row]
            }else if component == 1{
               return minutes[row]
            }else{
               return seconds[row]
            }
        }else if tagPassed == 3{
            return weights[row]
        }else{
            return reps[row]
        }
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {

        if tagPassed == 1{
        let pickerName = namesPassed[row]
        tempResult = pickerName
        }else if tagPassed == 2{
 
            if component == 0{
                tempHours = hours[row]
            }else if component == 1{
                tempMinutes = minutes[row]
            }else if component == 2{
                tempSeconds = seconds[row]
            }
            let tempTime = tempHours + "hour(s) " + tempMinutes + "minute(s) " + tempSeconds + "second(s)"
            tempResult = tempTime
        }else if tagPassed == 3{
            let tempWeight = weights[row] + " lbs"
            tempResult = tempWeight
        }else if tagPassed == 4{
            
            let tempReps = reps[row] + " rep(s)"
            tempResult = tempReps
        }
    }

    @IBAction func saveBtn(_ sender: UIButton) {
        let presenter = self.presentingViewController?.childViewControllers.last as! WorkoutInputViewController
        if tagPassed == 1{
            
            presenter.savePickerName(name: tempResult)
        }else if tagPassed == 2{
            
            presenter.saveResult(str: tempResult)
        }else if tagPassed == 3{
            
            presenter.saveResult(str: tempResult)
        }else if tagPassed == 4{
            presenter.saveResult(str: tempResult)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if tagPassed == 1{
            label.text = namesPassed[row]
        }else if tagPassed == 2{
            if component == 0{
                label.text = hours[row]
            }else if component == 1{
                label.text = minutes[row]
            }else{
                label.text = seconds[row]
            }
        }else if tagPassed == 3{
            label.text = weights[row]
        }else{
            label.text = reps[row]
        }
        
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day Demo", size: 25.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        
        return label
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
