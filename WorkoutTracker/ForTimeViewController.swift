//
//  ForTimeViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ForTimeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var exercises = [String]()
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var categoryPassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryPassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
        
        if categoryPassed == "1 Rep Max"{
            let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BodybuildingCategoryTableViewController.rightSideBarButtonItemTapped(_:)))
            rightBarButton.image = UIImage(named:"addIcon")
            self.navigationItem.rightBarButtonItem = rightBarButton
            rightBarButton.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveCrossfitCategoryExercises(completion: {
            self.exercises = DBService.shared.exercisesForCrossfitCategory
            self.pickerOutlet.reloadAllComponents()
        })
        pickerOutlet.isUserInteractionEnabled = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.x<0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.y > 50{
            scrollView.contentOffset.y = 50
        }
        if scrollView.contentOffset.y < 0{
            scrollView.contentOffset.y = 0
        }
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row]
    }
    
    @IBAction func addWod(_ sender: UIButton) {
        if categoryPassed == "For Time"{
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            myExercise.name = exercises[id]
            myExercise.category = "For Time"
            myExercise.type = "Crossfit"
            if myExercise.name == "Fran"{
                DBService.shared.retrieveWod(wodName: "Fran", completion: {
                (str) in
                    self.myExercise.exerciseDescription = str
                   NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [self.exerciseKey:self.myExercise])
                })
                print(myExercise.exerciseDescription)
            }else if myExercise.name == "Grace"{
                DBService.shared.retrieveWod(wodName: "Grace", completion: {
                    (str) in
                    self.myExercise.exerciseDescription = str
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [self.exerciseKey:self.myExercise])
                })
            }else if myExercise.name == "Murph"{
                DBService.shared.retrieveWod(wodName: "Murph", completion: {
                    (str) in
                    self.myExercise.exerciseDescription = str
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [self.exerciseKey:self.myExercise])
                })
            }
        }else{
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            myExercise.name = exercises[id]
            myExercise.category = "1 Rep Max"
            myExercise.exerciseDescription = "1 Rep Max"
            myExercise.type = "Crossfit"
            NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = exercises[row]
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 28.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
}
