//
//  LoginViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/14/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    @IBOutlet weak var termsOfUselabel: UITextView!
    @IBOutlet weak var termsOfUseBtn: UIButton!
    @IBOutlet weak var rememberMeLabel: UILabel!
    
    let prefs = UserDefaults.standard
    var ref:FIRDatabaseReference!
    var authHandle:UInt?
    var workoutVC:InputExerciseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        emailTF.delegate = self
        
        segmentedOutlet.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 20)!], for: UIControlState.normal)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        ref = FIRDatabase.database().reference()
        
        termsOfUselabel.alpha = 0
        termsOfUseBtn.alpha = 0
        register.alpha = 0
        UserDefaults.standard.set(false, forKey: "newUser")
        
        if self.prefs.object(forKey: "switch") as? Bool == true{
            rememberMeSwitch.setOn(true, animated: true)
            setAuthListener()
        }
        else {
            rememberMeSwitch.setOn(false, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAuthListener() {
        if authHandle != nil{
            return
        }
        authHandle = FIRAuth.auth()?.addStateDidChangeListener({auth, user in
            DBService.shared.setUser(completion: { u, message in
                if u == nil {
                    print(message!)
                    return
                } else {
                    DBService.shared.initUser()
                    if let deviceTokenString = UserDefaults.standard.object(forKey: "deviceToken") as? String{
                        print(deviceTokenString)
                        //use email
                        let formattedEmail = Formatter.formateEmail(email: (u?.email)!)
                        self.ref.child("token").updateChildValues([formattedEmail:deviceTokenString])
                        self.ref.child("emails").updateChildValues([formattedEmail:user!.uid])
                    }
                    //called only for login
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc =   storyboard.instantiateViewController(withIdentifier: "inputNavID") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                }
            })
        }) as? UInt
    }
    
    @IBAction func termOfUse(_ sender: UIButton) {
        if let url = NSURL(string: "https://github.com/FitnessEffect/WorkoutTracker/blob/master/Terms%20of%20Use"){
            UIApplication.shared.openURL(url as URL)
        }
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
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
        self.prefs.set(sender.isOn, forKey: "switch")
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        //login btn
        if segmentedOutlet.selectedSegmentIndex == 0{
                self.register.alpha = 0
                self.termsOfUselabel.alpha = 0
              self.termsOfUseBtn.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.login.alpha = 1
                self.rememberMeSwitch.alpha = 1
                self.rememberMeLabel.alpha = 1
            })
        }
        //Register btn
        if segmentedOutlet.selectedSegmentIndex == 1{
           
                self.login.alpha = 0
                self.rememberMeSwitch.alpha = 0
                self.rememberMeLabel.alpha = 0
             UIView.animate(withDuration: 0.5, animations: {
                self.register.alpha = 1
                self.termsOfUselabel.alpha = 1
                self.termsOfUseBtn.alpha = 1
            
            })
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
            FIRAuth.auth()?.signIn(withEmail: emailTF.text!, password: passwordTF.text!, completion:{(success) in
                if success.0 == nil{
                    let alertController = UIAlertController(title: "Invalid Credentials", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    self.prefs.set(self.emailTF.text, forKey: "email")
                    self.prefs.set(self.passwordTF.text, forKey:"password")
                    self.prefs.set(self.rememberMeSwitch.isOn, forKey:"switch")
                    self.setAuthListener()
                }
                
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
            present(alertController, animated: true, completion: nil)
        }else{
            FIRAuth.auth()?.createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (user, error) in
                if error == nil {
                    
                    print("You have successfully signed up")
                    //check if user was just created
                    UserDefaults.standard.set(true, forKey: "newUser")
                    
                    if UIDevice.current.modelName == "Simulator" {
                        print("Simulator")
                    }
                    else {
                        print("Real Device")
                        if UIDevice.current.modelName == "iPhone 6s"{
                            FIRAuth.auth()?.signIn(withEmail: self.emailTF.text!, password: self.passwordTF.text!, completion:{(success) in
                                if success.0 == nil{
                                    let alertController = UIAlertController(title: "Invalid Credentials", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            })
                        }
                    }
                    
                    let alertController = UIAlertController(title: "", message: "You are Registered!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "i386", "x86_64":                          return "Simulator"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

