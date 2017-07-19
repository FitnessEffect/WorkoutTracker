//
//  NewClientViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  Creates a new Client and returns it to the ClientViewController.

import UIKit
import Firebase

protocol createClientDelegate{
    func addClient(_ client:Client)
}

class NewClientViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var agePickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var activitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    var delegate:createClientDelegate! = nil
    var myClient = Client()
    var clientPassed = Client()
    var edit = false
    var age = [String]()
    var inches = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var feet = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    var weight = [String]()
    var activityLevel = ["inactive", "occasional physical activity", "Athlete"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameOutlet.delegate = self
        lastNameOutlet.delegate = self
        
        for x in 0...120{
            age.append(String(x))
        }
        for x in 0...700{
            weight.append(String(x))
        }
        
        genderSegmentedControl.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 20)!], for: UIControlState.normal)
        activitySegmentedControl.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 20)!], for: UIControlState.normal)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        firstNameOutlet.layer.cornerRadius = 5.0
        firstNameOutlet.clipsToBounds = true
        firstNameOutlet.layer.borderWidth = 1
        firstNameOutlet.layer.borderColor = UIColor.white.cgColor
        
        lastNameOutlet.layer.cornerRadius = 5.0
        lastNameOutlet.clipsToBounds = true
        lastNameOutlet.layer.borderWidth = 1
        lastNameOutlet.layer.borderColor = UIColor.white.cgColor
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.x<0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if clientPassed.firstName != ""{
            if clientPassed.gender == "Male"{
                genderSegmentedControl.selectedSegmentIndex =  0
            }else{
                genderSegmentedControl.selectedSegmentIndex =  1
            }
            
            firstNameOutlet.text = clientPassed.firstName
            lastNameOutlet.text = clientPassed.lastName
            for index in 0...age.count-1{
                if age[index] == clientPassed.age{
                    agePickerView.selectRow(index, inComponent: 0, animated: true)
                    break
                }
            }
            if clientPassed.activityLevel == "active"{
                activitySegmentedControl.selectedSegmentIndex = 2
            }else if clientPassed.activityLevel == "casual"{
                activitySegmentedControl.selectedSegmentIndex = 1
            }else{
                activitySegmentedControl.selectedSegmentIndex = 0
            }
            
            for index in 0...weight.count-1{
                if weight[index] == clientPassed.weight{
                    weightPickerView.selectRow(index, inComponent: 0, animated: true)
                }
            }
            for index in 0...feet.count-1{
                if feet[index] == clientPassed.feet{
                    heightPickerView.selectRow(index, inComponent: 0, animated: true)
                }
            }
            for index in 0...inches.count-1{
                if inches[index] == clientPassed.inches{
                    heightPickerView.selectRow(index, inComponent: 1, animated: true)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        edit = false
    }
    
    @IBAction func genderSelection(_ sender: UISegmentedControl) {
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            
        }else if genderSegmentedControl.selectedSegmentIndex == 1{
            
        }
    }
    
    func setClient(client:Client){
        clientPassed = client
        edit = true
    }
    func setEdit(ed:Bool){
        edit = ed
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if !firstNameOutlet.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
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
        }else if pickerView.tag == 1{
            return activityLevel.count
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
        }else if pickerView.tag == 1{
            return activityLevel[row]
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
        }else if pickerView.tag == 1{
            label.text = activityLevel[row]
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
        if firstNameOutlet.text != ""{
        if edit == false{
            myClient.clientKey = DBService.shared.createClientID()
        }else{
            myClient.clientKey = clientPassed.clientKey
        }
        
        if genderSegmentedControl.selectedSegmentIndex == 0{
            myClient.gender = "Male"
        }else if genderSegmentedControl.selectedSegmentIndex == 1{
            myClient.gender = "Female"
        }
        
        var activityLvl = ""
        if activitySegmentedControl.selectedSegmentIndex == 0{
            activityLvl = "inactive"
        }else if activitySegmentedControl.selectedSegmentIndex == 1{
            activityLvl = "casual"
        }else if activitySegmentedControl.selectedSegmentIndex == 2{
            activityLvl = "active"
        }
        
        let ageId:Int = agePickerView.selectedRow(inComponent: 0)
        let tempAge = self.age[ageId]
        
        let ftId:Int = heightPickerView.selectedRow(inComponent: 0)
        let tempFeet = feet[ftId]
        let inId:Int = heightPickerView.selectedRow(inComponent: 1)
        let tempInches = inches[inId]
        
        
        let lbsId:Int = weightPickerView.selectedRow(inComponent: 0)
        let tempWeight = weight[lbsId]
        
        myClient.weight = tempWeight
        myClient.feet = tempFeet
        myClient.inches = tempInches
        myClient.age = tempAge
        myClient.activityLevel = activityLvl
        myClient.firstName = (firstNameOutlet.text?.capitalized)!
        myClient.lastName = (lastNameOutlet.text?.capitalized)!
        
        var clientDictionary = [String:Any]()
        clientDictionary["firstName"] = myClient.firstName
        clientDictionary["lastName"] = myClient.lastName
        clientDictionary["age"] = myClient.age
        clientDictionary["activityLevel"] = myClient.activityLevel
        clientDictionary["feet"] = myClient.feet
        clientDictionary["inches"] = myClient.inches
        clientDictionary["weight"] = myClient.weight
        clientDictionary["gender"] = myClient.gender
        clientDictionary["clientKey"] = myClient.clientKey
        
        DBService.shared.updateNewClient(newClient: clientDictionary, completion: {
            let presenter = self.presentingViewController?.childViewControllers.last
            self.dismiss(animated: true, completion: {presenter?.viewWillAppear(true)})
        })
        }else{
            let alert = UIAlertController(title: "Error", message: "Please enter client's first name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
