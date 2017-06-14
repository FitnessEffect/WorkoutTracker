//
//  ExercisesViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  The ExerciseViewController is responsible for displaying exercises in the
//  tableView



import UIKit
import Firebase

class ExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var selectedRow:Int = 0
    var clientPassed = Client()
    var exerciseArray = [Exercise]()
    var ref:FIRDatabaseReference!
    var tempKey:String!
    var user:FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        title = clientPassed.firstName        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DKCoolCrayon", size: 24)!,NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveExercisesForClient(completion: {
        self.exerciseArray = DBService.shared.exercisesForClient
        self.tableViewOutlet.reloadData()
        })
        
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
                
                DBService.shared.deleteExerciseForClient(id:id)

            self.exerciseArray.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion:nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editExerciseSegue"){
            let wivc:WorkoutInputViewController = segue.destination as! WorkoutInputViewController
            DBService.shared.setPassedClient(client: clientPassed)
            selectedRow = (tableViewOutlet.indexPathForSelectedRow! as NSIndexPath).row
            DBService.shared.setPassedExercise(exercise: exerciseArray[selectedRow])
            wivc.edit = true
        }
        if(segue.identifier == "addExerciseSegue"){
            let edv:WorkoutInputViewController = segue.destination as! WorkoutInputViewController
            DBService.shared.setPassedClient(client: clientPassed)
            edv.edit = false
        }
    }
}
