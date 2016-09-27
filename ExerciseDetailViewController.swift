//
//  ExerciseDetailViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/5/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// Exercise Detail View Controller displays the exercise description and
// allows the user to input a result.

import UIKit

protocol ExerciseResultDelegate{
    func passExercise(_ exercise:Exercise)
}

class ExerciseDetailViewController: UIViewController {
    
    var exercise:Exercise!
    var delegate:ExerciseResultDelegate! = nil
    
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var resultOutlet: UITextField!
    
    override func viewDidLoad() {
        title = exercise.name
        super.viewDidLoad()

        let desStr:String = exercise.exerciseDescription
        let stringParts = desStr.components(separatedBy: "|")
        
        resultOutlet.textColor = UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
        var newString:String = ""
        for part in stringParts{
            newString.append(part)
            newString.append("\n")
        }
        descriptionOutlet.text = newString
    }
    
    @IBAction func addResult(_ sender: UIButton) {
        exercise.result = resultOutlet.text!
        delegate.passExercise(exercise)
        _ = navigationController?.popViewController(animated: true)
    }
}
