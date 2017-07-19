//
//  WorkoutInputViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/11/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class WorkoutInputViewController: UIViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate, MenuViewDelegate, WorkoutInputViewDelegate{
    
    @IBOutlet var workoutInputView: WorkoutInputView!
    
    var menuShowing = false
    var bodybuildingExercises = [String]()
    var crossfitExercises = [String]()
    var user:FIRUser!
    var ref:FIRDatabaseReference!
    var nameArray = [String]()
    var buttonItemView:Any!
    var menuView:MenuView!
    var overlayView: OverlayView!
    var tempKey:String!
    var exerciseDictionary = [String:Any]()
    var tempExercise = Exercise()
    var exerciseKey:String!
    var activeField: UITextField?
    var keyboardActive = false
    var edit = false
    var passedOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutInputView.delegate = self
        
        let tempBool = UserDefaults.standard.object(forKey: "newUser") as! Bool
        if tempBool == true{
            //must be called once //add user info
            DBService.shared.initializeData()
            UserDefaults.standard.set(false, forKey: "newUser")
        }
        
        let barButtonItem = self.navigationItem.rightBarButtonItem!
        buttonItemView = barButtonItem.value(forKey: "view")
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        print(user.email!)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 30)!,NSForegroundColorAttributeName: UIColor.white]
        
        NotificationCenter.default.addObserver(self, selector:#selector(WorkoutInputViewController.updateNotification(_:)), name: NSNotification.Name(rawValue: "notifKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WorkoutInputViewController.getExercise(_:)), name: NSNotification.Name(rawValue: "getExerciseID"), object: nil)
        
        workoutInputView.initializeView()
        workoutInputView.setNotifications(num:UIApplication.shared.applicationIconBadgeNumber)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        UIApplication.shared.keyWindow?.addSubview(workoutInputView.notificationNumber)
        
        registerForKeyboardNotifications()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        
        //initialize position of views
        menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        workoutInputView.setCurrentDate()
        DBService.shared.retrieveClients {
            self.nameArray.removeAll()
            for client in DBService.shared.clients{
                self.nameArray.append(client.firstName + " " + client.lastName)
            }
            self.nameArray.insert("Personal", at: 0)
        }
        
        if DBService.shared.passedClient.firstName != ""{
            if DBService.shared.passedClient.firstName == "Personal"{
                title = DBService.shared.passedClient.firstName
            }else{
            title = DBService.shared.passedClient.firstName + " " + DBService.shared.passedClient.lastName
            }
        }else{
            title = "Personal"
        }
        
        if edit == true{
            //set tempExercise from passedExercise
            tempExercise = DBService.shared.passedExercise
            tempExercise.exerciseDescription = Formatter.formatExerciseDescription(desStr: tempExercise.exerciseDescription)
            tempExercise.exerciseDescription = tempExercise.name + tempExercise.exerciseDescription
            workoutInputView.fillInExercisePassed(exercise: tempExercise)
        }else{
            fillInExercisePassed()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //clear passedExercise
        DBService.shared.clearExercisePassed()
        DBService.shared.setPassedClientToPersonal()
    }
    
    func updateNotification(_ notification: Notification) {
        workoutInputView.updateNotification()
    }
    
    func updateNotif(){
        workoutInputView.updateNotification()
    }
    
    func getExercise(_ notification: Notification){
        let info:[String:Exercise] = (notification as NSNotification).userInfo as! [String:Exercise]
        tempExercise = info["exerciseKey"]!
        //format response
        let desStr:String = tempExercise.exerciseDescription
        let formatExerciseDesStr = Formatter.formatExerciseDescription(desStr: desStr)
        let formattedStr = tempExercise.name + formatExerciseDesStr
        workoutInputView.saveExercise(exStr: formattedStr)
    }
    
    func handleResultPickerChoice() -> Int{
        if edit == true{
            tempExercise = DBService.shared.passedExercise
        }
        
        if tempExercise.category == "1 Rep Max" || tempExercise.type == "Bodybuilding"{
            if tempExercise.name == "Superset"{
                return 7
            }
            return 3
        }else if tempExercise.name == "Metcon" || tempExercise.name == "Fran" || tempExercise.name == "Grace" || tempExercise.name == "Murph" || tempExercise.category == "For Time" || tempExercise.name == "Angie" || tempExercise.name == "Diane"{
            return 2
        }else if tempExercise.name == "Amrap"{
            return 4
        }else if tempExercise.name == "Emom" || tempExercise.name == "Cindy"{
            return 5
        }else if tempExercise.name == "Tabata"{
            return 6
        }else{
            return 0
        }
    }
    
    func handleSave(json: [String : Any]) {
        exerciseDictionary = json
        exerciseDictionary["description"] = tempExercise.exerciseDescription
        exerciseDictionary["name"] =  tempExercise.name
        exerciseDictionary["type"] = tempExercise.type
        exerciseDictionary["category"] = tempExercise.category
        exerciseDictionary["client"] = self.title
        exerciseDictionary["creatorEmail"] = user.email
        exerciseDictionary["creatorID"] = user.uid
        exerciseDictionary["clientKey"] = " "
        
        //look up clientKey from name
        if self.title != "Personal"{
            let tempClient = DBService.shared.retrieveClientInfoByFullName(fullName: self.title!)
            exerciseDictionary["clientKey"] = tempClient.clientKey
        }
        if edit == true{
            //if user changes client while exercises is in edit mode
            if DBService.shared.passedExercise.client != title{
                exerciseDictionary["exerciseKey"] = DBService.shared.createExerciseKey()
            }else{
                exerciseDictionary["exerciseKey"] = tempExercise.exerciseKey
            }
        }else{
            exerciseDictionary["exerciseKey"] = DBService.shared.createExerciseKey()
        }
        edit = false
        if self.title == "Personal"{
            DBService.shared.updateExerciseForUser(exerciseDictionary: exerciseDictionary, completion: {
                let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
                present(alert, animated: true, completion: {success in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.dismiss(animated: true, completion: nil)
                })})
            })
        }else{
            DBService.shared.updateExerciseForClient(exerciseDictionary: exerciseDictionary, completion: {
                let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
                present(alert, animated: true, completion: {success in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.dismiss(animated: true, completion: nil)
                })})
            })
        }
        //post request for notification if challenge is on!!!
        if ((exerciseDictionary["opponent"] as! String).characters.contains("@")){
            APIService.shared.post(endpoint: "http://104.236.21.144:3001/challenges", data: exerciseDictionary as [String : AnyObject], completion: {_ in })
        }
        
        //clear passedExercise
        DBService.shared.clearExercisePassed()
    }
    
    func handleSelection(type: String) {
        let inputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputNavVC") as! UINavigationController
        self.present(inputVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        addSelector()
    }
    
    func addSelector() {
        menuView.alpha = 1
        //slide view in here
        if menuShowing == false{
            menuView.addFx()
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: 0, y: 0, width: 126, height: 500)
                self.view.isHidden = false
                self.overlayView.alpha = 1
            })
            menuShowing = true
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
                self.overlayView.alpha = 0
                
            }, completion:{success in
                self.menuView.alpha = 0})
            menuShowing = false
            
        }
    }
    
    func fillInExercisePassed(){
        let ex = DBService.shared.passedExercise
        if ex.exerciseKey != ""{
            ex.exerciseDescription = Formatter.formatExerciseDescription(desStr: ex.exerciseDescription)
            ex.exerciseDescription = ex.name + ex.exerciseDescription
            workoutInputView.fillInExercisePassed(exercise: ex)
            ex.exerciseKey = ""
        }
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if menuShowing == true{
            //remove menu view
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
                self.overlayView.alpha = 0
            })
            menuShowing = false
        }
    }
    
    func saveEmail(emailStr:String){
        workoutInputView.saveEmail(emailStr: emailStr)
    }
    
    func saveResult(str:String){
        workoutInputView.saveResult(str: str)
    }
    
    func setEdit(bool:Bool){
        edit = bool
    }
    
    func setNewDate(dateStr:String){
        workoutInputView.setNewDate(dateStr: dateStr)
    }
    
    func savePickerName(name:String){
        self.title = name
        DBService.shared.setPassedClient(client:getClientFromName(n:name))
    }
    
    @IBAction func selectClient(_ sender: UIBarButtonItem) {
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        
        xPosition = self.view.frame.width/2
        yPosition = self.view.frame.minY + 60
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerVC") as! PickerViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 210)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        if sender.tag == 1{
            popController.setClients(clients: nameArray)
            popController.setTag(tag: 1)
        }
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func getClientFromName(n:String) -> Client{
        for client in DBService.shared.clients{
            if n == client.firstName + " " + client.lastName{
                return client
            }
        }
        //should never reach this statement
        return Client()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func keyboardWasShown(notification: NSNotification){
        keyboardActive = true
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        keyboardActive = false
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
