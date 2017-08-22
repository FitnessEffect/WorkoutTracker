//
//  RegisterView.swift
//  
//
//  Created by Stefan Auvergne on 8/21/17.
//
//

import Foundation
import UIKit
import Firebase


class RegisterView: UIView, UITextFieldDelegate{
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "RegisterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RegisterView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        self.endEditing(true)
        if emailTxtField.text == "" {
            let alertController = UIAlertController(title: "Invalid Email", message: "Please enter an email", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
             self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else if passwordTxtField.text == "" {
            let alertController = UIAlertController(title: "Invalid Password", message: "Please enter a password", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
             self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }else{
            FIRAuth.auth()?.createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
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
                            FIRAuth.auth()?.signIn(withEmail: self.emailTxtField.text!, password: self.passwordTxtField.text!, completion:{(success) in
                                if success.0 == nil{
                                    let alertController = UIAlertController(title: "Invalid Credentials", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                                }
                            })
                        }
                    }
                    
                    let alertController = UIAlertController(title: "", message: "You are registered!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

