//
//  EmailSelectionViewController.swift
//
//
//  Created by Stefan Auvergne on 5/23/17.
//
//

import UIKit

class EmailSelectionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.clipsToBounds = true
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEmail(_ sender: UIButton) {
        if !(emailTextField.text?.characters.contains("@"))! || !(emailTextField.text?.characters.contains("."))!{
            let alert = UIAlertController(title: "Error", message: "Incorrect email address", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let presenter = self.presentingViewController?.childViewControllers.last as! InputExerciseViewController
        presenter.saveEmail(emailStr: (emailTextField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))!)
        dismiss(animated: true, completion: nil)
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if !emailTextField.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
