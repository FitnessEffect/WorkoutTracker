//
//  CreateBodybuildingCategoryViewController.swift
//  
//
//  Created by Stefan Auvergne on 6/2/17.
//
//

import UIKit

class CreateBodybuildingCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var exCategory: UITextField!
    @IBOutlet weak var add: UIButton!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        
        //let id:Int = pickerOutlet.selectedRow(inComponent: 0)
        myExercise.name = exCategory.text!
       // myExercise.category = categories[id]
        
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        
        dismiss(animated: true, completion: nil)
    }

}
