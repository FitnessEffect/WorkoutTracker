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
    func saveWorkoutFromExercise(client:Client)
}

class WorkoutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,createWorkoutDelegate, ExercisesDelegate{
    
    var client = Client()
    var selectedRow:Int = 0

    @IBOutlet weak var tableViewOutlet: UITableView!
    var delegate:WorkoutsDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = client.firstName 
        tableViewOutlet.reloadData()
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return client.workoutArray.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutCell", forIndexPath: indexPath)
        
        let workout = client.workoutArray[indexPath.row]
        cell.textLabel?.text = workout.name
        cell.detailTextLabel?.text = workout.date
        return cell
    }
    
    //adds new workout from WorkoutNameViewController
    func addWorkout(workout:Workout){
        
        client.workoutArray.append(workout)
        delegate.saveWorkoutFromExercise(client)
        tableViewOutlet.reloadData()
    }
    
    //saves new Exercises from ExercisesViewController
    func saveExercises(workout:Workout){
       
        client.workoutArray[selectedRow] = workout
        delegate.saveWorkoutFromExercise(client)
        tableViewOutlet.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "newWorkoutSegue"){
            
            let ncv:WorkoutNameViewController = segue.destinationViewController as! WorkoutNameViewController
            ncv.delegate = self
        }
        if(segue.identifier == "exercisesSegue"){
            
            selectedRow = tableViewOutlet.indexPathForSelectedRow!.row
            let evc:ExercisesViewController = segue.destinationViewController as! ExercisesViewController
            evc.delegate = self
            evc.workout = client.workoutArray[selectedRow]
        }
    }
    
    //Allows workout cells to be deleted
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            client.workoutArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            delegate.saveWorkoutFromExercise(client)
        }
    }
}