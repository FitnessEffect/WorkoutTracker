//
//  EmailSelectionViewController.swift
//  
//
//  Created by Stefan Auvergne on 5/23/17.
//
//

import UIKit

class EmailSelectionViewController: UIViewController {

    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEmail(_ sender: UIButton) {
        let presenter = self.presentingViewController?.childViewControllers.last as! WorkoutInputViewController
    
        presenter.saveEmail(emailStr: emailTextField.text!)
        dismiss(animated: true, completion: nil)
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
