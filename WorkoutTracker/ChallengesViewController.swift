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
    @IBOutlet weak var noChallengesLabel: UILabel!
    
    var selectedRow:Int = 0
    var client = Client()
    var exerciseArray = [Exercise]()
    var tempKey:String!
    var menuShowing = false
    var menuView:MenuView!
    var overlayView: OverlayView!
    var selectedDate = NSDate()
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenges"
        noChallengesLabel.alpha = 0
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 30)!,NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let tableViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnTableView(_:)))
        tableViewOutlet.addGestureRecognizer(tableViewTapGesture)
        
        let menuTapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(menuTapGesture)
        
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
        
        spinner.frame = CGRect(x:(self.tableViewOutlet.frame.width/2)-25, y:(self.tableViewOutlet.frame.height/2)-25, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor.white
        spinner.alpha = 0
        view.addSubview(spinner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set app icon badge number to 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.resetBadgeNumber()
        
        DBService.shared.setChallengesToViewed()
        DBService.shared.resetNotificationCount()
        
        //notification center emits message to reset and hide challenge notification number
        NotificationCenter.default.post(name: Notification.Name(rawValue: "hideNotif"), object: nil, userInfo: nil)
        let internetCheck = Reachability.isInternetAvailable()
        if internetCheck == false{
            let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            spinner.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            //download challenges from firebase on seperate thread
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveChallengesExercises {
                    UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                    self.spinner.stopAnimating()
                    self.exerciseArray = DBService.shared.challengeExercises
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
                    self.tableViewOutlet.reloadData()
                    if self.exerciseArray.count == 0{
                        self.noChallengesLabel.alpha = 1
                    }else{
                        self.noChallengesLabel.alpha = 0
                    }
                }
            }
        }
    }
    
    //Animates menu appearing and disappearing from screen
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
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
    
    //tap gesture recognizer for tableView
    func didTapOnTableView(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: tableViewOutlet)
        let row = tableViewOutlet.indexPathForRow(at: touchPoint)?.row
        if row != nil{
            performSegue(withIdentifier: "editChallengeSegue", sender: sender)
        }
    }
    
    //tap gesture to exit menu
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
            let deleteAlert = UIAlertController(title: "Delete Challenge?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let ex = self.exerciseArray[indexPath.row]
                
                //update firebase with deletion
                DBService.shared.deleteChallengeExerciseForUser(exercise:ex)
                
                self.exerciseArray.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
                if self.exerciseArray.count == 0{
                    self.noChallengesLabel.alpha = 1
                }else{
                    self.noChallengesLabel.alpha = 0
                }
                
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion:nil)
        }
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
