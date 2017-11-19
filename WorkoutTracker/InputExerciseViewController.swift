//
//  InputExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/11/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

protocol PresentAlertDelegate{
   func presentAlert()
}

class InputExerciseViewController: UIViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate, MenuViewDelegate, ExerciseInputViewDelegate, PresentAlertDelegate{
   
   @IBOutlet weak var menuBtnOutlet: UIBarButtonItem!
   @IBOutlet var inputExerciseView: InputExerciseView!
   
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
   
   override func viewDidLoad() {
      super.viewDidLoad()
      inputExerciseView.delegate = self
      inputExerciseView.del = self
      let tempBool = UserDefaults.standard.object(forKey: "newUser") as! Bool
      if tempBool == true{
         //must be called once //add user info
         DBService.shared.initializeData()
         UserDefaults.standard.set(false, forKey: "newUser")
      }
      menuBtnOutlet.accessibilityIdentifier = "menuButton"
      let barButtonItem = self.navigationItem.rightBarButtonItem!
      buttonItemView = barButtonItem.value(forKey: "view")
      
      user = FIRAuth.auth()?.currentUser
      ref = FIRDatabase.database().reference()
      
      NotificationCenter.default.addObserver(self, selector: #selector(InputExerciseViewController.getExercise(_:)), name: NSNotification.Name(rawValue: "getExerciseID"), object: nil)
      NotificationCenter.default.addObserver(self, selector:#selector(InputExerciseViewController.hideNotificationOnExit(_:)), name: NSNotification.Name(rawValue: "hideNotif"), object: nil)
      NotificationCenter.default.addObserver(self, selector:#selector(InputExerciseViewController.setNotifAlphaToZero(_:)), name: NSNotification.Name(rawValue: "notifAlphaToZero"), object: nil)
      NotificationCenter.default.addObserver(self, selector:#selector(InputExerciseViewController.setNotifAlphaToOne(_:)), name: NSNotification.Name(rawValue: "notifAlphaToOne"), object: nil)
      
      inputExerciseView.initializeView()
      inputExerciseView.setNotifications(num:UIApplication.shared.applicationIconBadgeNumber)
      
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      self.navigationController?.navigationBar.shadowImage = UIImage()
      self.navigationController?.navigationBar.isTranslucent = true
      self.navigationController?.view.backgroundColor = .clear
      
      UIApplication.shared.keyWindow?.addSubview(inputExerciseView.notificationNumber)
      
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
      self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "DJB Chalk It Up", size: 30)!,NSAttributedStringKey.foregroundColor: UIColor.white]
      //set title with client name or "Personal"
      if DBService.shared.passedClient.clientKey != ""{
         if DBService.shared.passedClient.firstName == "Personal"{
            title = DBService.shared.passedClient.firstName
         }else{
            title = DBService.shared.passedClient.firstName + " " + DBService.shared.passedClient.lastName
         }
      }else{
         title = "Personal"
      }
      //set date
      if DBService.shared.passedDate != ""{
         inputExerciseView.setPassedDate()
         
         if DBService.shared.passedExercise.exerciseKey == "" && title != "Personal"{
            checkSessions(dateStr: (inputExerciseView.dateBtn.titleLabel?.text)!, completion: {})
         }else{
            inputExerciseView.challenge.setTitle("Challenge", for: .normal)
            inputExerciseView.challenge.isUserInteractionEnabled = true
         }
      }else{
         inputExerciseView.setCurrentDate()
      }
      
      UserDefaults.standard.set(nil, forKey: "supersetDescription")
      DBService.shared.retrieveClients {
         self.nameArray.removeAll()
         for client in DBService.shared.clients{
            self.nameArray.append(client.firstName + " " + client.lastName)
         }
         self.nameArray.insert("Personal", at: 0)
         //check in case call is asynchronous
         for x in 0...self.nameArray.count - 1{
            var tempCount = 0
            if self.nameArray[x] == "Personal"{
               tempCount += 1
            }
            if tempCount == 2{
               self.nameArray.removeFirst()
            }
         }
      }
      self.nameArray.insert("Personal", at: 0)
      if DBService.shared.edit == true || DBService.shared.exSessionEdit == true{
         //set tempExercise from passedExercise
         tempExercise = DBService.shared.passedExercise
         tempExercise.exerciseDescription = Formatter.formatExerciseDescription(desStr: tempExercise.exerciseDescription)
         tempExercise.exerciseDescription = tempExercise.name + tempExercise.exerciseDescription
         inputExerciseView.fillInExercisePassed(exercise: tempExercise)
         if DBService.shared.exSessionEdit == true{
            inputExerciseView.challenge.setTitle(DBService.shared.passedSession.sessionName, for: .normal)
         }else{
            if title != "Personal"{
               checkSessions(dateStr: (inputExerciseView.dateBtn.titleLabel?.text)!, completion: {})
            }
         }
      }else{
         fillInExercisePassed()
      }
   }
   
   override func viewDidAppear(_ animated: Bool) {
      refreshNotifications()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      //clear passedExercise
      DBService.shared.clearExercisePassed()
      DBService.shared.setPassedClientToPersonal()
      DBService.shared.setEdit(bool: false)
      DBService.shared.setExSessionEdit(bool: false)
      DBService.shared.setPassedDate(dateStr: DateConverter.getCurrentDate())
   }
   
   func presentAlert(){
      let alert = UIAlertController(title: "Error", message: "No registered User with that email!", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
   }
   
   @objc func hideNotificationOnExit(_ notification: Notification){
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.resetBadgeNumber()
      DBService.shared.resetNotificationCount()
      inputExerciseView.notificationNumber.alpha = 0
   }
   
   @objc func setNotifAlphaToZero(_:Notification){
      inputExerciseView.notificationNumber.alpha = 0
   }
   
   @objc func setNotifAlphaToOne(_:Notification){
      inputExerciseView.notificationNumber.alpha = 1
      if DBService.shared.notificationCount == 0{
         inputExerciseView.notificationNumber.alpha = 0
      }else{
         inputExerciseView.notificationNumber.alpha = 1
         inputExerciseView.notificationNumber.text = String(DBService.shared.notificationCount)
      }
   }
   
   @objc func getExercise(_ notification: Notification){
      let info:[String:Exercise] = (notification as NSNotification).userInfo as! [String:Exercise]
      tempExercise = info["exerciseKey"]!
      //format response
      let desStr:String = tempExercise.exerciseDescription
      let formatExerciseDesStr = Formatter.formatExerciseDescription(desStr: desStr)
      if tempExercise.type == "Endurance"{
         let formattedStr = tempExercise.category + formatExerciseDesStr
         inputExerciseView.saveExercise(exStr: formattedStr)
      }else{
         let formattedStr = tempExercise.name + formatExerciseDesStr
         inputExerciseView.saveExercise(exStr: formattedStr)
      }
   }
   
   func handleResultPickerChoice() -> Int{
      if DBService.shared.edit == true || DBService.shared.exSessionEdit == true{
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
      }else if tempExercise.name == "Emom"{
         return 5
      }else if tempExercise.name == "Cindy"{
         return 11
      }else if tempExercise.name == "Tabata"{
         return 6
      }else if tempExercise.type == "Endurance"{
         if tempExercise.name == "Distance"{
            return 2
         }else{
            if tempExercise.category == "Rowing"{
               return 8
            }else{
               return 9
            }
         }
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
      exerciseDictionary["uploadTime"] = DateConverter.getCurrentTimeAndDate()
      
      if self.title != "Personal"{
         //look up clientKey from name
         let tempClient = DBService.shared.retrieveClientInfoByFullName(fullName: self.title!)
         exerciseDictionary["clientKey"] = tempClient.clientKey
         
         if DBService.shared.passedSession.key == ""{
            //update session
            for session in DBService.shared.sessions{
               if inputExerciseView.challenge.titleLabel?.text == session.sessionName{
                  DBService.shared.setPassedSession(session: session)
                  break
               }
            }
         }
      }
      if DBService.shared.edit == true || DBService.shared.exSessionEdit{
         //if user changes client while exercises is in edit mode
         if DBService.shared.passedExercise.client != title{
            exerciseDictionary["exerciseKey"] = DBService.shared.createExerciseKey()
         }else{
            exerciseDictionary["exerciseKey"] = tempExercise.exerciseKey
         }
      }else{
         exerciseDictionary["exerciseKey"] = DBService.shared.createExerciseKey()
      }
      DBService.shared.setEdit(bool:false)
      DBService.shared.setExSessionEdit(bool:false)
      if self.title == "Personal"{
         DBService.shared.updateExerciseForUser(exerciseDictionary: exerciseDictionary, completion: {
            let alert = UIAlertController(title: "Success", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
            present(alert, animated: true, completion: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
               self.dismiss(animated: true, completion: nil)
               self.refreshNotifications()
            })})
         })
      }else{
         DBService.shared.updateExerciseForClient(exerciseDictionary: self.exerciseDictionary, completion: {
            let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
               self.dismiss(animated: true, completion: nil)
               self.refreshNotifications()
            })})
         })
      }
      //post request for notification if challenge is on!!!
      if ((exerciseDictionary["opponent"] as! String).contains("@")){
         APIService.shared.post(endpoint: "http://fitnesseffect.us:3001/challenges", data: exerciseDictionary as [String : AnyObject], completion: {_ in })
      }
      //clear passedExercise
      DBService.shared.clearExercisePassed()
   }
   
   func handleSelection(type: String) {
      let inputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputNavVC") as! UINavigationController
      self.present(inputVC, animated: true, completion: nil)
   }
   
   func refreshNotifications(){
      //update notification
      DBService.shared.notificationCheck(completion: {
         self.inputExerciseView.setNotifications(num: DBService.shared.notificationCount)
         self.menuView.setNotifications(num:DBService.shared.notificationCount)
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.setBadgeNumber(DBService.shared.notificationCount)
      })
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
         inputExerciseView.fillInExercisePassed(exercise: ex)
         ex.exerciseKey = ""
      }
   }
   
   @objc func hitTest(_ sender:UITapGestureRecognizer){
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
      inputExerciseView.saveEmail(emailStr: emailStr)
   }
   
   func saveResult(str:String){
      inputExerciseView.saveResult(str: str)
   }
   
   func setNewDate(dateStr:String){
      if title != "Personal"{
         inputExerciseView.setDateOnBtn(dateStr: dateStr, completion: {
            checkSessions(dateStr: dateStr, completion: {})})
      }else{
         inputExerciseView.setDateOnBtn(dateStr: dateStr, completion: {})
      }
   }
   
   func checkSessions(dateStr:String, completion: () ->Void){
      let tempClient = DBService.shared.retrieveClientInfoByFullName(fullName: self.title!)
      DBService.shared.setPassedClient(client: tempClient)
      //retrieve session for day
      inputExerciseView.sessionsNames.removeAll()
      DBService.shared.retrieveSessionsForDateForClient(dateStr: dateStr, completion: {
         var tempStrings = [String]()
         for session in DBService.shared.sessions{
            tempStrings.append(session.sessionName)
            self.inputExerciseView.setSessionNames(names: tempStrings)
         }
         self.inputExerciseView.setupClientSave(completion: {})
      })
   }
   
   func savePickerName(name:String){
      self.title = name
      inputExerciseView.setTitleView(titleStr:name)
      //reset date to current day when knew user is selected
      let currentDate = DateConverter.getCurrentDate()
      inputExerciseView.saveButton.setTitle(currentDate, for: .normal)
      if name != "Personal"{
         self.checkSessions(dateStr: currentDate, completion: {})
      }else{
         self.inputExerciseView.setupPersonalSave()
      }
   }
   
   func savePickerSessionName(name:String){
      inputExerciseView.challenge.setTitle(name, for: .normal)
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
   
   
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
   
   @objc func keyboardWasShown(notification: NSNotification){
      keyboardActive = true
   }
   
   @objc func keyboardWillBeHidden(notification: NSNotification){
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
