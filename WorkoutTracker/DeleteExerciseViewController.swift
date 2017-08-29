//
//  DeleteExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/27/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class DeleteExerciseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var exercisePickerView: UIPickerView!
    
    var types = [String]()
    var categories = [String]()
    var exercises = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 22)!], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveTypes {
            self.types = DBService.shared.types
            self.typePickerView.reloadAllComponents()
            self.setCategoriesForType()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!], for: .normal)
    }
    
    func setCategoriesForType(){
        self.categories.removeAll()
        let index = typePickerView.selectedRow(inComponent: 0)
        if types[index] == "Bodybuilding"{
            DBService.shared.retrieveBodybuildingCategories {
                self.categories = DBService.shared.bodybuildingCategories
                self.categoryPickerView.reloadAllComponents()
                DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
                DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
                DBService.shared.retrieveBodybuildingCategoryExercises {
                    self.exercises = DBService.shared.exercisesForBodybuildingCategory
                    self.exercisePickerView.reloadAllComponents()
                }
            }
        }else if types[index] == "Crossfit"{
            self.categories = ["1 Rep Max"]
            self.categoryPickerView.reloadAllComponents()
            DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
            DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
            DBService.shared.retrieveCrossfitCategoryExercises {
                self.exercises = DBService.shared.exercisesForCrossfitCategory
                self.exercisePickerView.reloadAllComponents()
            }
        }else if types[index] == "Endurance"{
            self.categoryPickerView.reloadAllComponents()
        }
        setExercisesForCategory()
    }
    
    func setExercisesForCategory(){
        self.exercises.removeAll()
        let index = categoryPickerView.selectedRow(inComponent: 0)
        if categories.count == 0{
            self.exercisePickerView.reloadAllComponents()
        }else if categories[index] == "1 Rep Max"{
            DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
            DBService.shared.retrieveCrossfitCategoryExercises {
                self.exercises = DBService.shared.exercisesForCrossfitCategory
                self.exercisePickerView.reloadAllComponents()
            }
        }else{
            DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
            DBService.shared.retrieveBodybuildingCategoryExercises {
                self.exercises = DBService.shared.exercisesForBodybuildingCategory
                self.exercisePickerView.reloadAllComponents()
            }
        }
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        if exercises.count != 0{
            let indexT = typePickerView.selectedRow(inComponent: 0)
            let indexC = categoryPickerView.selectedRow(inComponent: 0)
            let indexE = exercisePickerView.selectedRow(inComponent: 0)
            DBService.shared.deleteExerciseForCategoryForType(exercise: exercises[indexE], category: categories[indexC], type: types[indexT], completion: {
                self.setExercisesForCategory()
            })
        }else{
            let alert = UIAlertController(title: "Error", message: "No exercises selected", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return types.count
        }else if pickerView.tag == 1{
            return categories.count
        }else{
            return exercises.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return types[row]
        }else if pickerView.tag == 1{
            return categories[row]
        }else{
            return exercises[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 0{
            setCategoriesForType()
        }else{
            setExercisesForCategory()
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if pickerView.tag == 0{
            label.text = types[row]
        }else if pickerView.tag == 1{
            label.text = categories[row]
        }else{
            label.text = exercises[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "DJB Chalk It Up", size: 28.0)!,NSForegroundColorAttributeName:UIColor.white])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
}
