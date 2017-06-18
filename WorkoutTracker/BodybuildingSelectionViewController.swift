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
    
    
    let reps = ["Reps", "1 rep", "5 reps", "6 reps", "7 reps", "8 reps", "9 reps", "10 reps", "11 reps", "12 reps", "13 reps", "14 reps", "15 reps", "16 reps", "17 reps", "18 reps", "19 reps", "20 reps", "21 reps", "25 reps", "30 reps", "100 reps"]
    
    let sets = ["Sets", "1 set", "2 sets", "3 sets", "4 sets", "5 sets","6 sets", "7 sets", "8 sets", "9 sets", "10 sets", "11 sets", "12 sets", "13 sets", "14 sets", "15 sets", "20 sets"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryPassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day Demo", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]

        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BodybuildingCategoryTableViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        
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
        myExercise.exerciseDescription = exercises[id] + " " + reps[idReps] + " " + sets[idSets]
        myExercise.category = categoryPassed
        myExercise.type = "Bodybuilding"
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if pickerView.tag == 0 {
            label.text = exercises[row]
        }else if component == 0{
            label.text = reps[row]
        }else{
            label.text = sets[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day Demo", size: 25.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
}
