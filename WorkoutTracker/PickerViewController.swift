//
//  PickerViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/15/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var namesPassed:[String]!
    var weights = ["1", "2", "3", "4", "5", "10", "15", "25", "35", "45"]
    var minutes = ["minutes","1","2","3", "4", "5", "6", "7", "8", "9", "10", "15"]
    var hours = ["hours","1", "2"]
    var seconds = ["seconds","1", "2"]
    var tagPassed = 0
    var tempHours = ""
    var tempMinutes = ""
    var tempSeconds = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        }else{
            return weights.count
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
        }else{
            return weights[row]
        }
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        let presenter = self.presentingViewController?.childViewControllers.last as! WorkoutInputViewController
        if tagPassed == 1{
        let pickerName = namesPassed[row]
        presenter.savePickerName(name: pickerName)
        }else if tagPassed == 2{
 
            if component == 0{
                tempHours = hours[row]
            }else if component == 1{
                tempMinutes = minutes[row]
            }else if component == 2{
                tempSeconds = seconds[row]
            }
            let tempTime = tempHours + "h " + tempMinutes + "m " + tempSeconds + "s"
            presenter.saveTime(time:tempTime)
        }else if tagPassed == 3{
            let tempWeight = weights[row]
            presenter.saveWeight(weight:tempWeight)
        }
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
