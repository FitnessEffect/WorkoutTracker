//
//  CreateSessionViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/30/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class CreateSessionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var sessionName: UILabel!
    
    var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var dateStrPassed = ""
    var sessionNumber = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sessionName.alpha = 0
        DBService.shared.setCurrentDay(day:days[0])
        //check session count
        DBService.shared.checkSessionNumber(){
            self.sessionNumber = -1
            self.sessionNumber = DBService.shared.sessionsCount
            self.sessionName.text = "Session #" + String(self.sessionNumber + 1)
            self.sessionName.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func create(_ sender: UIButton) {
        
        let index = pickerView.selectedRow(inComponent: 0)
        let sessionKey = DBService.shared.createSessionKey()
        let temp = sessionName.text?.components(separatedBy: "#")
        let number = temp?.last
        
        var sessionDictionary = [String:Any]()
        sessionDictionary["day"] = days[index]
        sessionDictionary["key"] = sessionKey
        sessionDictionary["sessionName"] = sessionName.text
        sessionDictionary["sessionNumber"] = number
        sessionDictionary["duration"] = "0 hour(s) 0 min(s)"
        sessionDictionary["paid"] = false
        sessionDictionary["exercises"] = nil
        sessionDictionary["year"] = DBService.shared.currentYear
        sessionDictionary["weekNumber"] = DBService.shared.currentWeekNumber
        sessionDictionary["clientName"] = (DBService.shared.passedClient.firstName + " " + DBService.shared.passedClient.lastName)
        DBService.shared.createSessionForClient(sessionDictionary: sessionDictionary)
        let presenter = self.presentingViewController?.childViewControllers.last
        self.dismiss(animated: true, completion: {presenter?.viewWillAppear(true)})
    }
    
    func passDate(dateStr:String){
        dateStrPassed = dateStr
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        DBService.shared.setCurrentDay(day:days[row])
        //check session count
        DBService.shared.checkSessionNumber(){
            self.sessionNumber = -1
            self.sessionNumber = DBService.shared.sessionsCount
            self.sessionName.text = "Session #" + String(self.sessionNumber + 1)
            self.sessionName.alpha = 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = days[row]
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 28.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }


}
