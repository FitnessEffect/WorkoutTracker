//
//  NewClientViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  Creates a new Client and returns it to the ClientViewController.

import UIKit

protocol createClientDelegate{
    func addClient(client:Client)
}

class NewClientViewController: UIViewController {
    
    var delegate:createClientDelegate! = nil
    var myClient = Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var ageOutlet: UITextField!
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func createClient(sender: UIButton) {
    
        let fn = firstNameOutlet.text
        let ln = lastNameOutlet.text
        let a = ageOutlet.text
        
        myClient.firstName = fn!
        myClient.lastName = ln!
        myClient.age = a!
       
        delegate.addClient(myClient)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
