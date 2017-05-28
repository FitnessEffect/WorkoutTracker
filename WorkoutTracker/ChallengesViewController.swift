//
//  ChallengesViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/27/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ChallengesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var selectedRow:Int = 0
    var delegate:ExercisesDelegate!
    var client = Client()
    var exerciseArray = [Exercise]()
    var ref:FIRDatabaseReference!
    var tempKey:String!
    var menuShowing = false
    var menuView:MenuView!
    var overlayView: OverlayView!

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        //retrieveClientID(clientObj: client)
        title = "Challenges"
        
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
        retrieveExercises()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func retrieveExercises(){
        exerciseArray.removeAll()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Challenges").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // let value = snapshot.value as! NSDictionary
            if let exercisesVal = snapshot.value as? [String: [String: AnyObject]] {
                for exercise in exercisesVal {
                    
                    let tempExercise = Exercise()
                    tempExercise.name = exercise.value["name"] as! String
                    tempExercise.exerciseDescription = exercise.value["description"] as! String
                    tempExercise.result = exercise.value["result"] as! String
                    tempExercise.exerciseKey = exercise.value["exerciseKey"] as! String
                    tempExercise.date = exercise.value["date"] as! String
                    tempExercise.creator = exercise.value["challenger"] as! String
                    self.exerciseArray.append(tempExercise)
                    
                }
            }
            self.tableViewOutlet.reloadData()
        }) { (error) in
            print(error.localizedDescription)
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
        menuView.profileBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.clientBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.historyBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.challengeBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.settingsBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.logoutBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
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
                performSegue(withIdentifier: "editChallengeSegue", sender: sender)
            }
        }
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ChallengeCustomCell
        
        let exercise = exerciseArray[(indexPath as NSIndexPath).row]
        cell.titleOutlet.text = exercise.name + " (" + exercise.result + ")"
        cell.challenger.text = exercise.creator
        cell.numberOutlet.text = String((indexPath as NSIndexPath).row + 1)
        return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            exerciseArray.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            //delegate.saveExercises(workout)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editChallengeSegue"){
            let s = sender as! UITapGestureRecognizer
            let wivc:WorkoutInputViewController = segue.destination as! WorkoutInputViewController
            let selectedRow = tableViewOutlet.indexPathForRow(at:s.location(in: tableViewOutlet))?.row
            wivc.setExercise(exercise: exerciseArray[selectedRow!])
            wivc.edit = true
        }
    }
}
