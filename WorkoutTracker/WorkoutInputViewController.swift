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

class WorkoutInputViewController: UIViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var exerciseBtn: UIButton!
    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var erase: UIButton!
    @IBOutlet weak var eraseResult: UIButton!
    @IBOutlet weak var eraseEmail: UIButton!
    
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var challenge: UIButton!
    @IBOutlet weak var client: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var menuShowing = false
    var emailViewShowing = false
    var dateSelected:String!
    var bodybuildingExercises = [String]()
    var crossfitExercises = [String]()
    var user:FIRUser!
    var ref:FIRDatabaseReference!
    var nameArray = [String]()
    var buttonItemView:Any!
    var menuView:MenuView!
    var overlayView: OverlayView!
    var emailView:EmailView!
    var clientPassed = Client()
    var tempKey:String!
    var exercisePassed:Exercise!
    var exerciseDictionary = [String:Any]()
    var edit = false
    let currentExercise = Exercise()
    var exerciseKey:String!
    var translation1:CGFloat = 182
    var translation2:CGFloat = 65
    var transaltion3:CGFloat = 65
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if clientPassed.firstName != "" {
            title = clientPassed.firstName
        }else{
            title = "Personal"
        }
        
        resultTextView.alpha = 0
        descriptionTextView.alpha = 0
        emailTextView.alpha = 0
        erase.alpha = 0
        eraseResult.alpha = 0
        eraseEmail.alpha = 0
        exerciseBtn.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
        
        //registerForKeyboardNotifications()
        
        let barButtonItem = self.navigationItem.rightBarButtonItem!
        buttonItemView = barButtonItem.value(forKey: "view")
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        dateBtn.layer.borderWidth = 1
        dateBtn.layer.borderColor = UIColor.black.cgColor
        
        exerciseBtn.layer.borderWidth = 1
        exerciseBtn.layer.borderColor = UIColor.black.cgColor
        
        challenge.layer.borderWidth = 1
        challenge.layer.borderColor = UIColor.black.cgColor
        
        resultBtn.layer.borderWidth = 1
        resultBtn.layer.borderColor = UIColor.black.cgColor
        
        save.layer.borderWidth = 1
        save.layer.borderColor = UIColor.black.cgColor
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        resultTextView.layer.borderWidth = 1
        resultTextView.layer.borderColor = UIColor.black.cgColor
        
        emailTextView.layer.borderWidth = 1
        emailTextView.layer.borderColor = UIColor.black.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(WorkoutInputViewController.getExercise(_:)), name: NSNotification.Name(rawValue: "getExerciseID"), object: nil)
        
        dateSelected = DateConverter.getCurrentDate()
        dateBtn.setTitle(dateSelected, for: .normal)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        emailView = EmailView.instanceFromNib() as! EmailView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        view.addSubview(emailView)
        //initialize position of views
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
        emailView.alpha = 0
        emailView.frame = CGRect(x: 60, y: 230, width: 250, height: 200)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Clients").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                for client in keyArray{
                    self.ref.child("users").child(userID!).child("Clients").child(client).observeSingleEvent(of: .value, with: { (snapshot) in
                       let client = snapshot.value as? NSDictionary
                        let fName = client?["firstName"] as! String
                        let lName = client?["lastName"] as! String
                        let tempStr = fName + " " + lName
                        self.nameArray.append(tempStr)
                    })
  
                }
            }
            self.nameArray.insert("Personal", at: 0)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        if edit == true{
            fillInExercisePassed()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillInExercisePassed(){
        dateBtn.titleLabel?.text = exercisePassed.date
        let tempStr = exercisePassed.name + " " + exercisePassed.exerciseDescription
        saveExercise(exStr: tempStr)
        
        saveResult(str: exercisePassed.result)
    }
    
    func getExercise(_ notification: Notification){
        let info:[String:Exercise] = (notification as NSNotification).userInfo as! [String:Exercise]
        let myExercise = info["exerciseKey"]
        
        currentExercise.name = (myExercise?.name)!
        currentExercise.exerciseDescription = (myExercise?.exerciseDescription)!
        descriptionTextView.text = myExercise?.exerciseDescription
        
        //format response
        let desStr:String = myExercise!.exerciseDescription
        let stringParts = desStr.components(separatedBy: "|")
        
        //  descriptionTextView.textColor = UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
        
        var newString:String = ""
        newString.append("\n")
        for part in stringParts{
            newString.append(part)
            newString.append("\n")
        }
        let formattedStr = (myExercise?.name)! + newString
        
        saveExercise(exStr: formattedStr)
    }
    
    func saveExercise(exStr:String){
        descriptionTextView.text = exStr
        //exerice Btn disappears first
        self.exerciseBtn.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.resultBtn.frame = CGRect(x: 0, y:(168 + self.translation1), width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
            self.challenge.frame = CGRect(x: 0, y:(220+self.translation1), width: self.challenge.frame.width, height: self.challenge.frame.height)
            self.save.frame = CGRect(x: 0, y:(272+self.translation1), width: self.save.frame.width, height: self.save.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.descriptionTextView.alpha = 1
                self.erase.alpha = 1
                self.resultBtn.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
            })
        }))
    }
    
    func setClient(client:Client){
        clientPassed = client
    }
    
    func setExercise(exercise:Exercise){
        exercisePassed = exercise
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        addSelector()
    }
    
    func addSelector() {
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
            })
            menuShowing = false
        }
        menuView.profileBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.clientBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.historyBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.challengeBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.settingsBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.logoutBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
    }
    
    func btnAction(_ sender: UIButton) {
        
        if sender.tag == 1{
            let inputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputNavVC") as! UINavigationController
            self.present(inputVC, animated: true, completion: nil)
        }else if sender.tag == 2{
            let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyNavID") as! UINavigationController
            self.present(historyVC, animated: true, completion: nil)
        }else if sender.tag == 3{
            let clientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clientNavID") as! UINavigationController
            self.present(clientVC, animated: true, completion: nil)
        }else if sender.tag == 4{
            let challengesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "challengesNavID") as! UINavigationController
            self.present(challengesVC, animated: true, completion: nil)
        }else if sender.tag == 5{
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)
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
        
        }else if emailViewShowing == true{
            if emailView.frame.contains(sender.location(in: view)){
                //nothing
            }else{
                emailView.alpha = 0
                emailViewShowing = false
                self.overlayView.alpha = 0
            }
        }else{
            if dateBtn.frame.contains(sender.location(in: view)){
                selectDate(dateBtn)
            }else if exerciseBtn.frame.contains(sender.location(in: view)){
                selectExercise(exerciseBtn)
            }else if resultBtn.frame.contains(sender.location(in: view)){
                selectResult(resultBtn)
            }else if challenge.frame.contains(sender.location(in: view)){
                challengeBtn(challenge)
            }else if save.frame.contains(sender.location(in: view)){
                saveBtn(save)
            }
        }
    }
    
    @IBAction func eraseBtn(_ sender: UIButton) {
        //erase exercise
        if sender.tag == 0{
            UIView.animate(withDuration: 0.5, animations: {
                self.descriptionTextView.text = ""
                self.descriptionTextView.alpha = 0
                self.erase.alpha = 0
                self.resultTextView.text = ""
                self.resultTextView.alpha = 0
                self.emailTextView.text = ""
                self.emailTextView.alpha = 0
                self.eraseResult.alpha = 0
                self.eraseEmail.alpha = 0
                self.resultBtn.frame = CGRect(x: 0, y: 168, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
                self.challenge.frame = CGRect(x: 0, y: 220, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.save.frame = CGRect(x: 0, y: 272, width: self.save.frame.width, height: self.save.frame.height)
            }, completion: ( {success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.exerciseBtn.alpha = 1
                    self.resultBtn.alpha = 1
                    self.challenge.alpha = 1
                    self.challenge.setTitleColor(UIColor.lightGray, for: .normal)
                    self.save.setTitleColor(UIColor.lightGray, for: .normal)
                    self.resultBtn.setTitleColor(UIColor.lightGray, for: .normal)
                    self.exerciseBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 255, alpha: 1), for: .normal)
                })
            }))
            
            //erase result
        }else if sender.tag == 1{
            UIView.animate(withDuration: 0.5, animations: {
                self.resultTextView.text = ""
                self.resultTextView.alpha = 0
                self.emailTextView.text = ""
                self.emailTextView.alpha = 0
                self.eraseResult.alpha = 0
                self.eraseEmail.alpha = 0
                self.resultBtn.frame = CGRect(x: 0, y: 350, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
                self.challenge.frame = CGRect(x: 0, y: 402, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.save.frame = CGRect(x: 0, y: 454, width: self.save.frame.width, height: self.save.frame.height)
            }, completion: ( {success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultBtn.alpha = 1
                    self.challenge.alpha = 1
                    self.save.setTitleColor(UIColor.lightGray, for: .normal)
                    self.challenge.setTitleColor(UIColor.lightGray, for: .normal)
                    self.resultBtn.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
                })
            }))
            //erase email
        }else if sender.tag == 2{
            UIView.animate(withDuration: 0.5, animations: {
                self.emailTextView.text = ""
                self.emailTextView.alpha = 0
                self.eraseEmail.alpha = 0
                self.challenge.frame = CGRect(x: 0, y: 467, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.save.frame = CGRect(x: 0, y: 519, width: self.save.frame.width, height: self.save.frame.height)
            }, completion: ( {success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.challenge.alpha = 1
                    self.challenge.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    self.save.setTitleColor(UIColor(red: 0, green: 0, blue: 255, alpha: 1), for: .normal)
                })
            }))
        }
    }
    
    @IBAction func logoutBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func client(_ sender: UIBarButtonItem) {
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        
        xPosition = (buttonItemView as AnyObject).frame.minX + ((buttonItemView as AnyObject).frame.width/2)
        yPosition = (buttonItemView as AnyObject).frame.maxY
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerVC") as! PickerViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 416)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        if sender.tag == 1{
            popController.setClients(clients: nameArray)
            popController.setTag(tag: 1)
        }
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        exerciseKey = self.ref.child("users").child(user.uid).child("Exercises").childByAutoId().key
        if edit == false{
            if self.title == "Personal"{
                currentExercise.date = (dateBtn.titleLabel?.text!)!
                currentExercise.creator = user.email!
                currentExercise.result = resultTextView.text!
                //currentExercise.exerciseDescription = descriptionTextView.text!
                currentExercise.exerciseKey = exerciseKey
                
                //move currentExercise to exerciseDictionary for firebase
                exerciseDictionary["name"] =  currentExercise.name
                exerciseDictionary["description"] =  currentExercise.exerciseDescription
                exerciseDictionary["date"] =  currentExercise.date
                exerciseDictionary["result"] =  currentExercise.result
                exerciseDictionary["exerciseKey"] =  currentExercise.exerciseKey
                
                self.ref.child("users").child(user.uid).child("Exercises").child(exerciseKey).setValue(exerciseDictionary)
            }else{
                currentExercise.date = (dateBtn.titleLabel?.text)!
                currentExercise.creator = user.email!
                currentExercise.result = resultTextView.text!
                currentExercise.exerciseDescription = descriptionTextView.text!
                currentExercise.exerciseKey = exerciseKey
                currentExercise.client = self.title!
                
                exerciseDictionary["name"] =  currentExercise.name
                exerciseDictionary["description"] =  currentExercise.exerciseDescription
                exerciseDictionary["date"] =  currentExercise.date
                exerciseDictionary["result"] =  currentExercise.result
                exerciseDictionary["exerciseKey"] =  currentExercise.exerciseKey
                exerciseDictionary["client"] = currentExercise.client
                
                retrieveClientID(clientObj: clientPassed)
            }
        }else{
            if self.title == "Personal"{
                currentExercise.date = (dateBtn.titleLabel?.text)!
                currentExercise.creator = user.email!
                currentExercise.result = resultTextView.text!
                currentExercise.exerciseDescription = descriptionTextView.text!
                if currentExercise.name == ""{
                    exerciseDictionary["name"] = exercisePassed.name
                }else{
                    exerciseDictionary["name"] =  currentExercise.name
                }
                exerciseDictionary["description"] =  currentExercise.exerciseDescription
                exerciseDictionary["date"] =  currentExercise.date
                exerciseDictionary["result"] =  currentExercise.result
                exerciseDictionary["exerciseKey"] =  exercisePassed.exerciseKey
                
                self.ref.child("users").child(user.uid).child("Exercises").child(exercisePassed.exerciseKey).updateChildValues(exerciseDictionary)
            }else{
                currentExercise.date = (dateBtn.titleLabel?.text)!
                currentExercise.creator = user.email!
                currentExercise.result = resultTextView.text!
                currentExercise.exerciseDescription = descriptionTextView.text!
                currentExercise.client = self.title!
                if currentExercise.name == ""{
                    exerciseDictionary["name"] = exercisePassed.name
                }else{
                    exerciseDictionary["name"] =  currentExercise.name
                }
                exerciseDictionary["description"] =  currentExercise.exerciseDescription
                exerciseDictionary["date"] =  currentExercise.date
                exerciseDictionary["result"] =  currentExercise.result
                exerciseDictionary["exerciseKey"] =  exercisePassed.exerciseKey
                exerciseDictionary["client"] = currentExercise.client
                
                retrieveClientID(clientObj: clientPassed)
            }
        }
        
        //launchEmail(sendTo: email.text!)
        //use email
        //query the db to all the emails
        //find correct one and get user id key
        //send using the key to the correct spot in db
        
        //post request for notification if challenge is on!!!
        if (emailTextView.text?.characters.contains("@"))!{
            
            currentExercise.creator = user.email!
            currentExercise.opponent = (emailTextView.text)!
            
            var request = URLRequest(url: URL(string: "http://192.168.0.5:3001/challenges")!)
            request.httpMethod = "POST"
            //send email / ex id etc
            let postString = "exerciseKey=\(currentExercise.exerciseKey)&opponentEmail=\(currentExercise.opponent)&userID=\(user.uid)&userEmail=\(user.email!)"
            request.httpBody = postString.data(using: .utf8)
            print(postString)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print(response)
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
        }
    }
    
    func retrieveClientID(clientObj:Client){
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Clients").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // let value = snapshot.value as! NSDictionary
            if let clientsVal = snapshot.value as? [String: [String: AnyObject]] {
                for client in clientsVal {
                    if client.value["lastName"] as! String == clientObj.lastName && client.value["age"] as! String == clientObj.age{
                        self.tempKey = client.key
                        if self.edit == false{
                            self.ref.child("users").child(self.user.uid).child("Clients").child(self.tempKey).child("Exercises").child(self.exerciseKey).setValue(self.exerciseDictionary)
                        }else if self.edit == true{
                            self.ref.child("users").child(self.user.uid).child("Clients").child(self.tempKey).child("Exercises").child(self.exercisePassed.exerciseKey).updateChildValues(self.exerciseDictionary)
                        }
                        return
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func selectResult(_ sender: UIButton) {
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        
        xPosition = resultBtn.frame.minX + (resultBtn.frame.width/2)
        yPosition = resultBtn.frame.maxY
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerVC") as! PickerViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 416)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        if currentExercise.name == "1 Rep Max" || currentExercise.name == "Back" || currentExercise.name == "Legs" || currentExercise.name == "Abs" || currentExercise.name == "Arm" || currentExercise.name == "Chest"{
            popController.setTag(tag: 3)
            
        }else if currentExercise.name == "Tabata" || currentExercise.name == "Metcon" || currentExercise.name == "Fran" || currentExercise.name == "Grace" || currentExercise.name == "Murph"{
            popController.setTag(tag: 2)
            
        }else if currentExercise.name == "Amrap"{
            popController.setTag(tag: 4)
        }
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func selectExercise(_ sender: UIButton) {
        let xPosition = exerciseBtn.frame.minX + (exerciseBtn.frame.width/2)
        let yPosition = exerciseBtn.frame.maxY
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "exerciseNavID") as! UINavigationController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 416)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func selectDate(_ sender: UIButton) {
        let xPosition = dateBtn.frame.minX + (dateBtn.frame.width/2)
        let yPosition = dateBtn.frame.maxY
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendar") as! CalendarViewController
        
        popController.dateBtn = true
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 316)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
//    let alert = UIAlertController(title: "Verify", message: "Enter your existing passcode.", preferredStyle: .alert)
//    alert.addTextField(configurationHandler: { (textField) -> Void in
//    textField.placeholder = "Current Passcode"
//    textField.keyboardType = .numberPad
//    textField.keyboardAppearance = .dark
//    textField.isSecureTextEntry = true
//    })

    
    @IBAction func challengeBtn(_ sender: UIButton) {
//        let xPosition = exerciseBtn.frame.minX + (exerciseBtn.frame.width/2)
//        let yPosition = exerciseBtn.frame.maxY
//        
//        // get a reference to the view controller for the popover
//        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "emailSelectionID") as! EmailSelectionViewController
//        
//        // set the presentation style
//        popController.modalPresentationStyle = UIModalPresentationStyle.popover
//        
//        // set up the popover presentation controller
//        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
//        popController.popoverPresentationController?.delegate = self
//        popController.popoverPresentationController?.sourceView = self.view
//        popController.preferredContentSize = CGSize(width: 300, height: 200)
//        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
//        
//        // present the popover
//        self.present(popController, animated: true, completion: nil)
        
        //menuView.addFx()
        if emailViewShowing == false{
        UIView.animate(withDuration: 0.3, animations: {
            self.view.isHidden = false
            self.emailView.alpha = 1
            self.overlayView.alpha = 1
        })
            emailViewShowing = true
        }
        emailView.email.addTarget(self, action: #selector(emailBtnAction(_:)), for: .touchUpInside)
    }
    
    func emailBtnAction(_ sender: UIButton){
        emailViewShowing = false
        emailView.alpha = 0
        overlayView.alpha = 0
        saveEmail(emailStr: emailView.emailTextField.text!)
        emailView.emailTextField.resignFirstResponder()
    }
    
    func saveEmail(emailStr:String){
        emailTextView.text = emailStr
        UIView.animate(withDuration: 0.3, animations: {
            self.challenge.alpha = 0
            
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.emailTextView.alpha = 1
                self.save.frame = CGRect(x: 0, y: (519+self.transaltion3), width: self.save.frame.width, height: self.save.frame.height)
                self.eraseEmail.alpha = 1
                self.save.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
            })
        }))
    }
    
    func setNewDate(dateStr:String){
        dateSelected = dateStr
        dateBtn.setTitle(dateSelected,for: .normal)
    }
    
    func savePickerName(name:String){
        self.title = name
    }
    
    func saveResult(str:String){
        self.resultTextView.text = str
        UIView.animate(withDuration: 0.3, animations: {
            self.resultBtn.titleLabel?.textColor = UIColor(red: 179, green: 179, blue: 179, alpha: 1)
            self.resultBtn.alpha = 0
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.resultTextView.alpha = 1
                self.eraseResult.alpha = 1
                self.challenge.frame = CGRect(x: 0, y: (402 + self.translation2), width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.save.frame = CGRect(x: 0, y: (454 + self.translation2), width: self.save.frame.width, height: self.save.frame.height)
                self.challenge.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                self.resultBtn.titleLabel?.textColor = UIColor(red: 179, green: 179, blue: 179, alpha: 1)
                self.save.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
            })
        }))
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func launchEmail(sendTo address: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            mail.setMessageBody("<a href='workout-tracker://challenges/accept'>Clickme</a>", isHTML: true)
            present(mail, animated: true)
        } else {
            print("no go")
        }
    }
    
    
//    func keyboardWasShown(notification: NSNotification){
//        //Need to calculate keyboard exact size due to Apple suggestions
//        let info: NSDictionary  = notification.userInfo! as NSDictionary
//        let keyboardSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
//        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//        self.scrollView.setContentOffset(CGPoint(x:0, y:(keyboardSize.height)), animated: true)
//    }
//    
//    func keyboardWillBeHidden(notification: NSNotification){
//        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
//    }
//    
//    func registerForKeyboardNotifications(){
//        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    func deregisterFromKeyboardNotifications(){
//        //Removing notifies on keyboard appearing
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print(error!)
        controller.dismiss(animated: true, completion: nil)
    }
}

