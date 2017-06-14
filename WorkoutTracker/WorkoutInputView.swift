//
//  WorkoutInputView.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/7/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

protocol WorkoutInputViewDelegate {
    func handleTextEntered(input: String)
}

class WorkoutInputView: UIView, UITextViewDelegate {
    // bunch of ui object outlets (they go here instead of the VC)

    @IBOutlet weak var emailTxtView: UITextView!
    // let view = WorkoutInputView()
    // view.delegate = self
    var delegate: WorkoutInputViewDelegate?
    var name: String = ""
    var date: Date = Date()
    // let tf = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        emailTxtView.delegate = self
    }
    
    func setDelegates() {
        emailTxtView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func ChallengePressed(_ sender: UIButton) {
        if let del = self.delegate {
            del.handleTextEntered(input: "hi")
        }
    }
    func updateUI() {
        // populate interface, show views, etc
    }
    
    func someTextFieldMethod() {
        // tf.text = ""
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.handleTextEntered(input: "Hi")
    }
    
    func hideView(view: UIView) {
        // hide any view
    }
    
    func finishCreation() {
//        if let del = delegate {
//            del.handleCreate(workoutName: name)
//        }
    }
    
//    func finishCreation() {
//        if let del = delegate {
//            del.handleCreate(workoutName: name, completion: {
                    // fire off some alert
//              })
//        }
//    }
    
//    func saveToDB() {
//        if let del = delegate {
//            del.saveToDB()
//        }
//    }
    
}
