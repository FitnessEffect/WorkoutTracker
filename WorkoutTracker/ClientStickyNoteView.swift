//
//  ClientStickyNoteView.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 10/2/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Foundation
import UIKit

class ClientStickyNoteView: UIView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var age = [String]()
    var inches = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var feet = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    var weight = [String]()
    var activityLevel = ["inactive", "occasional physical activity", "Athlete"]
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ClientStickyNoteView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ClientStickyNoteView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 || pickerView.tag == 1 || pickerView.tag == 3{
            return 1
        }else{
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return age.count
        }else if pickerView.tag == 2{
            if component == 0{
                return feet.count
            }else{
                return inches.count
            }
        }else{
            return weight.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return age[row]
        }else if pickerView.tag == 2{
            if component == 0{
                return feet[row]
            }else{
                return inches[row]
            }
        }else{
            return weight[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if pickerView.tag == 0{
            label.text = age[row]
        }else if pickerView.tag == 2{
            if component == 0{
                label.text = feet[row]
            }else{
                label.text = inches[row]
            }
        }else{
            label.text = weight[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
