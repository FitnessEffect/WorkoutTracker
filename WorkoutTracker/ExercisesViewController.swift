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

protocol ExercisesDelegate{
    func saveExercises(workout:Workout)
}

class ExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, createExerciseDelegate, ExerciseResultDelegate {

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var workout = Workout()
    var selectedRow:Int = 0
    var delegate:ExercisesDelegate!
    
    override func viewDidLoad() {
        title = workout.name
        super.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workout.exerciseArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath)
        
       let exercise = workout.exerciseArray[indexPath.row]
       cell.textLabel?.text = exercise.name
       cell.detailTextLabel?.text = exercise.exerciseDescription
       return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            workout.exerciseArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            delegate.saveExercises(workout)
        }
    }
    
    //Add exercise to workout and saves to file
    func addExercise(exercise:Exercise){
        workout.exerciseArray.append(exercise)
        delegate.saveExercises(workout)
        tableViewOutlet.reloadData()
    }
    
    //Saves the result from the ExerciseDetailViewController of the exercise
    func passExercise(exercise:Exercise){
        workout.exerciseArray[selectedRow] = exercise
        delegate.saveExercises(workout)
        tableViewOutlet.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "newExercisesSegue"){
            
            let ncv:NewExerciseViewController = segue.destinationViewController as! NewExerciseViewController
                ncv.delegate = self
        }
        if(segue.identifier == "detailExerciseSegue"){
            
            let edv:ExerciseDetailViewController = segue.destinationViewController as! ExerciseDetailViewController
            edv.delegate = self
            
           selectedRow = tableViewOutlet.indexPathForSelectedRow!.row
            edv.exercise = workout.exerciseArray[selectedRow]
            
        }
    
    }
}
