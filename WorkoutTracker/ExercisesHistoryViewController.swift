//
//  ExercisesHistoryViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/20/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ExercisesHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var notificationNumber: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var selectedRow:Int = 0
    var client = Client()
    var exerciseArray = [Exercise]()
    var ref:FIRDatabaseReference!
    var tempKey:String!
    var menuShowing = false
    var menuView:MenuView!
    var overlayView: OverlayView!
    var user:FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        title = "History"
        
        NotificationCenter.default.addObserver(self, selector:#selector(ExercisesHistoryViewController.appEnteredForeground(_:)), name: NSNotification.Name(rawValue: "appEnteredForegroundKey"), object: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DKCoolCrayon", size: 24)!,NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
        
        notificationNumber.layer.cornerRadius = 10.0
        notificationNumber.clipsToBounds = true
        notificationNumber.layer.borderWidth = 1
        notificationNumber.layer.borderColor = UIColor.red.cgColor
        
        UIApplication.shared.keyWindow?.addSubview(notificationNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationNumber.alpha = 0
        }else{
            notificationNumber.alpha = 1
            notificationNumber.text = String(num)
        }
        DBService.shared.retrieveExercisesForUser {
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
    
    func appEnteredForeground(_ notification: Notification){
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationNumber.alpha = 0
        }else{
            notificationNumber.alpha = 1
            notificationNumber.text = String(num)
        }
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
        }else{
            if tableViewOutlet.frame.contains(sender.location(in: view)){
                performSegue(withIdentifier: "editExerciseSegue", sender: sender)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCustomCell
        let exercise = exerciseArray[(indexPath as NSIndexPath).row]
        cell.titleOutlet.text = exercise.name + " (" + exercise.result + ")"
        cell.descriptionOutlet.text = exercise.exerciseDescription
        cell.numberOutlet.text = String((indexPath as NSIndexPath).row + 1)
        return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this exercise?", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let x = indexPath.row
                let id = self.exerciseArray[x].exerciseKey
                
                DBService.shared.deleteExerciseForUser(id: id)
                
                self.exerciseArray.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editExerciseSegue"){
            let s = sender as! UITapGestureRecognizer
            let wivc:WorkoutInputViewController = segue.destination as! WorkoutInputViewController
            let selectedRow = tableViewOutlet.indexPathForRow(at:s.location(in: tableViewOutlet))?.row
            DBService.shared.setPassedExercise(exercise: exerciseArray[selectedRow!])
            wivc.setEdit(bool: true)
        }
        if(segue.identifier == "addExerciseSegue"){
            let edv:WorkoutInputViewController = segue.destination as! WorkoutInputViewController
            DBService.shared.setPassedClient(client: client)
            edv.setEdit(bool: false)
        }
    }
}
