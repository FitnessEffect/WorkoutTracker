//
//  SupersetViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/27/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class SupersetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var setsPicker: UIPickerView!
    
    let exerciseKey:String = "exerciseKey"
    var exercises = [Exercise]()
    var sets = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Superset"

      self.navigationItem.setHidesBackButton(true, animated:true)
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SupersetViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        
        for i in 1...300{
            sets.append(String(i))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exercises = DBService.shared.supersetExercises
        tableView.reloadData()
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){
        // get a reference to the view controller for the popover
        for vc in (self.navigationController?.viewControllers)!{
            if vc is BodybuildingCategoryTableViewController{
               self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "supersetCell")! as! SupersetTableViewCell
        cell.descriptionTextView.text = self.exercises[indexPath.row].exerciseDescription
        cell.numLabel.text = String(indexPath.row + 1)
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this exercise?", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let x = indexPath.row
                self.exercises.remove(at: x)
                DBService.shared.setSupersetExercises(exercises: self.exercises)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion:nil)
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return sets[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = sets[row]
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 21.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }

    @IBAction func selectBtn(_ sender: UIButton) {
        let myExercise = Exercise()
        let idSets:Int = setsPicker.selectedRow(inComponent: 0)
        
        myExercise.name = "Superset"
        myExercise.category = "Superset"
        myExercise.type = "Bodybuilding"
        for exercise in exercises{
            if myExercise.exerciseDescription == ""{
                myExercise.exerciseDescription = exercise.exerciseDescription
                
            }else{
                myExercise.exerciseDescription = myExercise.exerciseDescription + " | " + exercise.exerciseDescription
            }
        }
        myExercise.exerciseDescription = myExercise.exerciseDescription + " | " + sets[idSets] + " set(s)"
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        DBService.shared.clearSupersetExercises()
        
        self.dismiss(animated: true, completion: nil)
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
