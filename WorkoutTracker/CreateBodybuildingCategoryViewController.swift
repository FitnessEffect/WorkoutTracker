//
//  CreateBodybuildingCategoryViewController.swift
//
//
//  Created by Stefan Auvergne on 6/2/17.
//
//

import UIKit
import Firebase

class CreateBodybuildingCategoryViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var add: UIButton!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var typePassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryName.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        categoryName.layer.cornerRadius = 5.0
        categoryName.clipsToBounds = true
        categoryName.layer.borderWidth = 1
        categoryName.layer.borderColor = UIColor.white.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if !categoryName.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        myExercise.name = categoryName.text!
        var dictionary = [String:Any]()
        dictionary[categoryName.text!.capitalized] = true
        DBService.shared.createBodybuildingCategories(dictionary: dictionary)
        self.navigationController?.popViewController(animated: true)
    }
}
