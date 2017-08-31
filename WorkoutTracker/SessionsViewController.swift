//
//  ExercisesViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class SessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var dateBtn: UIButton!
    
    var selectedRow:Int = 0
    var clientPassed = Client()
    var sessionsArray = [Session]()
    var ref:FIRDatabaseReference!
    var tempKey:String!
    var user:FIRUser!
    var button:UIButton!
    var selectedDate = NSDate()
    var daysSections = [String:Any]()
    var cellCount = 0
    var spinner = UIActivityIndicatorView()
    var startDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayCurrentWeek()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 30)!,NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        button.titleLabel!.font =  UIFont(name: "DJB Chalk It Up", size: 30)
        button.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
        button.setTitle(clientPassed.firstName, for: .normal)
        button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        spinner.frame = CGRect(x:(self.tableViewOutlet.frame.width/2)-25, y:(self.tableViewOutlet.frame.height/2)-25, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor.white
        spinner.alpha = 0
        view.addSubview(spinner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentDate = DateConverter.stringToDate(dateStr: DateConverter.getCurrentDate())
        DBService.shared.setCurrentWeekNumber(strWeek: String(DateConverter.weekNumFromDate(date: currentDate as NSDate)))
        DBService.shared.setCurrentYearNumber(strYear: String(DateConverter.yearFromDate(date: currentDate as NSDate)))
        spinner.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
        DispatchQueue.global(qos: .userInitiated).async {
            DBService.shared.retrieveSessionsForClient(completion: {
                UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                self.spinner.stopAnimating()
                self.sessionsArray.removeAll()
                self.sessionsArray = DBService.shared.sessions
//                self.sessionsArray.sort(by: {a, b in
//                    if a.date > b.date {
//                        return true
//                    }
//                    return false
//                })
                self.refreshTableViewData()
            })
        }
        clientPassed = DBService.shared.retrieveClientInfo(clientKey: clientPassed.clientKey)
        button.setTitle(clientPassed.firstName, for: .normal)

        
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
        startDate = dateFormatter.string(from: tempStartDay as Date)
        dateBtn.setTitle(startDate + " - " + endDate,for: .normal)
    }
    
    func setNewDate(dateStr:String){
        dateBtn.setTitle(dateStr, for: .normal)
        let datePassed = DateConverter.stringToDate(dateStr: dateStr) as NSDate
        displaySelectedWeek(date: datePassed as Date)
        DBService.shared.setCurrentWeekNumber(strWeek: String(DateConverter.weekNumFromDate(date: datePassed)))
        DBService.shared.setCurrentYearNumber(strYear: String(DateConverter.yearFromDate(date: datePassed)))
        
        DBService.shared.retrieveSessionsForClient{
            self.sessionsArray.removeAll()
            self.sessionsArray = DBService.shared.sessions
//            self.exerciseArray.sort(by: {a, b in
//                if a.date > b.date {
//                    return true
//                }
//                return false
//            })
            self.refreshTableViewData()
        }
    }
    
    @IBAction func createSession(_ sender: UIBarButtonItem) {
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        
        xPosition = self.view.frame.width/2
        yPosition = self.view.frame.minY + 60
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createSessionVC") as! CreateSessionViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 370)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
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
    
    func clickOnButton(button: UIButton) {
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        
        xPosition = self.view.frame.width/2
        yPosition = self.view.frame.minY + 60
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newClientVC") as! NewClientViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 500)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        popController.setClient(client: clientPassed)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func refreshTableViewData(){
        self.daysSections = self.groupSessionsByDay(sessionsPassed: self.sessionsArray) as! [String : Any]
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
        var tempArray = [Session]()
        
        switch(section){
        case 0:
            if daysSections["Sunday"] != nil{
                tempArray = daysSections["Sunday"] as! [Session]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Sunday"
                }
            }
        case 1:
            if daysSections["Monday"] != nil{
                tempArray = daysSections["Monday"] as! [Session]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Monday"
                }
            }
        case 2:
            if daysSections["Tuesday"] != nil{
                tempArray = daysSections["Tuesday"] as! [Session]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Tuesday"
                }
            }
            
        case 3:
            if daysSections["Wednesday"] != nil{
                tempArray = daysSections["Wednesday"] as! [Session]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Wednesday"
                }
            }
        case 4:
            if daysSections["Thursday"] != nil{
                tempArray = daysSections["Thursday"] as! [Session]
                if tempArray.count == 0{
                    
                }else{
                    sectionTitle = "Thursday"
                }
            }
        case 5:
            if daysSections["Friday"] != nil{
                tempArray = daysSections["Friday"] as! [Session]
                if tempArray.count == 0{
                }else{
                    sectionTitle = "Friday"
                }
            }
        case 6:
            if daysSections["Saturday"] != nil{
                tempArray = daysSections["Saturday"] as! [Session]
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
    
    func getSessionsForDayAtIndexPath(indexPath:NSIndexPath) -> [Session]{
        var array = [Session]()
        
        switch(indexPath.section){
        case 0:
            array = daysSections["Sunday"] as! [Session]
        case 1:
            array = daysSections["Monday"] as! [Session]
        case 2:
            array = daysSections["Tuesday"] as! [Session]
        case 3:
            array = daysSections["Wednesday"] as! [Session]
        case 4:
            array = daysSections["Thursday"] as! [Session]
        case 5:
            array = daysSections["Friday"] as! [Session]
        case 6:
            array = daysSections["Saturday"] as! [Session]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) as! SessionCustomCell
        
        var tempArr = getSessionsForDayAtIndexPath(indexPath: indexPath as NSIndexPath)
        tempArr = tempArr.sorted(by: {a, b in
            if Int(a.sessionNumber)! > Int(b.sessionNumber)! {
                return false
            }
                return true
            })
        if tempArr.count != 0{
            let session = tempArr[indexPath.row]
           
            if session.paid == false{
                cell.paidOutlet.text = "✗"
            cell.paidOutlet.textColor = UIColor.red
            }else{
                cell.paidOutlet.text = "✓"
                cell.paidOutlet.textColor = UIColor(red: 0, green: 131, blue: 0, alpha: 1)
            }
            
            cell.number.text = String(indexPath.row + 1)
            cell.setSessionKey(key: session.key)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var array = [Session]()
        
        switch(indexPath.section){
        case 0:
            array = daysSections["Sunday"] as! [Session]
        case 1:
            array = daysSections["Monday"] as! [Session]
        case 2:
            array = daysSections["Tuesday"] as! [Session]
        case 3:
            array = daysSections["Wednesday"] as! [Session]
        case 4:
            array = daysSections["Thursday"] as! [Session]
        case 5:
            array = daysSections["Friday"] as! [Session]
        case 6:
            array = daysSections["Saturday"] as! [Session]
        default:
            array = []
        }
        
        let selectedSession = array[indexPath.row]
        
        if editingStyle == .delete {
            let deleteAlert = UIAlertController(title: "Delete this entry?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                DBService.shared.deleteSessionForClient(session: selectedSession, completion: {
                    for i in 0...self.sessionsArray.count{
                        if self.sessionsArray[i].key == selectedSession.key{
                            self.sessionsArray.remove(at: i)
                            break
                        }
                    }
                    self.daysSections = self.groupSessionsByDay(sessionsPassed: self.sessionsArray) as! [String : Any]
                    
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    tableView.reloadData()
                })
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    func groupSessionsByDay(sessionsPassed:[Session])-> NSDictionary{
        var dict = [String:[Session]]()
        let sunday = [Session]()
        let monday = [Session]()
        let tuesday = [Session]()
        let wednesday = [Session]()
        let thursday = [Session]()
        let friday = [Session]()
        let saturday = [Session]()
        
        dict["Sunday"] = sunday
        dict["Monday"] = monday
        dict["Tuesday"] = tuesday
        dict["Wednesday"] = wednesday
        dict["Thursday"] = thursday
        dict["Friday"] = friday
        dict["Saturday"] = saturday
        
        for session in sessionsPassed{
            let dayName = session.day
            var temp:[Session]{
                get{
                    return dict[dayName]!
                }
                set(newValue){
                    dict[dayName] = newValue
                }
            }
            temp.append(session)
        }
        return dict as NSDictionary
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "sessionDetailSegue"){
            DBService.shared.setPassedClient(client: clientPassed)
            DBService.shared.setDateRange(dateRange:(dateBtn.titleLabel?.text)!)
            let selectedIndexPath = tableViewOutlet.indexPathForSelectedRow
            let cell = tableViewOutlet.cellForRow(at: selectedIndexPath!) as! SessionCustomCell
            print(cell.sessionKey)
            for i in 0...self.sessionsArray.count{
                if self.sessionsArray[i].key == cell.sessionKey{
                    print(sessionsArray[i])
                    DBService.shared.setPassedSession(session: sessionsArray[i])
                    break
                }
            }
        }
    }
}
