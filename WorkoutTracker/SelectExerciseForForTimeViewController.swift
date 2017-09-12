//
//  SelectExerciseForForTimeViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/28/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class SelectExerciseForForTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBOutlet weak var repsWeightPicker: UIPickerView!
    
    let exerciseKey:String = "exerciseKey"
    var reps = [String]()
    var lbs = [String]()
    var exercises = [String]()
    var categoryPassed = ""
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Exercise"
        for i in 1...300{
            reps.append(String(i))
        }
        
        for i in 0...1500{
            lbs.append(String(i))
        }
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BodybuildingCategoryTableViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        
        spinner.frame = CGRect(x:(self.exercisePicker.frame.width/2)-65, y:(self.exercisePicker.frame.height/2)-25, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        spinner.alpha = 0
        exercisePicker.addSubview(spinner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.setCategory(category: "1 Rep Max")
        let internetCheck = Reachability.isInternetAvailable()
        if internetCheck == false{
            let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            spinner.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            DispatchQueue.global(qos: .userInteractive).async {
                DBService.shared.retrieveCrossfitCategoryExercises(completion: {
                    UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                    self.spinner.stopAnimating()
                    self.exercises = DBService.shared.exercisesForCrossfitCategory
                    self.exercisePicker.reloadAllComponents()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createCrossfitExerciseID") as! CreateCrossfitExerciseViewController
        popController.setCategory(category:categoryPassed)
        self.navigationController?.pushViewController(popController, animated: true)
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
                return lbs.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return exercises[row]
        }else{
            if component == 0 {
                return reps[row]
            }else{
                return lbs[row]
            }
        }
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        let myExercise = Exercise()
        let id:Int = exercisePicker.selectedRow(inComponent: 0)
        
        myExercise.name = categoryPassed
        myExercise.category = categoryPassed
        myExercise.type = "Crossfit"
        
        if exercises.count == 0{
            let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let idReps = repsWeightPicker.selectedRow(inComponent: 0)
            let idPounds = repsWeightPicker.selectedRow(inComponent: 1)
            myExercise.exerciseDescription = exercises[id] + " " + "(" + lbs[idPounds] + " lbs)" + " " + reps[idReps] + " rep(s)"
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "forTimeVC") as! ForTimeViewController
            DBService.shared.setSupersetExercise(exercise: myExercise)
            vc.setCategory(category: categoryPassed)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if pickerView.tag == 0 {
            label.text = exercises[row]
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
