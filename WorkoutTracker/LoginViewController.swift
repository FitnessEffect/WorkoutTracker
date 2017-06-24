//
//  LoginViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/14/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//


import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    
    let prefs = UserDefaults.standard
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedOutlet.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "DK Cool Crayon", size: 16)!], for: UIControlState.normal)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        ref = FIRDatabase.database().reference()
        
        register.isHidden = true
        
        if self.prefs.object(forKey: "switch") as? Bool == true{
            setAuthListener()
        }
        // Do any additional setup after loading the view.
    }
    
    func setAuthListener() {
        FIRAuth.auth()?.addStateDidChangeListener({auth, user in
            DBService.shared.setUser(completion: { user, message in
                if user == nil {
                    print(message!)
                    return
                }
                if let deviceTokenString = UserDefaults.standard.object(forKey: "deviceToken") as? String{
                    print(deviceTokenString)
                    //use email
                    let formattedEmail = Formatter.formateEmail(email: (user?.email)!)
                    self.ref.child("token").updateChildValues([formattedEmail:deviceTokenString])
                }
                
                //must be called once
                DBService.shared.initializeData()
                
                //called only for login
                self.performSegue(withIdentifier: "workoutSegue", sender: self)

            })
        })
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if !emailTF.frame.contains(sender.location(in: view)){
            if emailTF.isEditing{
                self.view.endEditing(true)
            }
        }
        if !passwordTF.frame.contains(sender.location(in: view)){
            if passwordTF.isEditing{
                self.view.endEditing(true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        //Register btn
        if segmentedOutlet.selectedSegmentIndex == 1{
            login.isHidden = true
            register.isHidden = false
        }
        if segmentedOutlet.selectedSegmentIndex == 0{
            register.isHidden = true
            login.isHidden = false
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        if (passwordTF.text?.characters.count) == 0{
            print("Invalid Password")
            let alert = UIAlertController(title: "Invalid Password", message: "Please enter a password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if (emailTF.text?.characters.count)! == 0{
            print("Invalid Eamil")
            let alert = UIAlertController(title: "Invalid Email", message: "Please enter an email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            prefs.set(emailTF.text, forKey: "email")
            prefs.set(passwordTF.text, forKey:"password")
            prefs.set(rememberMeSwitch.isOn, forKey:"switch")
            setAuthListener()
            FIRAuth.auth()?.signIn(withEmail: emailTF.text!, password: passwordTF.text!, completion:{(success) in
            })
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        if emailTF.text == "" {
            let alertController = UIAlertController(title: "Invalid Email", message: "Please enter an email", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else if passwordTF.text == "" {
            let alertController = UIAlertController(title: "Invalid Password", message: "Please enter a password", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
        }else{
            FIRAuth.auth()?.createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    let alertController = UIAlertController(title: "", message: "You are Registered!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
