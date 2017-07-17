//
//  CreateCrossfitExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/5/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class CreateCrossfitExerciseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var exName: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var user:FIRUser!
    var ref:FIRDatabaseReference!
    var categoryPassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exName.delegate = self
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        exName.layer.cornerRadius = 5.0
        exName.clipsToBounds = true
        exName.layer.borderWidth = 1
        exName.layer.borderColor = UIColor.white.cgColor
        
        registerForKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.x<0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.y > 70{
            scrollView.contentOffset.y = 70
        }
        if scrollView.contentOffset.y < 0{
            scrollView.contentOffset.y = 0
        }
        
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if !exName.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        myExercise.name = exName.text!
        var dictionary = [String:Any]()
        dictionary[exName.text!.capitalized] = true
        DBService.shared.createCrossfitExercise(dictionary: dictionary)
        self.navigationController?.popViewController(animated: true)
    }
    
    func keyboardWasShown(notification: NSNotification){
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
