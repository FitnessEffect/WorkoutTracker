//
//  CreateBodybuildingCategoryViewController.swift
//
//
//  Created by Stefan Auvergne on 6/2/17.
//
//

import UIKit
import Firebase

class CreateBodybuildingCategoryViewController: UIViewController{
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var add: UIButton!
    
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var typePassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if !categoryName.frame.contains(sender.location(in: view)){
            self.view.endEditing(true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.x<0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.y > 70{
            scrollView.contentOffset.y = 70
        }
        if scrollView.contentOffset.y < 0{
            scrollView.contentOffset.y = 0
        }
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        myExercise.name = categoryName.text!
        var dictionary = [String:Any]()
        dictionary[categoryName.text!.capitalized] = true
        DBService.shared.createBodybuildingCategories(dictionary: dictionary)
        self.navigationController?.popViewController(animated: true)
    }
}
