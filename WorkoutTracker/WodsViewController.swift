//
//  WodsViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class WodsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    var wods = [String]()
    var oneRM = [String]()
        
        //["Back Squat", "Front Squat", "Overhead Squat", "Snatch", "Clean & Jerk", "Clean", "Deadlift", "Bench Press"]
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var categoryPassed:String!
    var user:FIRUser!
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if categoryPassed == "1 Rep Max"{
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BodybuildingCategoryTableViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            let userID = FIRAuth.auth()?.currentUser?.uid
            ref.child("users").child(userID!).child("Types").child("Crossfit").child(categoryPassed).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                if value != nil{
                    let keyArray = value?.allKeys as! [String]
                    if self.categoryPassed == "1 Rep Max"{
                       self.oneRM = keyArray
                    }else{
                        self.wods = keyArray
                    }
                    
                    self.pickerOutlet.reloadAllComponents()
                }
            }) { (error) in
                print(error.localizedDescription)
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
        if categoryPassed == "Wods"{
            return wods.count
        }else{
            return oneRM.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if categoryPassed == "Wods"{
            return wods[row]
        }else{
            return oneRM[row]
        }
    }

    @IBAction func addWod(_ sender: UIButton) {
        
        if categoryPassed == "Wods"{
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            myExercise.name = wods[id]
            
            if myExercise.name == "Fran"{
                myExercise.exerciseDescription = ("21-15-9 reps for time | thrusters (95lbs) | pull-ups")
            }else if myExercise.name == "Grace"{
                myExercise.exerciseDescription = ("30 reps for time | 135lbs clean and jerk")
            }else if myExercise.name == "Murph"{
                myExercise.exerciseDescription = ("1 mile run | 100 pull-ups | 200 push-ups | 300 air squats | 1 mile run")
            }
        }else{
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            myExercise.name = ("1 Rep Max")
            myExercise.exerciseDescription = (oneRM[id])
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        if categoryPassed == "Wods"{
            label.text = wods[row]
        }else{
            label.text = oneRM[row]
        }
        
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day Demo", size: 28.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
}
