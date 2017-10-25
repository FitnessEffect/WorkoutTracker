//
//  ProgressPickerViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 10/24/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class ProgressPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var lbsLabel: UILabel!
    
    var tagPassed = 0
    var weights = [String]()
    var tempResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...1500{
            weights.append(String(i))
        }
    }
    
    func setTag(tag: Int){
        tagPassed = tag
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weights.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weights[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if tagPassed == 1{
            let tempWeight = weights[row] + " lb(s)"
            tempResult = tempWeight
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        //let presenter = self.presentingViewController?.childViewControllers.last as! InputExerciseViewController
        if tagPassed == 1{
            //first value force selection
            if tempResult == ""{
                tempResult = "0 lb(s)"
            }
        }
        //presenter.saveResult(str: tempResult)
        let uploadTime = DateConverter.getCurrentTimeAndDate()
        DBService.shared.addDataToPersonalProgress(selection: "Weight", newData: [uploadTime:tempResult], completion: {self.dismiss(animated: true, completion: nil)})
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        lbsLabel.alpha = 0
        if tagPassed == 1{
            lbsLabel.alpha = 1
            label.text = weights[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
