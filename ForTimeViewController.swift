//
//  ForTimeViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/17/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class ForTimeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var exercises = [Exercise]()
    var categoryPassed:String!
    var rounds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 1...99{
            rounds.append(String(x))
        }
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SupersetViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        title = categoryPassed
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Have a Great Day", size: 22)!,NSAttributedStringKey.foregroundColor: UIColor.darkText]
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exercises = DBService.shared.supersetExercises
        tableView.reloadData()
    }
    
    @objc func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add(_ sender: UIButton) {
        if exercises.count == 0{
            let alert = UIAlertController(title: "Error", message: "Please create an exercise", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let myExercise = Exercise()
            let idRounds:Int = pickerOutlet.selectedRow(inComponent: 0)
            
            myExercise.name = "For Time"
            myExercise.category = "For Time"
            myExercise.type = "Crossfit"
            
            for exercise in exercises{
                if myExercise.exerciseDescription == ""{
                    myExercise.exerciseDescription = exercise.exerciseDescription
                    
                }else{
                    myExercise.exerciseDescription = myExercise.exerciseDescription + " | " + exercise.exerciseDescription
                }
            }
            myExercise.exerciseDescription = myExercise.exerciseDescription + " | " + rounds[idRounds] + " set(s)"
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
            DBService.shared.clearSupersetExercises()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rounds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rounds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = rounds[row]
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "Have a Great Day", size: 24.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "supersetCell")! as! SupersetCustomCell
        cell.descriptionTextField.text = self.exercises[indexPath.row].exerciseDescription
        cell.numLabel.text = String(indexPath.row + 1)
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deleteAlert = UIAlertController(title: "Delete Exercise?", message: "", preferredStyle: UIAlertControllerStyle.alert)
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
}
