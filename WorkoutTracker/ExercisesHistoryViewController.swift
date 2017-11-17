//
//  ExercisesHistoryViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/20/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ExercisesHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var noExercisesLabel: UILabel!
    
    var selectedRow:Int = 0
    var exerciseArray = [Exercise]()
    var ref:FIRDatabaseReference!
    var tempKey:String!
    var overlayView: OverlayView!
    var user:FIRUser!
    var selectedDate = NSDate()
    var daysSections = [String:Any]()
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noExercisesLabel.alpha = 0
        displayCurrentWeek()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        self.title = "History"

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        spinner.frame = CGRect(x:(self.tableViewOutlet.frame.width/2)-25, y:(self.tableViewOutlet.frame.height/2)-25, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor.white
        spinner.alpha = 0
        tableViewOutlet.addSubview(spinner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentDate = DateConverter.stringToDate(dateStr: DateConverter.getCurrentDate())
        DBService.shared.setCurrentWeekNumber(strWeek: String(DateConverter.weekNumFromDate(date: currentDate as NSDate)))
        DBService.shared.setCurrentYearNumber(strYear: String(DateConverter.yearFromDate(date: currentDate as NSDate)))
        let internetCheck = Reachability.isInternetAvailable()
        if internetCheck == false{
            let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            spinner.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveExercisesForUser(completion:{
                    UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                    self.spinner.stopAnimating()
                    self.exerciseArray.removeAll()
                    self.exerciseArray = DBService.shared.exercisesForUser
                    self.exerciseArray.sort(by: {a, b in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "y-M-d HH:mm:ss"
                        let dateA = dateFormatter.date(from: a.uploadTime)!
                        let dateB = dateFormatter.date(from: b.uploadTime)!
                        if dateA > dateB {
                            return true
                        }
                        return false
                    })
                    self.refreshTableViewData()
                    if self.exerciseArray.count == 0{
                        self.noExercisesLabel.alpha = 1
                    }else{
                        self.noExercisesLabel.alpha = 0
                    }
                })
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "notifAlphaToZero"), object: nil, userInfo: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "notifAlphaToOne"), object: nil, userInfo: nil)
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
            self.exerciseArray.removeAll()
            self.exerciseArray = DBService.shared.exercisesForUser
            self.exerciseArray.sort(by: {a, b in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "y-M-d HH:mm:ss"
                let dateA = dateFormatter.date(from: a.uploadTime)!
                let dateB = dateFormatter.date(from: b.uploadTime)!
                if dateA > dateB {
                    return true
                }
                return false
            })
            self.refreshTableViewData()
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
    
    func refreshTableViewData(){
        self.daysSections = self.groupExercisesByDay(exercisesPassed: self.exerciseArray) as! [String : Any]
        tableViewOutlet.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var array:[Any]?
        
        switch(section){
        case 0:
            array = daysSections["Sunday"] as! [Any]!
        case 1:
            array = daysSections["Monday"] as! [Any]!
        case 2:
            array = daysSections["Tuesday"] as! [Any]!
        case 3:
            array = daysSections["Wednesday"] as! [Any]!
        case 4:
            array = daysSections["Thursday"] as! [Any]!
        case 5:
            array = daysSections["Friday"] as! [Any]!
        case 6:
            array = daysSections["Saturday"] as! [Any]!
        default:
            return 0;
        }
        if array == nil{
            return 0
        }
        return array!.count;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = ""
        var tempArray = [Exercise]()
        
        switch(section){
        case 0:
            if daysSections["Sunday"] != nil{
                tempArray = daysSections["Sunday"] as! [Exercise]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Sunday"
                }
            }
        case 1:
            if daysSections["Monday"] != nil{
                tempArray = daysSections["Monday"] as! [Exercise]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Monday"
                }
            }
        case 2:
            if daysSections["Tuesday"] != nil{
                tempArray = daysSections["Tuesday"] as! [Exercise]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Tuesday"
                }
            }
        case 3:
            if daysSections["Wednesday"] != nil{
                tempArray = daysSections["Wednesday"] as! [Exercise]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Wednesday"
                }
            }
        case 4:
            if daysSections["Thursday"] != nil{
                tempArray = daysSections["Thursday"] as! [Exercise]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Thursday"
                }
            }
        case 5:
            if daysSections["Friday"] != nil{
                tempArray = daysSections["Friday"] as! [Exercise]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Friday"
                }
            }
        case 6:
            if daysSections["Saturday"] != nil{
                tempArray = daysSections["Saturday"] as! [Exercise]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Saturday"
                }
            }
        default:
            sectionTitle = ""
        }
        return sectionTitle
    }
    
    func getExercisesForDayAtIndexPath(indexPath:NSIndexPath) -> [Exercise]{
        var array = [Exercise]()
        
        switch(indexPath.section){
        case 0:
            array = daysSections["Sunday"] as! [Exercise]
        case 1:
            array = daysSections["Monday"] as! [Exercise]
        case 2:
            array = daysSections["Tuesday"] as! [Exercise]
        case 3:
            array = daysSections["Wednesday"] as! [Exercise]
        case 4:
            array = daysSections["Thursday"] as! [Exercise]
        case 5:
            array = daysSections["Friday"] as! [Exercise]
        case 6:
            array = daysSections["Saturday"] as! [Exercise]
        default:
            return []
        }
        return array
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "DJB Chalk It Up", size: 30)
        header.backgroundView?.backgroundColor = UIColor.clear
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCustomCell
        let tempArr = getExercisesForDayAtIndexPath(indexPath: indexPath as NSIndexPath)
        if tempArr.count != 0{
            let exercise = tempArr[indexPath.row]
             //check if exercise.result is a time in seconds
            if exercise.result.contains("lb(s)") || exercise.result.contains("rep(s)") || exercise.result.contains("Completed") || exercise.result.contains("Incomplete"){
               cell.titleOutlet.text = exercise.name + " (" + exercise.result + ")"
            }else{
                let resultFormated = Formatter.changeTimeToDisplayFormat(secondsStr: exercise.result)
                cell.titleOutlet.text = exercise.name + " (" + resultFormated + ")"
            
            }
            cell.numberOutlet.text = String(indexPath.row + 1)
            cell.setExerciseKey(key: exercise.exerciseKey)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var array = [Exercise]()
        
        switch(indexPath.section){
        case 0:
            array = daysSections["Sunday"] as! [Exercise]
        case 1:
            array = daysSections["Monday"] as! [Exercise]
        case 2:
            array = daysSections["Tuesday"] as! [Exercise]
        case 3:
            array = daysSections["Wednesday"] as! [Exercise]
        case 4:
            array = daysSections["Thursday"] as! [Exercise]
        case 5:
            array = daysSections["Friday"] as! [Exercise]
        case 6:
            array = daysSections["Saturday"] as! [Exercise]
        default:
            array = []
        }
        
        let selectedExercise = array[indexPath.row]
        
        if editingStyle == .delete {
            let deleteAlert = UIAlertController(title: "Delete Entry?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                DBService.shared.deleteExerciseForUser(exercise: selectedExercise, completion: {
                    
                    for i in 0...self.exerciseArray.count{
                        if self.exerciseArray[i].exerciseKey == selectedExercise.exerciseKey{
                            self.exerciseArray.remove(at: i)
                            break
                        }
                    }
                    self.daysSections = self.groupExercisesByDay(exercisesPassed: self.exerciseArray) as! [String : Any]
                    
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    tableView.reloadData()
                    if self.exerciseArray.count == 0{
                        self.noExercisesLabel.alpha = 1
                    }else{
                        self.noExercisesLabel.alpha = 0
                    }
                })
                
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    func groupExercisesByDay(exercisesPassed:[Exercise])-> NSDictionary{
        var dict = [String:[Exercise]]()
        let sunday = [Exercise]()
        let monday = [Exercise]()
        let tuesday = [Exercise]()
        let wednesday = [Exercise]()
        let thursday = [Exercise]()
        let friday = [Exercise]()
        let saturday = [Exercise]()
        
        dict["Sunday"] = sunday
        dict["Monday"] = monday
        dict["Tuesday"] = tuesday
        dict["Wednesday"] = wednesday
        dict["Thursday"] = thursday
        dict["Friday"] = friday
        dict["Saturday"] = saturday
        
        for exercise in exercisesPassed{
            let dayName = DateConverter.getNameForDay(dateStr: exercise.date as String)
            var temp:[Exercise]{
                get{
                    return dict[dayName]!
                }
                set(newValue){
                    dict[dayName] = newValue
                }
            }
            temp.append(exercise)
        }
        return dict as NSDictionary
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editExerciseSegue"){
            let selectedIndexPath = tableViewOutlet.indexPathForSelectedRow
            let cell = tableViewOutlet.cellForRow(at: selectedIndexPath!) as! ExerciseCustomCell
            
            for i in 0...self.exerciseArray.count{
                if self.exerciseArray[i].exerciseKey == cell.exerciseKey{
                    DBService.shared.setPassedExercise(exercise: exerciseArray[i])
                    break
                }
            }
            DBService.shared.setEdit(bool:true)
        }
        if(segue.identifier == "addExerciseSegue"){
            DBService.shared.setEdit(bool: false)
        }
    }
}
