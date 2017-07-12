//
//  CreateCrossfitExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/5/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class CreateCrossfitExerciseViewController: UIViewController {
    
    @IBOutlet weak var exName: UITextField!
    @IBOutlet weak var add: UIButton!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var user:FIRUser!
    var ref:FIRDatabaseReference!
    var categoryPassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
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
}
