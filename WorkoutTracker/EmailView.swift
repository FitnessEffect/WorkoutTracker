//
//  EmailView.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/28/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import Foundation
import UIKit

class EmailView: UIView{
    
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    class func instanceFromNib() -> UIView {
        
        return UINib(nibName: "EmailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmailView
    }
    
//    @IBAction func addEmail(_ sender: UIButton) {
//        let presenter = self.presentingViewController?.childViewControllers.last as! WorkoutInputViewController
//        
//        presenter.saveEmail(emailStr: emailTextField.text!)
//        dismiss(animated: true, completion: nil)
//    }
    
    func dismissMenu() {
        self.removeFromSuperview()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
