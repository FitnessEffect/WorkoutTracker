//
//  ProfileStatsViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/20/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ProfileStatsViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var agePickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    
    var edit = false
    var age = [String]()
    var inches = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var feet = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    var weight = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 0...120{
            age.append(String(x))
        }
        for x in 0...700{
            weight.append(String(x))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveUserStats(){
            if DBService.shared.userStats["age"] as! String != ""{
                for index in 0...self.age.count-1{
                    if self.age[index] == DBService.shared.userStats["age"] as! String{
                        self.agePickerView.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                }
                for index in 0...self.weight.count-1{
                    if self.weight[index] == DBService.shared.userStats["weight"] as! String{
                        self.weightPickerView.selectRow(index, inComponent: 0, animated: true)
                    }
                }
                for index in 0...self.feet.count-1{
                    if self.feet[index] == DBService.shared.userStats["feet"] as! String{
                        self.heightPickerView.selectRow(index, inComponent: 0, animated: true)
                    }
                }
                for index in 0...self.inches.count-1{
                    if self.inches[index] == DBService.shared.userStats["inches"] as! String{
                        self.heightPickerView.selectRow(index, inComponent: 1, animated: true)
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        edit = false
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
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    @IBAction func createClient(_ sender: UIButton) {
            let ageId:Int = agePickerView.selectedRow(inComponent: 0)
            let tempAge = self.age[ageId]
            let ftId:Int = heightPickerView.selectedRow(inComponent: 0)
            let tempFeet = feet[ftId]
            let inId:Int = heightPickerView.selectedRow(inComponent: 1)
            let tempInches = inches[inId]
            let lbsId:Int = weightPickerView.selectedRow(inComponent: 0)
            let tempWeight = weight[lbsId]
    
            var userDictionary = [String:Any]()
            userDictionary["age"] = tempAge
            userDictionary["feet"] = tempFeet
            userDictionary["inches"] = tempInches
            userDictionary["weight"] = tempWeight
            
            DBService.shared.updateProfileStats(newStats: userDictionary, completion: {
                let presenter = self.presentingViewController?.childViewControllers.last
                self.dismiss(animated: true, completion: {presenter?.viewWillAppear(true)})
            })
    }
}
