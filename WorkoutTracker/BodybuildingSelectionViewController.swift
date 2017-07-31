//
//  BackViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class BodybuildingSelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var repsSetsOutlet: UIPickerView!
    @IBOutlet weak var repsLabelForTwoComponents: UILabel!
    @IBOutlet weak var setsLabelForTwoComponents: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var repsLabelForOneComponent: UILabel!
    @IBOutlet weak var lbsLabel: UILabel!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exercises = [String]()
    var categoryPassed = ""
    var reps = [String]()
    var sets = [String]()
    var lbs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 20)!], for: UIControlState.normal)

        
        repsLabelForOneComponent.isHidden = true
        lbsLabel.isHidden = true
        
        for i in 1...300{
            reps.append(String(i))
            sets.append(String(i))
        }
        
        for i in 0...1500{
            lbs.append(String(i))
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
        if DBService.shared.supersetExercises.count != 0{
            segmentedControl.selectedSegmentIndex = 1
        }
        
        DBService.shared.retrieveBodybuildingCategoryExercises(completion: {
            self.exercises = DBService.shared.exercisesForBodybuildingCategory
            self.pickerOutlet.reloadAllComponents()
        })
    }

    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0{
            repsLabelForOneComponent.isHidden = true
            lbsLabel.isHidden = true
            repsLabelForTwoComponents.isHidden = false
            setsLabelForTwoComponents.isHidden = false
            repsSetsOutlet.tag = 1
            repsSetsOutlet.reloadAllComponents()
        }else{
            repsSetsOutlet.tag = 2
            repsLabelForTwoComponents.isHidden = true
            setsLabelForTwoComponents.isHidden = true
            repsLabelForOneComponent.isHidden = false
            lbsLabel.isHidden = false
            repsSetsOutlet.reloadAllComponents()
        }
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
        }else if pickerView.tag == 1{
            if component == 0 {
                return reps.count
            }else{
                return sets.count
            }
        }else{
            if component == 0 {
                return reps.count
            }else{
                return lbs.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return exercises[row]
        }else if pickerView.tag == 1{
            if component == 0 {
                return reps[row]
            }else {
                return sets[row]
            }
        }else{
            if component == 0 {
                return reps[row]
            }else{
                return lbs[row]
            }
        }
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        
            myExercise.name = categoryPassed
            myExercise.category = categoryPassed
            myExercise.type = "Bodybuilding"
            
            if exercises.count == 0{
                let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                if segmentedControl.selectedSegmentIndex == 1{
                        let idReps = repsSetsOutlet.selectedRow(inComponent: 0)
                        let idPounds = repsSetsOutlet.selectedRow(inComponent: 1)
                    myExercise.exerciseDescription = exercises[id] + " " + "(" + lbs[idPounds] + " lbs)" + " " + reps[idReps] + " rep(s)"
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "supersetVC") as! SupersetViewController
                   DBService.shared.setSupersetExercise(exercise: myExercise)
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let idReps = repsSetsOutlet.selectedRow(inComponent: 0)
                    let idSets = repsSetsOutlet.selectedRow(inComponent: 1)
                    myExercise.exerciseDescription = exercises[id] + " " + reps[idReps] + " rep(s) " + sets[idSets] + " set(s)"
                    
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
                    
                     DBService.shared.clearSupersetExercises()
                
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if pickerView.tag == 0 {
            label.text = exercises[row]
        }else if pickerView.tag == 1{
            if component == 0{
                label.text = reps[row]
            }else{
                label.text = sets[row]
            }
        }else{
            if component == 0{
                label.text = reps[row]
            }else{
                label.text = lbs[row]
            }
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 24.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
