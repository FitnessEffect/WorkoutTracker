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
    @IBOutlet weak var detailPicker: UIPickerView!
    
    var categories = [String]()
    var exerciseNames = [String]()
    var typePassed:String!
    var spinnerCategory = UIActivityIndicatorView()
    var spinnerExercise = UIActivityIndicatorView()
    var spinnerDetail = UIActivityIndicatorView()
    var details = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinnerCategory.frame = CGRect(x:(categoryPicker.frame.width/2)-60, y:(categoryPicker.frame.height/2)-25, width:50, height:50)
        spinnerCategory.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinnerCategory.color = UIColor.blue
        spinnerCategory.alpha = 0
        categoryPicker.addSubview(spinnerCategory)
        
        spinnerExercise.frame = CGRect(x:(exercisePicker.frame.width/2)-60, y:(exercisePicker.frame.height/2)-25, width:50, height:50)
        spinnerExercise.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinnerExercise.color = UIColor.blue
        spinnerExercise.alpha = 0
        exercisePicker.addSubview(spinnerExercise)
        
        spinnerDetail.frame = CGRect(x:(detailPicker.frame.width/2)-60, y:(detailPicker.frame.height/2)-25, width:50, height:50)
        spinnerDetail.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinnerDetail.color = UIColor.blue
        spinnerDetail.alpha = 0
        detailPicker.addSubview(spinnerDetail)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if DBService.shared.passedClient.clientKey != ""{
            spinnerCategory.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerCategory.alpha = 1})
            DBService.shared.retrieveClientProgressCategoriesForType(type:typePassed, completion: {
                UIView.animate(withDuration: 0.2, animations: {self.spinnerCategory.alpha = 0})
                self.spinnerCategory.stopAnimating()
                self.categories = DBService.shared.progressCategories
                
                self.categoryPicker.reloadAllComponents()
                self.setExerciseNamesForCategory(categoryPassed: self.categories[0])
            })
        }else{
            spinnerCategory.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerCategory.alpha = 1})
            DBService.shared.retrieveProgressCategoriesForType(type:typePassed, completion: {
                UIView.animate(withDuration: 0.2, animations: {self.spinnerCategory.alpha = 0})
                self.spinnerCategory.stopAnimating()
                self.categories = DBService.shared.progressCategories
                
                self.categoryPicker.reloadAllComponents()
                self.setExerciseNamesForCategory(categoryPassed: self.categories[0])
            })
        }
    }
    
    func setType(type:String){
        typePassed = type
    }
    
    func setExerciseNamesForCategory(categoryPassed:String){
        exerciseNames.removeAll()
        DBService.shared.setSelectedProgressCategory(categoryStr: categoryPassed)
        if DBService.shared.passedClient.clientKey != ""{
            spinnerExercise.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 1})
            if typePassed == "Endurance"{
                DBService.shared.retrieveClientProgressExercisesForCategory(type:self.typePassed, category:categoryPassed, completion:{
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 0})
                    self.spinnerExercise.stopAnimating()
                    self.exerciseNames = DBService.shared.progressExerciseNames
                    if self.exerciseNames.count != 0{
                        DBService.shared.setSelectedProgressExercise(exerciseStr: self.exerciseNames[0])
                        self.setDetailsForExerciseName(exerciseName: DBService.shared.selectedProgressExercise)
                    }
                    self.exercisePicker.reloadAllComponents()
                })
            }else{
                DBService.shared.retrieveClientProgressExercisesForCategory(type:self.typePassed, category:categoryPassed, completion:{
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 0})
                    self.spinnerExercise.stopAnimating()
                    self.exerciseNames = DBService.shared.progressExerciseNames
                    self.exercisePicker.reloadAllComponents()
                })
            }
        }else{
            spinnerExercise.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 1})
            if typePassed == "Endurance"{
                DBService.shared.retrieveProgressExercisesForCategory(type:self.typePassed, category:categoryPassed, completion:{
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 0})
                    self.spinnerExercise.stopAnimating()
                    self.exerciseNames = DBService.shared.progressExerciseNames
                    if self.exerciseNames.count != 0{
                        DBService.shared.setSelectedProgressExercise(exerciseStr: self.exerciseNames[0])
                        self.setDetailsForExerciseName(exerciseName: DBService.shared.selectedProgressExercise)
                    }
                    self.exercisePicker.reloadAllComponents()
                })
            }else{
                DBService.shared.retrieveProgressExercisesForCategory(type:self.typePassed, category:categoryPassed, completion:{
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 0})
                    self.spinnerExercise.stopAnimating()
                    self.exerciseNames = DBService.shared.progressExerciseNames
                    self.exercisePicker.reloadAllComponents()
                })
            }
        }
    }
    
    func setDetailsForExerciseName(exerciseName:String){
        self.details.removeAll()
        UIView.animate(withDuration: 0.2, animations: {self.spinnerDetail.alpha = 1})
        self.spinnerDetail.startAnimating()
        if DBService.shared.passedClient.clientKey != ""{
            if DBService.shared.selectedProgressCategory == "Hero Wods" || DBService.shared.selectedProgressCategory == "1 Rep Max" || typePassed == "Bodybuilding"{
                UIView.animate(withDuration: 0.2, animations: {self.spinnerDetail.alpha = 0})
                self.spinnerDetail.stopAnimating()
            }else{
                DBService.shared.retrieveClientProgressDetailExercisesForExerciseName(type: self.typePassed, exerciseName:exerciseName, completion: {
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerDetail.alpha = 0})
                    self.spinnerDetail.stopAnimating()
                    self.details = DBService.shared.progressDetailExercises
                    self.detailPicker.reloadAllComponents()
                })
            }
        }else{
            if DBService.shared.selectedProgressCategory == "Hero Wods" || DBService.shared.selectedProgressCategory == "1 Rep Max" || typePassed == "Bodybuilding"{
                UIView.animate(withDuration: 0.2, animations: {self.spinnerDetail.alpha = 0})
                self.spinnerDetail.stopAnimating()
            }else{
                DBService.shared.retrieveProgressDetailExercisesForExerciseName(type: self.typePassed, exerciseName:exerciseName, completion: {
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerDetail.alpha = 0})
                    self.spinnerDetail.stopAnimating()
                    self.details = DBService.shared.progressDetailExercises
                    self.detailPicker.reloadAllComponents()
                })
            }
        }
    }
    
    func setProgressResultsFromDetail(detailPassed:String){
        if DBService.shared.passedClient.clientKey != ""{
            DBService.shared.retrieveClientProgressResultsForExerciseDetail(type: self.typePassed, category: DBService.shared.selectedProgressCategory, exerciseName: DBService.shared.selectedProgressExercise, detail: detailPassed, completion: {
                //self.detailPicker.reloadAllComponents()
            })
        }else{
            DBService.shared.retrieveProgressResultsForExerciseDetail(type: self.typePassed, category: DBService.shared.selectedProgressCategory, exerciseName: DBService.shared.selectedProgressExercise, detail: detailPassed, completion: {
                //self.detailPicker.reloadAllComponents()
            })
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return categories.count
        }else if pickerView.tag == 1{
            return exerciseNames.count
        }else{
            return details.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return categories[row]
        }else if pickerView.tag == 1{
            return exerciseNames[row]
        }else{
            return details[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 0{
            let category = categories[categoryPicker.selectedRow(inComponent: 0)]
            setExerciseNamesForCategory(categoryPassed: categories[categoryPicker.selectedRow(inComponent: 0)])
            DBService.shared.setSelectedProgressCategory(categoryStr: category)
        }else if pickerView.tag == 1{
            let exName = exerciseNames[exercisePicker.selectedRow(inComponent: 0)]
            setDetailsForExerciseName(exerciseName: exerciseNames[exercisePicker.selectedRow(inComponent: 0)])
            DBService.shared.setSelectedProgressExercise(exerciseStr: exName)
        }else{
            DBService.shared.setSelectedProgressDetail(detail: details[detailPicker.selectedRow(inComponent: 0)])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if pickerView.tag == 0{
            label.text = categories[row]
        }else if pickerView.tag == 1{
            label.text = exerciseNames[row]
        }else{
            label.text = details[row]
        }
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    @IBAction func selectBtn(_ sender: UIButton) {
        let presenter = self.presentingViewController?.childViewControllers.last as! ProgressChartViewController
        self.dismiss(animated: true, completion: {presenter.viewWillAppear(true)
            presenter.setChartTitle(title:self.exerciseNames[self.exercisePicker.selectedRow(inComponent: 0)])
        })
    }
}
