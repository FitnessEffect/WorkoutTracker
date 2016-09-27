//
//  WorkoutsViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  The WorkoutsViewController is responsible for displaying the Workouts in 
//  the tableView

import UIKit

protocol WorkoutsDelegate{
    func saveWorkoutFromExercise(_ client:Client)
}

class WorkoutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,createWorkoutDelegate, ExercisesDelegate{
    
    var workoutCount:Int = 0
    var client = Client()
    var selectedRow:Int = 0
    var delegate:WorkoutsDelegate!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = client.firstName 
        tableViewOutlet.reloadData()
    }
    
    //TableView
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return client.workoutArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutCustomCell
        
        let workout = client.workoutArray[(indexPath as NSIndexPath).row]
       
        cell.nameOutlet.text = workout.name
        cell.dateOutlet.text = workout.date
        workoutCount = ((indexPath as NSIndexPath).row + 1)
        cell.numberOutlet.text = String(workoutCount)
        
        if workout.type == "Crossfit" {
            cell.imageOutlet.image = UIImage(named: "Kettlebell.png")
            cell.nameOutlet.textColor = UIColor(red: 200.0/255.0, green: 170.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }else if workout.type == "Bodybuilding" {
            cell.imageOutlet.image = UIImage(named: "Dumbbell.png")
            cell.nameOutlet.textColor = UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        return cell
    }

    //Adds new workout created in WorkoutNameViewControllers to WorkoutsViewController and saves it.
    func addWorkout(_ workout:Workout){
        
        client.workoutArray.append(workout)
        delegate.saveWorkoutFromExercise(client)
        tableViewOutlet.reloadData()
    }
    
    //Saves new Exercises from ExercisesViewController
    func saveExercises(_ workout:Workout){
       
        client.workoutArray[selectedRow] = workout
        delegate.saveWorkoutFromExercise(client)
        tableViewOutlet.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "newWorkoutSegue"){
            
            let ncv:WorkoutNameViewController = segue.destination as! WorkoutNameViewController
            ncv.delegate = self
        }
        if(segue.identifier == "exercisesSegue"){
            
            selectedRow = (tableViewOutlet.indexPathForSelectedRow! as NSIndexPath).row
            let evc:ExercisesViewController = segue.destination as! ExercisesViewController
            evc.delegate = self
            evc.workout = client.workoutArray[selectedRow]
        }
    }
    
    //Allows workout cells to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            client.workoutArray.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            delegate.saveWorkoutFromExercise(client)
        }
    }
}
