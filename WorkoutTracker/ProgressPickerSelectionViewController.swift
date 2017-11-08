//
//  ProgressPickerSelectionViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 11/8/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class ProgressPickerSelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var exercisePicker: UIPickerView!
    
    var categories = [String]()
    var exerciseNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveCategoriesForType()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return categories.count
        }else{
          return exerciseNames.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return categories[row]
        }else{
            return exerciseNames[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
//        if tagPassed == 1{
//            let tempWeight = weights[row] + " lb(s)"
//            tempResult = tempWeight
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
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
