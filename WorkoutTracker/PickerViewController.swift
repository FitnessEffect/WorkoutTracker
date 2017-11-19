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
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var metersLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var durationHours: UILabel!
    @IBOutlet weak var durationMinutes: UILabel!
    @IBOutlet weak var roundsLabel: UILabel!
    
    var namesPassed:[String]!
    var weights = [String]()
    var reps = [String]()
    var hours = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    var supersetSets = ["Completed", "Incomplete"]
    var minutes = [String]()
    var seconds = [String]()
    var miles = [String]()
    var meters = [String]()
    var emom = [String]()
    var tabata = [String]()
    var tagPassed = 0
    var tempHours = ""
    var tempMinutes = ""
    var tempSeconds = ""
    var tempResult = ""
    var sessionNames = [String]()
    var rounds = [String]()
    var currentSessName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secLabel.alpha = 0
        hLabel.alpha = 0
        minLabel.alpha = 0
        lbsLabel.alpha = 0
        repsLabel.alpha = 0
        roundsLabel.alpha = 0
        
        for i in 0...1500{
            weights.append(String(i))
            reps.append(String(i))
            miles.append(String(i))
        }
        
        for i in 0...50000{
            meters.append(String(i))
        }
        
        for i in 0...59{
            minutes.append(String(i))
            seconds.append(String(i))
        }
        
        for i in 0...100{
            rounds.append(String(i))
        }
        
        if tagPassed == 5{
            let max = Int(DBService.shared.emomTime)
            for i in 0...max!{
                emom.append(String(i))
            }
        }
        
        if tagPassed == 6{
            let temp = DBService.shared.tabataTime
            let arr = temp.components(separatedBy: " ")
            let max = Int(arr[0])
            for i in 0...max!{
                tabata.append(String(i))
            }
        }
        
        if tagPassed == 0{
            
            milesLabel.alpha = 0
            metersLabel.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tagPassed == 0{
            for i in 0...sessionNames.count-1{
                if sessionNames[i] == currentSessName{
                    pickerView.selectRow(i, inComponent: 0, animated: true)
                    break
                }
            }
        }
    }
    
    func setCurrentSessionName(currentSessionName:String){
        currentSessName = currentSessionName
    }
    
    func setSessionNames(names:[String]){
        sessionNames = names
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
        if tagPassed == 0{
            return sessionNames.count
        }else if tagPassed == 1{
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
        }else if tagPassed == 5{
            return emom.count
        }else if tagPassed == 6{
            return tabata.count
        }else if tagPassed == 8{
            return meters.count
        }else if tagPassed == 9{
            return miles.count
        }else if tagPassed == 11{
            return rounds.count
        }else{
            return supersetSets.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if tagPassed == 0{
            return sessionNames[row]
        }else if tagPassed == 1{
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
        }else if tagPassed == 5{
            return emom[row]
        }else if tagPassed == 6{
            return tabata[row]
        }else if tagPassed == 8{
            return meters[row]
        }else if tagPassed == 9{
            return miles[row]
        }else if tagPassed == 11{
            return rounds[row]
        }else{
            return supersetSets[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if tagPassed == 0{
            tempResult = sessionNames[row]
        }else if tagPassed == 1{
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
            let tempWeight = weights[row] + " lb(s)"
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
        }else if tagPassed == 6{
            let temp = tabata[row] + " minute(s) completed"
            tempResult = temp
        }else if tagPassed == 7{
            let temp = supersetSets[row]
            tempResult = temp
        }else if tagPassed == 8{
            let temp = meters[row] + " meter(s)"
            tempResult = temp
        }else if tagPassed == 11{
            let temp = rounds[row] + " round(s)"
            tempResult = temp
        }else{
            let temp = miles[row] + " mile(s)"
            tempResult = temp
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        let presenter = self.presentingViewController?.childViewControllers.last as! InputExerciseViewController
        if tagPassed == 0{
            if tempResult == ""{
            tempResult = sessionNames[0]
            }
            presenter.savePickerSessionName(name: tempResult)
        }else if tagPassed == 1{
            if tempResult == ""{
                tempResult = namesPassed[0]
            }
            presenter.savePickerName(name: tempResult)
        }else{
            //first value force selection
            if tempResult == ""{
                if tagPassed == 0{
                    tempResult = sessionNames[0]
                }else if tagPassed == 1{
                    tempResult = namesPassed[0]
                }else if tagPassed == 2{
                    tempResult = "0 hour(s) 0 min(s) 0 sec(s)"
                }else if tagPassed == 3{
                    tempResult = "0 lb(s)"
                }else if tagPassed == 4{
                    tempResult = "0 rep(s)"
                }else if tagPassed == 5 || tagPassed == 6{
                    tempResult = "0 minute(s) completed"
                }else if tagPassed == 8{
                    tempResult = "0 meter(s)"
                }else if tagPassed == 7{
                    tempResult = "Completed"
                }else if tagPassed == 11{
                    tempResult = "0 round(s)"
                }else{
                    tempResult = "0 mile(s)"
                }
            }
            if tagPassed == 2{
                tempResult = Formatter.formatResult(str: tempResult)
            }
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
        repsLabel.alpha = 0
        milesLabel.alpha = 0
        metersLabel.alpha = 0
        roundsLabel.alpha = 0
        if tagPassed == 0{
            label.text = sessionNames[row]
        }else if tagPassed == 1{
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
        }else if tagPassed == 5{
            minLabel.alpha = 1
            label.text = emom[row]
        }else if tagPassed == 6{
            minLabel.alpha = 1
            label.text = tabata[row]
        }else if tagPassed == 7{
            label.text = supersetSets[row]
        }else if tagPassed == 8{
            metersLabel.alpha = 1
            label.text = meters[row]
        }else if tagPassed == 11{
            roundsLabel.alpha = 1
            label.text = rounds[row]
        }else{
            milesLabel.alpha = 1
            label.text = miles[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
