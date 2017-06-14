//
//  NewClientViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  Creates a new Client and returns it to the ClientViewController.

import UIKit
import Firebase

protocol createClientDelegate{
    func addClient(_ client:Client)
}

class NewClientViewController: UIViewController {
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var ageOutlet: UITextField!
    
    var delegate:createClientDelegate! = nil
    var myClient = Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    

    @IBAction func genderSelection(_ sender: UISegmentedControl) {
    
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            
            
        }else if genderSegmentedControl.selectedSegmentIndex == 1{
            
        }
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if !firstNameOutlet.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    @IBAction func createClient(_ sender: UIButton) {
        myClient.clientKey = DBService.shared.createClientID()
        
        if genderSegmentedControl.selectedSegmentIndex == 0{
            myClient.gender = "Male"
        }else if genderSegmentedControl.selectedSegmentIndex == 1{
            myClient.gender = "Female"
        }
        myClient.firstName = firstNameOutlet.text!
        myClient.lastName = lastNameOutlet.text!
        myClient.age = ageOutlet.text!
        
        var clientDictionary = [String:Any]()
        clientDictionary["firstName"] = myClient.firstName
        clientDictionary["lastName"] = myClient.lastName
        clientDictionary["age"] = myClient.age
        clientDictionary["gender"] = myClient.gender
        clientDictionary["clientKey"] = myClient.clientKey
        
        DBService.shared.createNewClient(newClient: clientDictionary, completion: {
        let presenter = self.presentingViewController?.childViewControllers.last as! ClientViewController
        
        self.dismiss(animated: true, completion: {presenter.viewWillAppear(true)})

        })
        
           
    }
}
