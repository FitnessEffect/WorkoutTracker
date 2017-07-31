//
//  ChallengesViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/27/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ChallengesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var dateBtn: UIButton!
    
    var selectedRow:Int = 0
    var client = Client()
    var exerciseArray = [Exercise]()
    var tempKey:String!
    var menuShowing = false
    var menuView:MenuView!
    var overlayView: OverlayView!
    var selectedDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenges"
        displayCurrentWeek()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 30)!,NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnTableView(_:)))
        tableViewOutlet.addGestureRecognizer(tapGesture)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.resetBadgeNumber()
        DBService.shared.setChallengesToViewed()
        DBService.shared.resetNotificationCount()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "hideNotif"), object: nil, userInfo: nil)
        DBService.shared.retrieveChallengesExercises {
            self.exerciseArray = DBService.shared.challengeExercises
            self.exerciseArray.sort(by: {a, b in
                if a.date > b.date {
                    return true
                }
                return false
            })
            self.tableViewOutlet.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func didTapOnTableView(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: tableViewOutlet)
        let row = tableViewOutlet.indexPathForRow(at: touchPoint)?.row
        
        if row != nil{
            performSegue(withIdentifier: "editChallengeSegue", sender: sender)
        }
    }
    
    func displayCurrentWeek(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        selectedDate = currentDate as NSDate
        let tempEndDay = DateConverter.getSaturdayForWeek(selectedDate: selectedDate)
        let endDate = dateFormatter.string(from: tempEndDay as Date)
        let tempStartDay = DateConverter.getPreviousSundayForWeek(selectedDate:selectedDate)
        let startDate = dateFormatter.string(from: tempStartDay as Date)
        dateBtn.setTitle(startDate + " - " + endDate,for: .normal)
    }
    
    func displaySelectedWeek(date:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        selectedDate = date as NSDate
        let tempEndDay = DateConverter.getSaturdayForWeek(selectedDate: selectedDate)
        let endDate = dateFormatter.string(from: tempEndDay as Date)
        let tempStartDay = DateConverter.getPreviousSundayForWeek(selectedDate:selectedDate)
        let startDate = dateFormatter.string(from: tempStartDay as Date)
        dateBtn.setTitle(startDate + " - " + endDate,for: .normal)
    }
    
    func setNewDate(dateStr:String){
        dateBtn.setTitle(dateStr, for: .normal)
        let datePassed = DateConverter.stringToDate(dateStr: dateStr) as NSDate
        displaySelectedWeek(date: datePassed as Date)
        DBService.shared.setCurrentWeekNumber(strWeek: String(DateConverter.weekNumFromDate(date: datePassed)))
        DBService.shared.setCurrentYearNumber(strYear: String(DateConverter.yearFromDate(date: datePassed)))
        DBService.shared.retrieveExercisesForUser{
            self.exerciseArray = DBService.shared.exercisesForUser
            self.exerciseArray.sort(by: {a, b in
                if a.date > b.date {
                    return true
                }
                return false
            })
            self.tableViewOutlet.reloadData()
        }
    }
    
    @IBAction func selectDate(_ sender: UIButton) {
        let xPosition = dateBtn.frame.minX + (dateBtn.frame.width/2)
        let yPosition = dateBtn.frame.maxY - 25
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendar") as! CalendarViewController
        
        popController.dateBtn = true
        if dateBtn.titleLabel?.text?.isEmpty == false{
            let dateStr = dateBtn.titleLabel?.text
            let tempArray = dateStr?.components(separatedBy: " ")
            let tempArray2 = tempArray?[2].components(separatedBy: "/")
            
            popController.passedStartingMonth = Int((tempArray2?[0])!)!
            popController.passedStartingYear = Int((tempArray2?[2])!)!
        }
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath) as! ChallengeCustomCell
        let exercise = exerciseArray[(indexPath as NSIndexPath).row]
        cell.titleOutlet.text = exercise.name + " (" + exercise.result + ")"
        cell.challenger.text = exercise.creatorEmail
        cell.numberOutlet.text = String((indexPath as NSIndexPath).row + 1)
        return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this exercise?", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let x = indexPath.row
                let ex = self.exerciseArray[x]
                
                DBService.shared.deleteChallengeExerciseForUser(exercise:ex)
                
                self.exerciseArray.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion:nil)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editChallengeSegue"){
            let s = sender as! UITapGestureRecognizer
            
            let selectedRow = tableViewOutlet.indexPathForRow(at:s.location(in: tableViewOutlet))?.row
            DBService.shared.setPassedExercise(exercise: exerciseArray[selectedRow!])
            DBService.shared.setEdit(bool:true)
        }
    }
}
