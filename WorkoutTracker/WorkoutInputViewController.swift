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

class WorkoutInputViewController: UIViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate, MenuViewDelegate{
    
    @IBOutlet var workoutInputView: WorkoutInputView!
    @IBOutlet weak var backgroundImage: UIImageView!
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
    
    var menuShowing = false
    var dateSelected:String!
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
    var edit = false
    var tempExercise = Exercise()
    var exerciseKey:String!
    var translation1:CGFloat = 170
    var translation2:CGFloat = 100
    var translation3:CGFloat = 100
    var activeField: UITextField?
    var keyboardActive = false
    
    @IBOutlet weak var notificationNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //workoutInputView.setDelegates()
        //workoutInputView.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(WorkoutInputViewController.appEnteredForeground(_:)), name: NSNotification.Name(rawValue: "appEnteredForegroundKey"), object: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DKCoolCrayon", size: 24)!,NSForegroundColorAttributeName: UIColor.white]
        
        if DBService.shared.passedClient.firstName != ""{
            
            title = DBService.shared.passedClient.firstName + " " + DBService.shared.passedClient.lastName
        }else{
            title = "Personal"
        }
        
        resultTextView.alpha = 0
        descriptionTextView.alpha = 0
        emailTextView.alpha = 0
        erase.alpha = 0
        eraseResult.alpha = 0
        eraseEmail.alpha = 0
        
        resultBtn.isUserInteractionEnabled = false
        challenge.isUserInteractionEnabled = false
        save.isUserInteractionEnabled = false
        
        self.exerciseBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
        
        let barButtonItem = self.navigationItem.rightBarButtonItem!
        buttonItemView = barButtonItem.value(forKey: "view")
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(WorkoutInputViewController.getExercise(_:)), name: NSNotification.Name(rawValue: "getExerciseID"), object: nil)
        
        registerForKeyboardNotifications()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        //initialize position of views
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
    }
    
//    func handleTextEntered(input: String) {
//        print(input)
//    }
    
    func appEnteredForeground(_ notification: Notification){
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationNumber.text = ""
        }else{
            notificationNumber.text = String(num)
        }
    }
    
    func handleSelection(type: String) {
        
        let inputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputNavVC") as! UINavigationController
                   self.present(inputVC, animated: true, completion: nil)

    }
//    func handleCreate(workoutName: String /*callback: () -> Void */ ) {
//        // do stuff to create the workout
//        exerciseDictionary = packageExercise()
//        DBService.shared.createExerciseForUser(exerciseDictionary: exerciseDictionary, completion: {
//            // launch confirmation alert
//        })
//        // callback()
//    }
    
