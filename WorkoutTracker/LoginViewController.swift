//
//  LoginViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/14/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTF: TextFieldAnimations!
    @IBOutlet weak var passwordTF: TextFieldAnimations!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var rememberMeLabel: UILabel!
    
    let prefs = UserDefaults.standard
    var ref:FIRDatabaseReference!
    var authHandle:UInt?
    var workoutVC:InputExerciseViewController?
    var loginView = UIView()
    var registerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        emailTF.delegate = self
        ref = FIRDatabase.database().reference()
        UserDefaults.standard.set(false, forKey: "newUser")
        
        if self.prefs.object(forKey: "switch") as? Bool == true{
            rememberMeSwitch.setOn(true, animated: true)
            setAuthListener()
        }
        else {
            rememberMeSwitch.setOn(false, animated: true)
        }
        
        let tap = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector (self.swipe(_:)))
        
        registerView = RegisterView.instanceFromNib() as! RegisterView
        (registerView as! RegisterView).emailTxtField.delegate = self
        (registerView as! RegisterView).passwordTxtField.delegate = self
        (registerView as! RegisterView).frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        view.addSubview(registerView)
        
        registerView.addGestureRecognizer(tap)
        registerView.addGestureRecognizer(swipe)
        loginView = self.view
        loginView.addGestureRecognizer(swipe)
        loginView.addGestureRecognizer(tap)
        registerView.isHidden = true
    }
    
    @objc func swipe(_ sender:UISwipeGestureRecognizer){
        self.view.endEditing(true)
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        if registerView.isHidden == true{
            UIView.transition(with: loginView, duration: 1.0, options: transitionOptions, animations: {
                self.registerView.isHidden = false
            })
            UIView.transition(with: loginView, duration: 1.0, options: transitionOptions, animations: {
            })
        }else{
            UIView.transition(with: loginView, duration: 1.0, options: transitionOptions, animations: {
            })
            UIView.transition(with: registerView, duration: 1.0, options: transitionOptions, animations: {
                self.registerView.isHidden = true
            })
        }
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
                    if UserDefaults.standard.object(forKey: "newUser") as! Bool == true{
                        
                        //use email
                        let formattedEmail = Formatter.formateEmail(email: (u?.email)!)
                        self.ref.child("emails").updateChildValues([formattedEmail:user!.uid])
                    }
                    //remove stored passed client if it exist
                    DBService.shared.passedClient.clientKey = ""
                    //called only for login
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc =   storyboard.instantiateViewController(withIdentifier: "inputNavID") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                }
            })
        }) as? UInt
    }
    
    @objc func hitTest(_ sender:UITapGestureRecognizer){
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
        if !(registerView as! RegisterView).emailTxtField.frame.contains(sender.location(in: view)){
            if (registerView as! RegisterView).emailTxtField.isEditing{
                self.view.endEditing(true)
            }
        }
        if !(registerView as! RegisterView).passwordTxtField.frame.contains(sender.location(in: view)){
            if (registerView as! RegisterView).passwordTxtField.isEditing{
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
    
    @IBAction func recoverPasswordBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Recover Password", message: "Please enter an email", preferredStyle: UIAlertControllerStyle.alert)

        alertController.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "Email"
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            if alertController.textFields![0].text != ""{
                FIRAuth.auth()?.sendPasswordReset(withEmail: alertController.textFields![0].text!) { error in
                    
                    if error != nil
                    {
                        // Error - Unidentified Email
                        let errorAlert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(errorAlert, animated: true, completion:nil)
                    }
                    else
                    {
                        // Success - Sent recovery email
                        let alert = UIAlertController(title: "Success", message: "Password Sent!", preferredStyle: UIAlertControllerStyle.alert)
                        self.present(alert, animated: true, completion: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.dismiss(animated: true, completion: nil)
                        })})
                    }
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "Please enter an email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        if (emailTF.text?.count) == 0{
            emailTF.shake()
        }else if (passwordTF.text?.count)! == 0{
            passwordTF.shake()
        }else{
            FIRAuth.auth()?.signIn(withEmail: emailTF.text!, password: passwordTF.text!, completion:{(user, error) in
                if user == nil{
                    let internetCheck = Reachability.isInternetAvailable()
                    if internetCheck == false{
                        let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        let alertController = UIAlertController(title: "Invalid Credentials", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    self.prefs.set(self.emailTF.text, forKey: "email")
                    self.prefs.set(self.passwordTF.text, forKey:"password")
                    self.prefs.set(self.rememberMeSwitch.isOn, forKey:"switch")
                    self.setAuthListener()
                }
            })
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

