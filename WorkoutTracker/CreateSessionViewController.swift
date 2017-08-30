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
    
    var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var dateStrPassed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func create(_ sender: UIButton) {
        let sessionKey = DBService.shared.createSessionKey()
        let index = pickerView.selectedRow(inComponent: 0)
        var sessionDictionary = [String:Any]()
        sessionDictionary["day"] = days[index]
        sessionDictionary["sessionKey"] = sessionKey
        DBService.shared.createSessionForClient(sessionDictionary: sessionDictionary)
        
        self.dismiss(animated: true, completion: nil)
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
