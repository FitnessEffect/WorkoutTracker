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
    
    var delegate:createClientDelegate! = nil
    var myClient = Client()
    var ref:FIRDatabaseReference!
    var user:FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageOutlet.image = UIImage(named: "curl.png")
         self.view.backgroundColor = UIColor(red: 185.0/255.0, green: 230.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
    }
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var ageOutlet: UITextField!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func genderSelection(_ sender: UISegmentedControl) {
    
        if genderSegmentedControl.selectedSegmentIndex == 0 {
             imageOutlet.image = UIImage(named: "curl.png")
            self.view.backgroundColor = UIColor(red: 185.0/255.0, green: 230.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }else if genderSegmentedControl.selectedSegmentIndex == 1{
             imageOutlet.image = UIImage(named: "woman.png")
            self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 235.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    @IBAction func createClient(_ sender: UIButton) {
    
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
    
        //let fullName = myClient.firstName + " " + myClient.lastName
        
        let clientKey = self.ref.child("users").child(user.uid).child("Clients").childByAutoId().key
        self.ref.child("users").child(user.uid).child("Clients").child(clientKey).setValue(clientDictionary)
        //update only values that changed
        // self.ref.child("users").child(user.uid).child("Clients").child(clientKey).updateChildValues(myClient)
        
        //delegate.addClient(myClient)
        dismiss(animated: true, completion: nil)
    }
}
