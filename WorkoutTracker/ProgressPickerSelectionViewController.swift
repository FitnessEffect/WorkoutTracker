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
            DBService.shared.retrieveClientProgressExercisesForCategory(type:self.typePassed, category:categoryPassed, completion:{
                UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 0})
                self.spinnerExercise.stopAnimating()
                self.exerciseNames = DBService.shared.progressExerciseNames
                self.exercisePicker.reloadAllComponents()
            })
        }else{
            spinnerExercise.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 1})
           
            if typePassed == "Endurance"{
                
                DBService.shared.retrieveProgressExercisesForCategory(type:self.typePassed, category:categoryPassed, completion:{
                    UIView.animate(withDuration: 0.2, animations: {self.spinnerExercise.alpha = 0})
                    self.spinnerExercise.stopAnimating()
                    self.exerciseNames = DBService.shared.progressExerciseNames
                    if self.exerciseNames.count != 0{
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
        DBService.shared.retrieveProgressDetailExercisesForExerciseName(type: self.typePassed, exerciseName:exerciseName, completion: {
            self.details = DBService.shared.progressDetailExercises
            DBService.shared.retrieveProgressResultsForExerciseDetail(type: self.typePassed, category: DBService.shared.selectedProgressCategory, exerciseName: DBService.shared.selectedProgressExercise, detail: DBService.shared.selectedProgressDetail, completion: {
                
                self.detailPicker.reloadAllComponents()
            })
        })
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
            setExerciseNamesForCategory(categoryPassed: categories[categoryPicker.selectedRow(inComponent: 0)])
        }else{
            setDetailsForExerciseName(exerciseName: exerciseNames[exercisePicker.selectedRow(inComponent: 0)])
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
    DBService.shared.setSelectedProgressCategory(categoryStr:categories[categoryPicker.selectedRow(inComponent: 0)])
        DBService.shared.setSelectedProgressExercise(exerciseStr:exerciseNames[exercisePicker.selectedRow(inComponent: 0)])
        
            let presenter = self.presentingViewController?.childViewControllers.last as! ProgressChartViewController
            self.dismiss(animated: true, completion: {presenter.viewWillAppear(true)
                presenter.setChartTitle(title:self.exerciseNames[self.exercisePicker.selectedRow(inComponent: 0)])
            })
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
