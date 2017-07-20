//
//  BackViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// Displays a list of Back exercises

import UIKit
import Firebase

class BodybuildingSelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var repsSetsOutlet: UIPickerView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exercises = [String]()
    var categoryPassed = ""
    var reps = [String]()
    var sets = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...300{
            reps.append(String(i))
            sets.append(String(i))
        }
        
        title = categoryPassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BodybuildingCategoryTableViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveBodybuildingCategoryExercises(completion: {
            self.exercises = DBService.shared.exercisesForBodybuildingCategory
            self.pickerOutlet.reloadAllComponents()
        })
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createExerciseID") as! CreateBodybuildingExerciseViewController
        popController.setCategory(category:categoryPassed)
        self.navigationController?.pushViewController(popController, animated: true)
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0{
            return 1
        }else{
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return exercises.count
        }else{
            if component == 0 {
                return reps.count
            }else{
                return sets.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return exercises[row]
        }else{
            if component == 0 {
                return reps[row]
            }else {
                return sets[row]
            }
        }
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        let idReps = repsSetsOutlet.selectedRow(inComponent: 0)
        let idSets = repsSetsOutlet.selectedRow(inComponent: 1)
        
        myExercise.name = categoryPassed
        myExercise.category = categoryPassed
        myExercise.type = "Bodybuilding"
        
        if exercises.count == 0{
            let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            myExercise.exerciseDescription = exercises[id] + " " + reps[idReps] + " rep(s) " + sets[idSets] + " set(s)"
            NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
            dismiss(animated: true, completion: nil)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if pickerView.tag == 0 {
            label.text = exercises[row]
            let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
            label.attributedText = myTitle
            label.textAlignment = NSTextAlignment.center
        }else if component == 0{
            label.text = reps[row]
            let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
            label.attributedText = myTitle
            label.textAlignment = NSTextAlignment.center
        }else{
            label.text = sets[row]
            let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
            label.attributedText = myTitle
            label.textAlignment = NSTextAlignment.center
        }
        return label
    }
}
