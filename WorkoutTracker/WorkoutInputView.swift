//
//  WorkoutInputView.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 6/7/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

protocol WorkoutInputViewDelegate {
    func handleSave(json:[String:Any])
    func handleResultPickerChoice()->Int
}

class WorkoutInputView: UIView, UITextViewDelegate, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var exerciseBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var erase: UIButton!
    @IBOutlet weak var eraseResult: UIButton!
    @IBOutlet weak var eraseEmail: UIButton!
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var challenge: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailTxtView: UITextView!
    @IBOutlet weak var notificationNumber: UILabel!
    
    var delegate: WorkoutInputViewDelegate?
    var del: PresentAlertDelegate?
    var name: String = ""
    var date: Date = Date()
    var translation1:CGFloat = 0
    var translation2:CGFloat = 0
    var translation3:CGFloat = 0
    var resultStartPosition:CGFloat = 0
    var challengeStartPosition:CGFloat = 0
    var saveStartPosition:CGFloat = 0
    var dateStartPosition:CGFloat = 0
    var dateSelected:String!
    var sessionsNames = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func initializeView(){
        resultTextView.alpha = 0
        descriptionTextView.alpha = 0
        emailTxtView.alpha = 0
        erase.alpha = 0
        eraseResult.alpha = 0
        eraseEmail.alpha = 0
        notificationNumber.alpha = 0
        
        resultStartPosition = resultBtn.frame.origin.y
        challengeStartPosition = challenge.frame.origin.y
        saveStartPosition = saveButton.frame.origin.y
        dateStartPosition = dateBtn.frame.origin.y
        
        translation1 = descriptionTextView.frame.size.height - 80
        translation2 = resultTextView.frame.size.height - 80
        translation3 = emailTxtView.frame.size.height - 80
        resultBtn.isUserInteractionEnabled = false
        challenge.isUserInteractionEnabled = false
        saveButton.isUserInteractionEnabled = false
        
        self.exerciseBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
        
        notificationNumber.layer.cornerRadius = 10.0
        notificationNumber.clipsToBounds = true
        notificationNumber.layer.borderWidth = 1
        notificationNumber.layer.borderColor = UIColor.red.cgColor
        
        //set it on top of navigation bar
        notificationNumber.layer.zPosition = 1
    }
    
    func setNotifications(num:Int){
        if num == 0{
            notificationNumber.alpha = 0
        }else{
            notificationNumber.alpha = 1
            notificationNumber.text = String(num)
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController){
        DBService.shared.clearSupersetExercises()
    }
    
    func fillInExercisePassed(exercise:Exercise){
        if exercise.exerciseKey != ""{
            if DBService.shared.passedExercise.client != "Personal"{
                dateBtn.setTitle(exercise.date, for: .normal)
                saveExercise(exStr: exercise.exerciseDescription)
                exercise.exerciseDescription = Formatter.unFormatExerciseDescription(desStr: exercise.exerciseDescription)
                saveResult(str: (exercise.result))
                challenge.setTitle(DBService.shared.passedSession.sessionName, for: .normal)
                challenge.setBackgroundImage(nil, for: .normal)
                challenge.isUserInteractionEnabled = false
            }else{
                dateBtn.setTitle(exercise.date, for: .normal)
                saveExercise(exStr: exercise.exerciseDescription)
                exercise.exerciseDescription = Formatter.unFormatExerciseDescription(desStr: exercise.exerciseDescription)
                saveResult(str: (exercise.result))
                if exercise.opponent != ""{
                    //if exercise comes from history do not set creator as the challenger
                    if exercise.creatorEmail == DBService.shared.user.email{
                        saveEmail(emailStr: exercise.opponent)
                    }else{
                        //if exercise comes from challenges set creator as the challenger
                        saveEmail(emailStr: exercise.creatorEmail)
                    }
                }
            }
        }
    }
    
    func saveExercise(exStr:String){
        descriptionTextView.text = exStr
        //exerice Btn disappears first
        self.exerciseBtn.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.resultBtn.frame = CGRect(x: 0, y:(self.resultStartPosition + self.translation1), width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
            self.challenge.frame = CGRect(x: 0, y:(self.challengeStartPosition + self.translation1), width: self.challenge.frame.width, height: self.challenge.frame.height)
            self.saveButton.frame = CGRect(x: 0, y:(self.saveStartPosition + self.translation1), width: self.saveButton.frame.width, height: self.saveButton.frame.height)
            self.dateBtn.frame = CGRect(x: 0, y:(self.dateStartPosition + self.translation1), width: self.dateBtn.frame.width, height: self.dateBtn.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.descriptionTextView.alpha = 1
                self.erase.alpha = 1
                self.resultBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.resultBtn.isUserInteractionEnabled = true
            })
        }))
    }
    
    func updateNotification(){
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationNumber.alpha = 0
        }else{
            notificationNumber.alpha = 1
            notificationNumber.text = String(num)
        }
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSessionNames(names:[String]){
        sessionsNames = names
    }
    
    
    func setupClientSave(completion: () -> Void){
        if sessionsNames.count != 0{
            challenge.setTitle(sessionsNames.first, for: .normal)
            challenge.isUserInteractionEnabled = true
            //check if session > 1
            if sessionsNames.count > 1
            {
                challenge.isUserInteractionEnabled = true
                challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                completion()
            }else{
                challenge.isUserInteractionEnabled = false
                challenge.setBackgroundImage(UIImage(named:""), for: .normal)
                exerciseBtn.isUserInteractionEnabled = true
                exerciseBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                completion()
            }
        }else{
            challenge.isUserInteractionEnabled = true
            challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
            challenge.setTitle("Create Session", for: .normal)
            exerciseBtn.isUserInteractionEnabled = false
            exerciseBtn.setBackgroundImage(UIImage(named:""), for: .normal)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if emailTxtView.text != ""{
            DBService.shared.checkOpponentEmail(email:Formatter.formateEmail(email:emailTxtView.text), completion: {
                if DBService.shared.emailCheckBoolean == true{
                    var exerciseDictionary = [String:String]()
                    
                    let strDate = self.dateBtn.titleLabel!.text!
                    let tempDate = DateConverter.stringToDate(dateStr:strDate)
                    
                    let tempWeekNum = DateConverter.weekNumFromDate(date: tempDate as NSDate)
                    let tempYear = DateConverter.yearFromDate(date:tempDate as NSDate)
                    
                    DBService.shared.setCurrentWeekNumber(strWeek: String(tempWeekNum))
                    DBService.shared.setCurrentYearNumber(strYear: String(tempYear))
                    
                    exerciseDictionary["date"] =  (self.dateBtn.titleLabel?.text!)!
                    exerciseDictionary["result"] =   self.resultTextView.text!
                    exerciseDictionary["opponent"] = self.emailTxtView.text
                    exerciseDictionary["year"] = String(tempYear)
                    exerciseDictionary["week"] = String(tempWeekNum)
                    
                    self.saveButton.isUserInteractionEnabled = false
                    self.challenge.isUserInteractionEnabled = false
                    self.resultBtn.isUserInteractionEnabled = false
                    
                    self.delegate?.handleSave(json: exerciseDictionary)
                    self.eraseExerciseDescription()
                }else{
                    self.del?.presentAlert()
                }
            })
        }else{
            if DBService.shared.passedExercise.client != "Personal"{
                var exerciseDictionary = [String:String]()
                
                let strDate = dateBtn.titleLabel!.text!
                let tempDate = DateConverter.stringToDate(dateStr:strDate)
                
                let tempWeekNum = DateConverter.weekNumFromDate(date: tempDate as NSDate)
                let tempYear = DateConverter.yearFromDate(date:tempDate as NSDate)
                
                DBService.shared.setCurrentWeekNumber(strWeek: String(tempWeekNum))
                DBService.shared.setCurrentYearNumber(strYear: String(tempYear))
                
                exerciseDictionary["date"] =  (self.dateBtn.titleLabel?.text!)!
                exerciseDictionary["result"] =   self.resultTextView.text!
                    exerciseDictionary["sessionName"] = self.challenge.titleLabel?.text
                    exerciseDictionary["opponent"] = ""
                    exerciseDictionary["year"] = String(tempYear)
                    exerciseDictionary["week"] = String(tempWeekNum)
                    self.saveButton.isUserInteractionEnabled = false
                    self.challenge.isUserInteractionEnabled = false
                    self.resultBtn.isUserInteractionEnabled = false
                    self.delegate?.handleSave(json: exerciseDictionary)
                    self.eraseExerciseDescription()
            }else{
                var exerciseDictionary = [String:String]()
                
                let strDate = dateBtn.titleLabel!.text!
                let tempDate = DateConverter.stringToDate(dateStr:strDate)
                
                let tempWeekNum = DateConverter.weekNumFromDate(date: tempDate as NSDate)
                let tempYear = DateConverter.yearFromDate(date:tempDate as NSDate)
                
                DBService.shared.setCurrentWeekNumber(strWeek: String(tempWeekNum))
                DBService.shared.setCurrentYearNumber(strYear: String(tempYear))
                
                exerciseDictionary["date"] =  (self.dateBtn.titleLabel?.text!)!
                exerciseDictionary["result"] =   self.resultTextView.text!
                exerciseDictionary["opponent"] = self.emailTxtView.text
                exerciseDictionary["year"] = String(tempYear)
                exerciseDictionary["week"] = String(tempWeekNum)
                self.saveButton.isUserInteractionEnabled = false
                self.challenge.isUserInteractionEnabled = false
                self.resultBtn.isUserInteractionEnabled = false
                
                self.delegate?.handleSave(json: exerciseDictionary)
                self.eraseExerciseDescription()
            }
        }
    }
    
    @IBAction func selectDate(_ sender: UIButton) {
        let xPosition = dateBtn.frame.minX + (dateBtn.frame.width/2)
        let yPosition = dateBtn.frame.maxY - 25
        
        let currentController = self.getCurrentViewController()
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendar") as! CalendarViewController
        
        popController.dateBtn = true
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = currentController?.view
        popController.preferredContentSize = CGSize(width: 300, height: 275)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        currentController?.present(popController, animated: false, completion: nil)
    }
    
    @IBAction func selectExercise(_ sender: UIButton) {
        let xPosition = exerciseBtn.frame.minX + (exerciseBtn.frame.width/2)
        let yPosition = exerciseBtn.frame.midY + 15
        let currentController = self.getCurrentViewController()
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "exerciseNavID") as! UINavigationController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = currentController?.view
        popController.preferredContentSize = CGSize(width: 300, height: 350)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        currentController?.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func selectResult(_ sender: UIButton) {
        let xPosition:CGFloat = resultBtn.frame.minX + (resultBtn.frame.width/2)
        let yPosition:CGFloat = resultBtn.frame.midY + 15
        
        
        let currentController = self.getCurrentViewController()
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerVC") as! PickerViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = currentController?.view
        popController.preferredContentSize = CGSize(width: 300, height: 210)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        let int = delegate?.handleResultPickerChoice()
        
        popController.setTag(tag: int!)
        
        // present the popover
        currentController?.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func selectChallenge(_ sender: UIButton) {
        let xPosition = challenge.frame.minX + (challenge.frame.width/2)
        let yPosition = challenge.frame.maxY - 60
        
        let currentController = self.getCurrentViewController()
        
        if challenge.titleLabel?.text != "Challenge"{
            if challenge.titleLabel?.text != "Create Session"{
                // get a reference to the view controller for the popover
                let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerVC") as! PickerViewController
                
                // set the presentation style
                popController.modalPresentationStyle = UIModalPresentationStyle.popover
                
                // set up the popover presentation controller
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                popController.popoverPresentationController?.delegate = self
                popController.popoverPresentationController?.sourceView = currentController?.view
                popController.preferredContentSize = CGSize(width: 300, height: 200)
                popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
                popController.setTag(tag: 0)
                popController.setSessionNames(names:sessionsNames)
                popController.setCurrentSessionName(currentSessionName:(challenge.titleLabel?.text)!)
                
                // present the popover
                currentController?.present(popController, animated: true, completion: nil)
            }else{
                let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clientNavID") as! NavigationViewController
                popController.setPassToNextVC(bool: true)
                currentController?.present(popController, animated: true, completion: nil)
            }
        }else{
            
            // get a reference to the view controller for the popover
            let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "emailSelectionID") as! EmailSelectionViewController
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = currentController?.view
            popController.preferredContentSize = CGSize(width: 300, height: 200)
            popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
            
            // present the popover
            currentController?.present(popController, animated: true, completion: nil)
        }
    }
    
    func getTitle() -> String{
        let n = DBService.shared.passedExercise.client
        return n
    }
    
    func setCurrentDate(){
        dateSelected = DateConverter.getCurrentDate()
        dateBtn.setTitle(dateSelected, for: .normal)
    }
    
    func setPassedDate(){
        dateBtn.setTitle(DBService.shared.passedDate, for: .normal)
    }
    
    func setDateOnBtn(dateStr:String, completion: () -> Void){
        dateSelected = dateStr
        dateBtn.setTitle(dateStr,for: .normal)
        if DBService.shared.passedClient.clientKey != ""{
            completion()
        }
    }
    
    func saveResult(str:String){
        self.resultTextView.text = str
        UIView.animate(withDuration: 0.3, animations: {
            self.resultBtn.alpha = 0
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.resultTextView.alpha = 1
                self.eraseResult.alpha = 1
                self.challenge.frame = CGRect(x: 0, y: (self.challengeStartPosition + self.translation1 + self.translation2), width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.saveButton.frame = CGRect(x: 0, y: (self.saveStartPosition + self.translation1 + self.translation2), width: self.saveButton.frame.width, height: self.saveButton.frame.height)
                
                self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.saveButton.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                
                
                if DBService.shared.passedClient.clientKey == ""{
                    self.challenge.isUserInteractionEnabled = true
                    self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                }
                if DBService.shared.exSessionEdit == true || self.sessionsNames.count == 1{
                    self.challenge.isUserInteractionEnabled = false
                    self.challenge.setBackgroundImage(UIImage(named:""), for: .normal)
                    
                }else{
                    self.challenge.isUserInteractionEnabled = true
                    self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                }
                self.saveButton.isUserInteractionEnabled = true
                
                if DBService.shared.passedClient.clientKey == ""{
                    self.challenge.isUserInteractionEnabled = true
                    self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                }
            })
        }))
    }
    
    func saveEmail(emailStr:String){
        emailTxtView.text = emailStr
        UIView.animate(withDuration: 0.3, animations: {
            self.challenge.alpha = 0
            
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.emailTxtView.alpha = 1
                self.saveButton.frame = CGRect(x: 0, y: (self.saveStartPosition + self.translation1 + self.translation2 + self.translation3), width: self.saveButton.frame.width, height: self.saveButton.frame.height)
                self.eraseEmail.alpha = 1
                self.saveButton.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
            })
        }))
    }
    
    func eraseExerciseDescription(){
        UIView.animate(withDuration: 0.5, animations: {
            UserDefaults.standard.set(nil, forKey: "supersetDescription")
            DBService.shared.setEdit(bool:false)
            DBService.shared.clearExercisePassed()
            self.descriptionTextView.text = ""
            self.descriptionTextView.alpha = 0
            self.erase.alpha = 0
            self.resultTextView.text = ""
            self.resultTextView.alpha = 0
            self.emailTxtView.text = ""
            self.emailTxtView.alpha = 0
            self.eraseResult.alpha = 0
            self.eraseEmail.alpha = 0
            self.resultBtn.frame = CGRect(x: 0, y: self.resultStartPosition, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
            self.challenge.frame = CGRect(x: 0, y: self.challengeStartPosition, width: self.challenge.frame.width, height: self.challenge.frame.height)
            self.saveButton.frame = CGRect(x: 0, y: self.saveStartPosition, width: self.saveButton.frame.width, height: self.saveButton.frame.height)
            self.dateBtn.frame = CGRect(x: 0, y: self.dateStartPosition, width: self.dateBtn.frame.width, height: self.dateBtn.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.exerciseBtn.alpha = 1
                self.resultBtn.alpha = 1
                self.challenge.alpha = 1
                self.challenge.setBackgroundImage(UIImage(named:""), for: .normal)
                self.saveButton.setBackgroundImage(UIImage(named:""), for: .normal)
                self.resultBtn.setBackgroundImage(UIImage(named:""), for: .normal)
                self.exerciseBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.saveButton.isUserInteractionEnabled = false
                self.challenge.isUserInteractionEnabled = false
                self.resultBtn.isUserInteractionEnabled = false
            })
        }))
    }
    
    func eraseResultDescription(){
        UIView.animate(withDuration: 0.5, animations: {
            self.resultTextView.text = ""
            self.resultTextView.alpha = 0
            self.emailTxtView.text = ""
            self.emailTxtView.alpha = 0
            self.eraseResult.alpha = 0
            self.eraseEmail.alpha = 0
            self.resultBtn.frame = CGRect(x: 0, y: self.resultStartPosition + self.translation1, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
            self.challenge.frame = CGRect(x: 0, y: self.challengeStartPosition + self.translation1, width: self.challenge.frame.width, height: self.challenge.frame.height)
            self.saveButton.frame = CGRect(x: 0, y: self.saveStartPosition + self.translation1, width: self.saveButton.frame.width, height: self.saveButton.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.resultBtn.alpha = 1
                self.challenge.alpha = 1
                self.saveButton.setBackgroundImage(UIImage(named:""), for: .normal)
                self.challenge.setBackgroundImage(UIImage(named:""), for: .normal)
                self.resultBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.saveButton.isUserInteractionEnabled = false
                self.challenge.isUserInteractionEnabled = false
            })
        }))
    }
    
    func eraseEmailDescription(){
        UIView.animate(withDuration: 0.5, animations: {
            self.emailTxtView.text = ""
            self.emailTxtView.alpha = 0
            self.eraseEmail.alpha = 0
            self.challenge.frame = CGRect(x: 0, y: self.challengeStartPosition + self.translation1 + self.translation2, width: self.challenge.frame.width, height: self.challenge.frame.height)
            self.saveButton.frame = CGRect(x: 0, y: self.saveStartPosition + self.translation1 + self.translation2, width: self.saveButton.frame.width, height: self.saveButton.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.challenge.alpha = 1
                self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.saveButton.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
            })
        }))
    }
    
    @IBAction func eraseBtn(_ sender: UIButton) {
        if sender.tag == 0{
            eraseExerciseDescription()
        }else if sender.tag == 1{
            eraseResultDescription()
        }else if sender.tag == 2{
            eraseEmailDescription()
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
