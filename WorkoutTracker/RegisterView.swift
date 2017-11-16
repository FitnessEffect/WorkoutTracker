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
    
    @IBAction func termsOfUse(_ sender: UIButton) {
        if let url = NSURL(string: "https://github.com/FitnessEffect/WorkoutTracker/blob/master/Terms%20of%20Use"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func setAnimations(txtField:UITextField) {
        let animationLayer = AnimatableLayer()
        txtField.layer.addSublayer(animationLayer)
        let anim = animationLayer.shake(from: CGPoint(x:txtField.center.x - 4, y: txtField.center.y), to: CGPoint(x:txtField.center.x + 4, y: txtField.center.y))
        txtField.layer.add(anim, forKey: "position")
    }
    
    @IBAction func register(_ sender: UIButton) {
        self.endEditing(true)
        if emailTxtField.text?.count == 0 {
            setAnimations(txtField: emailTxtField)
        }else if passwordTxtField.text?.count == 0{
            setAnimations(txtField: passwordTxtField)
        }else{
            FIRAuth.auth()?.createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
                if error == nil {
                    UserDefaults.standard.set(true, forKey: "newUser")
                    
                    if UIDevice.current.modelName == "Simulator" {
                        print("Simulator")
                    }
                    else {
                        print("Real Device")
                        if UIDevice.current.modelName == "iPhone 6s"{
                            FIRAuth.auth()?.signIn(withEmail: self.emailTxtField.text!, password: self.passwordTxtField.text!, completion:{(user, error) in
                                if user == nil{
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
}

