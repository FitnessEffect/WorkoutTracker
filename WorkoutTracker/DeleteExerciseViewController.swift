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
    var spinnerType = UIActivityIndicatorView()
    var spinnerCategory = UIActivityIndicatorView()
    var spinnerExercise = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerType.frame = CGRect(x:(self.typePickerView.frame.width/2)-25, y:(self.typePickerView.frame.height/2)-25, width:50, height:50)
        spinnerType.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinnerType.color = UIColor.white
        spinnerType.alpha = 0
        typePickerView.addSubview(spinnerType)
        
        spinnerCategory.frame = CGRect(x:(self.categoryPickerView.frame.width/2)-25, y:(self.categoryPickerView.frame.height/2)-25, width:50, height:50)
        spinnerCategory.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinnerCategory.color = UIColor.white
        spinnerCategory.alpha = 0
        categoryPickerView.addSubview(spinnerCategory)
        
        spinnerExercise.frame = CGRect(x:(self.exercisePickerView.frame.width/2)-25, y:(self.exercisePickerView.frame.height/2)-25, width:50, height:50)
        spinnerExercise.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinnerExercise.color = UIColor.white
        spinnerExercise.alpha = 0
        exercisePickerView.addSubview(spinnerExercise)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let internetCheck = Reachability.isInternetAvailable()
        if internetCheck == false{
            let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            spinnerType.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerType.alpha = 1})
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveTypes {
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerType.alpha = 0})
                    self.spinnerType.stopAnimating()
                    self.types = DBService.shared.types
                    self.typePickerView.reloadAllComponents()
                    self.setCategoriesForType()
                }
            }
        }
    }

    func setCategoriesForType(){
        self.categories.removeAll()
        let index = typePickerView.selectedRow(inComponent: 0)
        if types[index] == "Bodybuilding"{
            spinnerCategory.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerCategory.alpha = 1})
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveBodybuildingCategories {
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerCategory.alpha = 0})
                    self.spinnerCategory.stopAnimating()
                    self.categories = DBService.shared.bodybuildingCategories
                    self.categoryPickerView.reloadAllComponents()
                    DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
                    DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
                    DBService.shared.retrieveBodybuildingCategoryExercises {
                        self.exercises = DBService.shared.exercisesForBodybuildingCategory
                        self.exercisePickerView.reloadAllComponents()
                    }
                }
            }
        }else if types[index] == "Crossfit"{
            self.categories = ["1 Rep Max"]
            self.categoryPickerView.reloadAllComponents()
            DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
            DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
            spinnerCategory.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerCategory.alpha = 1})
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveCrossfitCategoryExercises {
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerCategory.alpha = 0})
                    self.spinnerCategory.stopAnimating()
                    
                    self.exercises = DBService.shared.exercisesForCrossfitCategory
                    self.exercisePickerView.reloadAllComponents()
                }
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
            spinnerExercise.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 1})
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveCrossfitCategoryExercises {
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 0})
                    self.spinnerExercise.stopAnimating()
                    self.exercises = DBService.shared.exercisesForCrossfitCategory
                    self.exercisePickerView.reloadAllComponents()
                }
            }
        }else{
            DBService.shared.setCategory(category: self.categories[self.categoryPickerView.selectedRow(inComponent: 0)])
            spinnerExercise.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 1})
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveBodybuildingCategoryExercises {
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 0})
                    self.spinnerExercise.stopAnimating()
                    self.exercises = DBService.shared.exercisesForBodybuildingCategory
                    self.exercisePickerView.reloadAllComponents()
                }
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
            //block user selection while pickerView content is loading
            categoryPickerView.isUserInteractionEnabled = false
            exercisePickerView.isUserInteractionEnabled = false
            setCategoriesForType()
            categoryPickerView.isUserInteractionEnabled = true
            exercisePickerView.isUserInteractionEnabled = true
        }else if pickerView.tag == 1{
            exercisePickerView.isUserInteractionEnabled = false
            setExercisesForCategory()
            exercisePickerView.isUserInteractionEnabled = true
        }else{
            //do nothing
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
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "DJB Chalk It Up", size: 28.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
}
