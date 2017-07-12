//
//  PickerViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/15/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var hLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var lbsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    var namesPassed:[String]!
    var weights = [String]()
    var reps = [String]()
    var minutes = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "15"]
    var hours = ["0","1", "2"]
    var seconds = ["0", "1", "2"]
    var emom = [String]()
    var tagPassed = 0
    var tempHours = ""
    var tempMinutes = ""
    var tempSeconds = ""
    var tempResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secLabel.alpha = 0
        hLabel.alpha = 0
        minLabel.alpha = 0
        lbsLabel.alpha = 0
        setsLabel.alpha = 0
        repsLabel.alpha = 0
        
        for i in 0...500{
            weights.append(String(i))
            reps.append(String(i))
        }
        
        
        if tagPassed == 5{
            let max = Int(DBService.shared.emomTime)
            for i in 0...max!{
                emom.append(String(i))
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }else if tagPassed == 4{
            return reps.count
        }else{
            return emom.count
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
        }else if tagPassed == 4{
            return reps[row]
        }else{
            return emom[row]
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
            let tempTime = tempHours + " hour(s) " + tempMinutes + " min(s) " + tempSeconds + " sec(s)"
            tempResult = tempTime
        }else if tagPassed == 3{
            let tempWeight = weights[row] + " lbs"
            tempResult = tempWeight
        }else if tagPassed == 4{
            let tempReps = reps[row] + " rep(s)"
            tempResult = tempReps
        }else if tagPassed == 5{
            var temp = emom[row] + " minute(s) completed"
            if emom[row] == "Completed"{
                temp = emom[row]
            }
            tempResult = temp
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        let presenter = self.presentingViewController?.childViewControllers.last as! WorkoutInputViewController
        if tagPassed == 1{
            if tempResult == ""{
                tempResult = namesPassed[0]
            }
            presenter.savePickerName(name: tempResult)
        }else{
            //first value force selection
            if tempResult == ""{
                if tagPassed == 2{
                    tempResult = "0 hour(s) 0 min(s) 0 sec(s)"
                }else if tagPassed == 3{
                    tempResult = "0 lbs"
                }else if tagPassed == 4{
                    tempResult = "0 reps"
                }else{
                    tempResult = "0 minute(s) completed"
                }
            }
            //format result
            tempResult = Formatter.formatResult(str: tempResult)
            presenter.saveResult(str: tempResult)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        secLabel.alpha = 0
        hLabel.alpha = 0
        minLabel.alpha = 0
        lbsLabel.alpha = 0
        setsLabel.alpha = 0
        repsLabel.alpha = 0
        if tagPassed == 1{
            label.text = namesPassed[row]
        }else if tagPassed == 2{
            hLabel.alpha = 1
            minLabel.alpha = 1
            secLabel.alpha = 1
            if component == 0{
                label.text = hours[row]
            }else if component == 1{
                label.text = minutes[row]
            }else{
                label.text = seconds[row]
            }
        }else if tagPassed == 3{
            lbsLabel.alpha = 1
            label.text = weights[row]
        }else if tagPassed == 4{
            repsLabel.alpha = 1
            label.text = reps[row]
        }else{
            minLabel.alpha = 1
            label.text = emom[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 25.0)!,NSForegroundColorAttributeName:UIColor.black])
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
