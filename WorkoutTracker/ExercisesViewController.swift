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

protocol ExercisesDelegate{
    func saveExercises(_ workout:Workout)
}

class ExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //var workout = Workout()
    var selectedRow:Int = 0
    var delegate:ExercisesDelegate!
    var client = Client()
    var exerciseArray = [Exercise]()
    var ref:FIRDatabaseReference!
    var tempKey:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        //retrieveClientID(clientObj: client)
        title = client.firstName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveClientID(clientObj: client)
        
    }
    
    //Receiving exercises and adding them to Exercises View Controller
    
    func retrieveExercisesForClient(){
        exerciseArray.removeAll()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Clients").child(tempKey).child("Exercises").observeSingleEvent(of: .value, with: { (snapshot) in
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
                    
                    self.exerciseArray.append(tempExercise)
                    
                }
            }
            self.tableViewOutlet.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveClientID(clientObj:Client){
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Clients").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // let value = snapshot.value as! NSDictionary
            if let clientsVal = snapshot.value as? [String: [String: AnyObject]] {
                for client in clientsVal {
                    if client.value["lastName"] as! String == clientObj.lastName && client.value["age"] as! String == clientObj.age{
                        self.tempKey = client.key
                        self.retrieveExercisesForClient()
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
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
            exerciseArray.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            //delegate.saveExercises(workout)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editExerciseSegue"){
            let wivc:WorkoutInputViewController = segue.destination as! WorkoutInputViewController
            wivc.setClient(client: client)
            selectedRow = (tableViewOutlet.indexPathForSelectedRow! as NSIndexPath).row
            wivc.setExercise(exercise: exerciseArray[selectedRow])
            wivc.edit = true
        }
        if(segue.identifier == "addExerciseSegue"){
            let edv:WorkoutInputViewController = segue.destination as! WorkoutInputViewController
            edv.setClient(client: client)
            edv.edit = false
        }
    }
}
