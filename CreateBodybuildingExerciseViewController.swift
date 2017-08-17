//
//  CreateBodybuildingExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/2/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class CreateBodybuildingExerciseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var exName: UITextField!
    @IBOutlet weak var add: UIButton!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var categoryPassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exName.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        exName.layer.cornerRadius = 5.0
        exName.clipsToBounds = true
        exName.layer.borderWidth = 1
        exName.layer.borderColor = UIColor.white.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if !exName.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        if exName.text == ""{
            let alert = UIAlertController(title: "Error", message: "Please enter an exercise name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
        myExercise.name = exName.text!
        var dictionary = [String:Any]()
        dictionary[exName.text!.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)] = true
        DBService.shared.createBodybuildingExercise(dictionary: dictionary)
        self.navigationController?.popViewController(animated: true)
        }
    }
}
