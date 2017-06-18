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

class WorkoutInputView: UIView, UITextViewDelegate, UIPopoverPresentationControllerDelegate {

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
    @IBOutlet weak var client: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailTxtView: UITextView!
    @IBOutlet weak var notificationNumber: UILabel!

    var delegate: WorkoutInputViewDelegate?
    var name: String = ""
    var date: Date = Date()
    var translation1:CGFloat = 170
    var translation2:CGFloat = 100
    var translation3:CGFloat = 100
    var dateSelected:String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //emailTxtView.delegate = self
    }
    
    func initializeView(){
        resultTextView.alpha = 0
        descriptionTextView.alpha = 0
        emailTxtView.alpha = 0
        erase.alpha = 0
        eraseResult.alpha = 0
        eraseEmail.alpha = 0
        
        resultBtn.isUserInteractionEnabled = false
        challenge.isUserInteractionEnabled = false
        saveButton.isUserInteractionEnabled = false
        
        self.exerciseBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
        
         NotificationCenter.default.addObserver(self, selector:#selector(WorkoutInputView.appEnteredForeground(_:)), name: NSNotification.Name(rawValue: "appEnteredForegroundKey"), object: nil)
    }
    
    func setNotifications(num:Int){
        if num == 0{
            notificationNumber.text = ""
        }else{
            notificationNumber.text = String(num)
        }
    }
    
    func fillInExercisePassed(exercise:Exercise){
        dateBtn.setTitle(exercise.date, for: .normal)
        saveExercise(exStr: exercise.exerciseDescription)
        exercise.exerciseDescription = unFormatExerciseDescription(desStr: exercise.exerciseDescription)
        saveResult(str: (exercise.result))
        if exercise.opponent != ""{
            saveEmail(emailStr: exercise.opponent)
        }
    }
    
    func unFormatExerciseDescription(desStr:String) -> String{
        var stringParts = desStr.components(separatedBy: "\n")
        
        var newString:String = ""
        stringParts.removeFirst()
        stringParts.removeLast()
        for index in 0...stringParts.count-1{
            newString.append(stringParts[index])
            if index != stringParts.count - 1{
            newString.append("|")
            }
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
            self.saveButton.frame = CGRect(x: 0, y:(321+self.translation1), width: self.saveButton.frame.width, height: self.saveButton.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.descriptionTextView.alpha = 1
                self.erase.alpha = 1
                self.resultBtn.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.resultBtn.isUserInteractionEnabled = true
            })
        }))
    }
    
    func appEnteredForeground(_ notification: Notification){
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationNumber.text = ""
        }else{
            notificationNumber.text = String(num)
        }
    }
    
    func setDelegates() {
        emailTxtView.delegate = self
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
    
    @IBAction func save(_ sender: UIButton) {
       
        var exerciseDictionary = [String:String]()
        
        exerciseDictionary["date"] =  (dateBtn.titleLabel?.text!)!
        exerciseDictionary["result"] =   resultTextView.text!
        exerciseDictionary["opponent"] = emailTxtView.text
        
        self.saveButton.isUserInteractionEnabled = false
        self.challenge.isUserInteractionEnabled = false
        self.resultBtn.isUserInteractionEnabled = false
        
        delegate?.handleSave(json: exerciseDictionary)
        eraseExercise()
    }
    
    @IBAction func selectDate(_ sender: UIButton) {
        let xPosition = dateBtn.frame.minX + (dateBtn.frame.width/2)
        let yPosition = dateBtn.frame.maxY
        
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
        popController.preferredContentSize = CGSize(width: 300, height: 316)
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
        popController.preferredContentSize = CGSize(width: 300, height: 416)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        currentController?.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func selectResult(_ sender: UIButton) {
            let xPosition:CGFloat = resultBtn.frame.minX + (resultBtn.frame.width/2)
            let yPosition:CGFloat = resultBtn.frame.maxY
        
           let currentController = self.getCurrentViewController()
        
            // get a reference to the view controller for the popover
            let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerVC") as! PickerViewController
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = currentController?.view
            popController.preferredContentSize = CGSize(width: 300, height: 250)
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
    
    func setCurrentDate(){
        dateSelected = DateConverter.getCurrentDate()
        dateBtn.setTitle(dateSelected, for: .normal)
    }
    
    func setNewDate(dateStr:String){
        dateSelected = dateStr
        dateBtn.setTitle(dateSelected,for: .normal)
    }

    func updateUI() {
        // populate interface, show views, etc
    }
    
    func hideView(view: UIView) {
        // hide any view
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
                self.saveButton.frame = CGRect(x: 0, y: (411 + self.translation2), width: self.saveButton.frame.width, height: self.saveButton.frame.height)
                self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.saveButton.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                self.challenge.isUserInteractionEnabled = true
                self.saveButton.isUserInteractionEnabled = true
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
                self.saveButton.frame = CGRect(x: 0, y: (472+self.translation3), width: self.saveButton.frame.width, height: self.saveButton.frame.height)
                self.eraseEmail.alpha = 1
                self.saveButton.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
            })
        }))
    }
    
    func eraseExercise(){
        UIView.animate(withDuration: 0.5, animations: {
            self.descriptionTextView.text = ""
            self.descriptionTextView.alpha = 0
            self.erase.alpha = 0
            self.resultTextView.text = ""
            self.resultTextView.alpha = 0
            self.emailTxtView.text = ""
            self.emailTxtView.alpha = 0
            self.eraseResult.alpha = 0
            self.eraseEmail.alpha = 0
            self.resultBtn.frame = CGRect(x: 0, y: 232, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
            self.challenge.frame = CGRect(x: 0, y: 314, width: self.challenge.frame.width, height: self.challenge.frame.height)
            self.saveButton.frame = CGRect(x: 0, y: 396, width: self.saveButton.frame.width, height: self.saveButton.frame.height)
        }, completion: ( {success in
            UIView.animate(withDuration: 0.3, animations: {
                self.exerciseBtn.alpha = 1
                self.resultBtn.alpha = 1
                self.challenge.alpha = 1
                self.challenge.setBackgroundImage(UIImage(named:""), for: .normal)
                self.saveButton.setBackgroundImage(UIImage(named:""), for: .normal)
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
                self.emailTxtView.text = ""
                self.emailTxtView.alpha = 0
                self.eraseResult.alpha = 0
                self.eraseEmail.alpha = 0
                self.resultBtn.frame = CGRect(x: 0, y: 232, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
                self.challenge.frame = CGRect(x: 0, y: 314, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.saveButton.frame = CGRect(x: 0, y: 396, width: self.saveButton.frame.width, height: self.saveButton.frame.height)
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
            //erase result
        }else if sender.tag == 1{
            UIView.animate(withDuration: 0.5, animations: {
                self.resultTextView.text = ""
                self.resultTextView.alpha = 0
                self.emailTxtView.text = ""
                self.emailTxtView.alpha = 0
                self.eraseResult.alpha = 0
                self.eraseEmail.alpha = 0
                self.resultBtn.frame = CGRect(x: 0, y: 327, width: self.resultBtn.frame.width, height: self.resultBtn.frame.height)
                self.challenge.frame = CGRect(x: 0, y: 409, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.saveButton.frame = CGRect(x: 0, y: 491, width: self.saveButton.frame.width, height: self.saveButton.frame.height)
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
            //erase email
        }else if sender.tag == 2{
            UIView.animate(withDuration: 0.5, animations: {
                self.emailTxtView.text = ""
                self.emailTxtView.alpha = 0
                self.eraseEmail.alpha = 0
                self.challenge.frame = CGRect(x: 0, y: 409, width: self.challenge.frame.width, height: self.challenge.frame.height)
                self.saveButton.frame = CGRect(x: 0, y: 491, width: self.saveButton.frame.width, height: self.saveButton.frame.height)
            }, completion: ( {success in
                UIView.animate(withDuration: 0.3, animations: {
                    self.challenge.alpha = 1
                    self.challenge.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                    self.saveButton.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
                })
            }))
        }
    }

    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