//    func saveToDB() {
//        // save it
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationNumber.text = ""
        }else{
            notificationNumber.text = String(num)
        }
        if edit == true{
            dateSelected = DBService.shared.passedExercise.date
            dateBtn.setTitle(dateSelected, for: .normal)
            fillInExercisePassed()
            
        }else{
            dateSelected = DateConverter.getCurrentDate()
            dateBtn.setTitle(dateSelected, for: .normal)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillInExercisePassed(){
        tempExercise = DBService.shared.passedExercise
        tempExercise.exerciseDescription = formatExerciseDescription(desStr: tempExercise.exerciseDescription)
        dateBtn.setTitle(tempExercise.date, for: .normal)
        let tempStr = tempExercise.name + " " + tempExercise.exerciseDescription
        saveExercise(exStr: tempStr)
        saveResult(str: tempExercise.result)
        if tempExercise.opponent != ""{
            saveEmail(emailStr: tempExercise.opponent)
        }
    }
    
    func getExercise(_ notification: Notification){
        let info:[String:Exercise] = (notification as NSNotification).userInfo as! [String:Exercise]
        let myExercise = info["exerciseKey"]
        
        tempExercise.name = (myExercise?.name)!
        tempExercise.category = (myExercise?.category)!
        tempExercise.exerciseDescription = (myExercise?.exerciseDescription)!
        tempExercise.type = (myExercise?.type)!
        
        //format response
        let desStr:String = myExercise!.exerciseDescription
        
        let formatExerciseDesStr = formatExerciseDescription(desStr: desStr)
        let formattedStr = (myExercise?.name)! + formatExerciseDesStr
        
        saveExercise(exStr: formattedStr)
    }
    
    func formatExerciseDescription(desStr:String) -> String{
        let stringParts = desStr.components(separatedBy: "|")
        
        var newString:String = ""
        newString.append("\n")
        for part in stringParts{
            newString.append(part)
            newString.append("\n")
        }
        
        return newString
    }
    
    func saveExercise(exStr:String){
        descriptionTextView.text = exStr
        //exerice Btn disappears first
        self.exerciseBtn.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.resultBtn.frame = CGRect(x: 0, y:(157 + self.translation1), width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
            self.challenge.frame = CGRect(x: 0, y:(239+self.translation1), width: self.challenge.frame.width, height: self.challenge.frame.height)
            self.save.frame = CGRect(x: 0, y:(321+self.translation1), width: self.save.frame.width, height: self.save.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.descriptionTextView.alpha = 1
                self.erase.alpha = 1
                self.resultBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.resultBtn.isUserInteractionEnabled = true
            })
        }))
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
    
    func eraseExercise(){
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
            self.resultBtn.frame = CGRect(x: 0, y: 232, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
            self.challenge.frame = CGRect(x: 0, y: 314, width: self.challenge.frame.width, height: self.challenge.frame.height)
            self.save.frame = CGRect(x: 0, y: 396, width: self.save.frame.width, height: self.save.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.exerciseBtn.alpha = 1
                self.resultBtn.alpha = 1
                self.challenge.alpha = 1
                self.challenge.setBackgroundImage(UIImage(named:""), for: .normal)
                self.save.setBackgroundImage(UIImage(named:""), for: .normal)
                self.resultBtn.setBackgroundImage(UIImage(named:""), for: .normal)
                self.exerciseBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
            })
        }))
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
                self.resultBtn.frame = CGRect(x: 0, y: 232, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
                self.challenge.frame = CGRect(x: 0, y: 314, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.save.frame = CGRect(x: 0, y: 396, width: self.save.frame.width, height: self.save.frame.height)
            }, completion: ( {success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.exerciseBtn.alpha = 1
                    self.resultBtn.alpha = 1
                    self.challenge.alpha = 1
                    self.challenge.setBackgroundImage(UIImage(named:""), for: .normal)
                    self.save.setBackgroundImage(UIImage(named:""), for: .normal)
                    self.resultBtn.setBackgroundImage(UIImage(named:""), for: .normal)
                    self.exerciseBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                    self.save.isUserInteractionEnabled = false
                    self.challenge.isUserInteractionEnabled = false
                    self.resultBtn.isUserInteractionEnabled = false
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
                self.resultBtn.frame = CGRect(x: 0, y: 327, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
                self.challenge.frame = CGRect(x: 0, y: 409, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.save.frame = CGRect(x: 0, y: 491, width: self.save.frame.width, height: self.save.frame.height)
            }, completion: ( {success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultBtn.alpha = 1
                    self.challenge.alpha = 1
                    self.save.setBackgroundImage(UIImage(named:""), for: .normal)
                    self.challenge.setBackgroundImage(UIImage(named:""), for: .normal)
                    self.resultBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                    self.save.isUserInteractionEnabled = false
                    self.challenge.isUserInteractionEnabled = false
                })
            }))
            //erase email
        }else if sender.tag == 2{
            UIView.animate(withDuration: 0.5, animations: {
                self.emailTextView.text = ""
                self.emailTextView.alpha = 0
                self.eraseEmail.alpha = 0
                self.challenge.frame = CGRect(x: 0, y: 409, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.save.frame = CGRect(x: 0, y: 491, width: self.save.frame.width, height: self.save.frame.height)
            }, completion: ( {success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.challenge.alpha = 1
                    self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                    self.save.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
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
        
        xPosition = self.view.frame.width/2
        yPosition = (buttonItemView as AnyObject).frame.maxY + 20
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerVC") as! PickerViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 300)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        if sender.tag == 1{
            nameArray.removeAll()
            for client in DBService.shared.clients{
                let fName = client.firstName
                let lName = client.lastName
                let tempStr = fName + " " + lName
                self.nameArray.append(tempStr)
            }
            nameArray.insert("Personal", at: 0)
            popController.setClients(clients: nameArray)
            popController.setTag(tag: 1)
        }
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    //decouple ui stuff =>> put in method
    @IBAction func saveBtn(_ sender: UIButton) {
        
        if edit == false{
            if self.title == "Personal"{
                
                exerciseDictionary = packageExercise()
                
                DBService.shared.createExerciseForUser(exerciseDictionary: exerciseDictionary, completion: {
                    //DBService.shared.clearCurrentKey()
                    eraseExercise()
                    self.save.isUserInteractionEnabled = false
                    self.challenge.isUserInteractionEnabled = false
                    self.resultBtn.isUserInteractionEnabled = false
                    let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
                    present(alert, animated: true, completion: {success in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.dismiss(animated: true, completion: nil)
                        
                    })})
                })
            }else{
                
                exerciseDictionary = packageExercise()
                
                if self.edit == false{
                    DBService.shared.createExerciseForClient(exerciseDictionary: exerciseDictionary, completion: {
                        eraseExercise()
                        self.save.isUserInteractionEnabled = false
                        self.challenge.isUserInteractionEnabled = false
                        self.resultBtn.isUserInteractionEnabled = false
                        let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
                        present(alert, animated: true, completion: {success in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            self.dismiss(animated: true, completion: nil)
                        })})
                    })
                }else if self.edit == true{
                    DBService.shared.editExerciseForClient(exerciseDictionary: exerciseDictionary, completion: {
                        eraseExercise()
                        self.save.isUserInteractionEnabled = false
                        self.challenge.isUserInteractionEnabled = false
                        self.resultBtn.isUserInteractionEnabled = false
                        let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
                        present(alert, animated: true, completion: {success in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            self.dismiss(animated: true, completion: nil)
                        })})
                    })
                }
            }
        }else{
            if self.title == "Personal"{
                
                exerciseDictionary = packageExercise()
                
                DBService.shared.editExerciseForUser(exerciseDictionary: exerciseDictionary, completion: {
                    eraseExercise()
                    self.save.isUserInteractionEnabled = false
                    self.challenge.isUserInteractionEnabled = false
                    self.resultBtn.isUserInteractionEnabled = false
                    let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
                    present(alert, animated: true, completion: {success in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.dismiss(animated: true, completion: nil)
                    })})
                })
                
            }else{
                
                exerciseDictionary = packageExercise()
                
                if self.edit == false{
                    DBService.shared.createExerciseForClient(exerciseDictionary: exerciseDictionary, completion: {
                        eraseExercise()
                        self.save.isUserInteractionEnabled = false
                        self.challenge.isUserInteractionEnabled = false
                        self.resultBtn.isUserInteractionEnabled = false
                        let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
                        present(alert, animated: true, completion: {success in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            self.dismiss(animated: true, completion: nil)
                        })})
                    })
                }else if self.edit == true{
                    DBService.shared.editExerciseForClient(exerciseDictionary: exerciseDictionary, completion: {
                        eraseExercise()
                        self.save.isUserInteractionEnabled = false
                        self.challenge.isUserInteractionEnabled = false
                        self.resultBtn.isUserInteractionEnabled = false
                        let alert = UIAlertController(title: "Success!", message: "Your exercise was saved", preferredStyle: UIAlertControllerStyle.alert)
                        present(alert, animated: true, completion: {success in DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            self.dismiss(animated: true, completion: nil)
                        })})
                    })
                }
            }
        }
        
        //post request for notification if challenge is on!!!
        
        if ((exerciseDictionary["opponent"] as! String).characters.contains("@")){
            APIService.shared.post(endpoint: "http://104.236.21.144:3001/challenges", data: exerciseDictionary as [String : AnyObject], completion: {_ in })
        }
    }
    
    func handleSave() {
        // 1. package up the dictionary data
        // 2. whatever else always happens
        
        // 3. dependant actions
        if edit {
            switch (title!) {
                case "Personal":
                    // 4. call the db method you need
                    // 5. as the completion, pass in some other function in this VC
                    // that function can call some UI method
                    // separate the alert function into a method that takes in a title and body, and call it with the right title/body
                    break
                default:
                    break
            }
        }
        else {
            switch (title!) {
            case "Personal":
                break
            default:
                break
            }
        }
    }
    
    func packageExercise() -> [String:Any]{
        let currentExercise = Exercise()
        
        currentExercise.date = (dateBtn.titleLabel?.text!)!
        currentExercise.creatorEmail = user.email!
        currentExercise.result = resultTextView.text!
        //Save unformatted version of description
        currentExercise.exerciseDescription = tempExercise.exerciseDescription
        currentExercise.creatorID = user.uid
        currentExercise.name = tempExercise.name
        currentExercise.type = tempExercise.type
        currentExercise.category = tempExercise.category
        
        
        //how to perform if passedExercise is not initialized
        if DBService.shared.passedExercise.exerciseKey == ""{
            //create exercise key
            self.exerciseKey = DBService.shared.createExerciseKey()
        }else{
            exerciseKey = DBService.shared.passedExercise.exerciseKey
        }
        currentExercise.exerciseKey = exerciseKey
        
        currentExercise.client = self.title!
        if emailTextView.text.contains("@"){
            currentExercise.opponent = emailTextView.text!
        }else{
            currentExercise.opponent = ""
        }
        
        //move currentExercise to exerciseDictionary for firebase
        exerciseDictionary["name"] =  currentExercise.name
        exerciseDictionary["description"] =  currentExercise.exerciseDescription
        exerciseDictionary["date"] =  currentExercise.date
        exerciseDictionary["result"] =  currentExercise.result
        exerciseDictionary["exerciseKey"] =  currentExercise.exerciseKey
        exerciseDictionary["client"] = currentExercise.client
        exerciseDictionary["opponent"] = currentExercise.opponent
        exerciseDictionary["creatorEmail"] = currentExercise.creatorEmail
        exerciseDictionary["creatorID"] = currentExercise.creatorID
        exerciseDictionary["type"] = currentExercise.type
        exerciseDictionary["category"] = currentExercise.category
        
        return exerciseDictionary
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
        popController.preferredContentSize = CGSize(width: 300, height: 250)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        if tempExercise.name == ""{
            tempExercise = DBService.shared.passedExercise
        }
        
        if tempExercise.category == "1 Rep Max" || tempExercise.type == "Bodybuilding"{
            popController.setTag(tag: 3)
            
        }else if tempExercise.name == "Tabata" || tempExercise.name == "Metcon" || tempExercise.name == "Fran" || tempExercise.name == "Grace" || tempExercise.name == "Murph"{
            popController.setTag(tag: 2)
            
        }else if tempExercise.name == "Amrap"{
            popController.setTag(tag: 4)
        }
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func selectExercise(_ sender: UIButton) {
        let xPosition = exerciseBtn.frame.minX + (exerciseBtn.frame.width/2)
        let yPosition = exerciseBtn.frame.midY + 15
        
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
    
    @IBAction func challengeBtn(_ sender: UIButton) {
        let xPosition = challenge.frame.minX + (challenge.frame.width/2)
        let yPosition = challenge.frame.maxY - 60
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "emailSelectionID") as! EmailSelectionViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 200)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func saveEmail(emailStr:String){
        emailTextView.text = emailStr
        UIView.animate(withDuration: 0.3, animations: {
            self.challenge.alpha = 0
            
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.emailTextView.alpha = 1
                self.save.frame = CGRect(x: 0, y: (472+self.translation3), width: self.save.frame.width, height: self.save.frame.height)
                self.eraseEmail.alpha = 1
                self.save.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
            })
        }))
    }
    
    func setNewDate(dateStr:String){
        dateSelected = dateStr
        dateBtn.setTitle(dateSelected,for: .normal)
    }
    
    func savePickerName(name:String){
        self.title = name
        DBService.shared.setPassedClient(client:getClientFromName(n:name))
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
    
    func saveResult(str:String){
        self.resultTextView.text = str
        UIView.animate(withDuration: 0.3, animations: {
            self.resultBtn.alpha = 0
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.resultTextView.alpha = 1
                self.eraseResult.alpha = 1
                self.challenge.frame = CGRect(x: 0, y: (329 + self.translation2), width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.save.frame = CGRect(x: 0, y: (411 + self.translation2), width: self.save.frame.width, height: self.save.frame.height)
                self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.save.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.challenge.isUserInteractionEnabled = true
                self.save.isUserInteractionEnabled = true
                
            })
        }))
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func keyboardWasShown(notification: NSNotification){
        //let info: NSDictionary  = notification.userInfo! as NSDictionary
        //let keyboardSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
        //let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        //scrollView.contentInset = contentInsets
        //scrollView.scrollIndicatorInsets = contentInsets
        
        keyboardActive = true
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        
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

