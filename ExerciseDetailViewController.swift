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
    func passExercise(exercise:Exercise)
}

class ExerciseDetailViewController: UIViewController {
    
    var exercise:Exercise!
    var delegate:ExerciseResultDelegate! = nil
    
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var resultOutlet: UITextField!
    
    override func viewDidLoad() {
        title = exercise.name
        super.viewDidLoad()

        descriptionOutlet.text = exercise.exerciseDescription
        resultOutlet.text = exercise.result
    }
    
    @IBAction func addResult(sender: UIButton) {
        exercise.result = resultOutlet.text!
        delegate.passExercise(exercise)
        navigationController?.popViewControllerAnimated(true)
    }
}
