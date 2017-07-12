//
//  CreateBodybuildingExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/2/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class CreateBodybuildingExerciseViewController: UIViewController {

    @IBOutlet weak var exName: UITextField!
    @IBOutlet weak var add: UIButton!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var categoryPassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        myExercise.name = exName.text!
        var dictionary = [String:Any]()
        dictionary[exName.text!.capitalized] = true
        DBService.shared.createBodybuildingExercise(dictionary: dictionary)
        self.navigationController?.popViewController(animated: true)
    }
    
}
