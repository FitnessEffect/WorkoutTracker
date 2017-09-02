//
//  ForTimeViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class HeroWodsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    var exercises = [String]()
    let exerciseKey:String = "exerciseKey"
    var myExercise = Exercise()
    var categoryPassed:String!
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryPassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
        
        if categoryPassed == "1 Rep Max"{
            let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BodybuildingCategoryTableViewController.rightSideBarButtonItemTapped(_:)))
            rightBarButton.image = UIImage(named:"addIcon")
            self.navigationItem.rightBarButtonItem = rightBarButton
            rightBarButton.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        }
        
         spinner.frame = CGRect(x:(self.pickerOutlet.frame.width/2)-25, y:(self.pickerOutlet.frame.height/2)-25, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        spinner.alpha = 0
        pickerOutlet.addSubview(spinner)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if categoryPassed == "1 Rep Max"{
            spinner.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            DispatchQueue.global(qos: .userInteractive).async {
                DBService.shared.retrieveCrossfitCategoryExercises(completion: {
                    UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                    self.spinner.stopAnimating()
                    self.exercises = DBService.shared.exercisesForCrossfitCategory
                    self.pickerOutlet.reloadAllComponents()
                })
            }
            pickerOutlet.isUserInteractionEnabled = true
        }else{
            spinner.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            DispatchQueue.global(qos: .userInteractive).async {
                UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                self.spinner.stopAnimating()
                DBService.shared.retrieveHeroWods(completion:{
                    self.exercises = DBService.shared.crossfitHeroWods
                    self.pickerOutlet.reloadAllComponents()
                })
            }
        }
    }
    
    func setCategory(category:String){
        categoryPassed = category
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createCrossfitExerciseID") as! CreateCrossfitExerciseViewController
        popController.setCategory(category:categoryPassed)
        self.navigationController?.pushViewController(popController, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row]
    }
    
    @IBAction func addWod(_ sender: UIButton) {
        if categoryPassed == "Hero Wods"{
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            myExercise.name = exercises[id]
            myExercise.category = "Hero Wods"
            myExercise.type = "Crossfit"
            DBService.shared.retrieveWodDescription(wodName: myExercise.name, completion: {
                (str) in
                self.myExercise.exerciseDescription = str
                NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [self.exerciseKey:self.myExercise])
                if self.myExercise.name == "Cindy"{
                    DBService.shared.setEmomTime(time:"20")
                }
            })
        }else{
            let id:Int = pickerOutlet.selectedRow(inComponent: 0)
            myExercise.name = "1 Rep Max"
            myExercise.category = "1 Rep Max"
            myExercise.exerciseDescription = exercises[id]
            myExercise.type = "Crossfit"
            NotificationCenter.default.post(name: Notification.Name(rawValue: "getExerciseID"), object: nil, userInfo: [exerciseKey:myExercise])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = exercises[row]
        let myTitle = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName:UIFont(name: "Have a Great Day", size: 28.0)!,NSForegroundColorAttributeName:UIColor.black])
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
}
