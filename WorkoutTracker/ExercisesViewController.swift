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

class ExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateExerciseDelegate, ExerciseResultDelegate {

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var workout = Workout()
    var selectedRow:Int = 0
    var delegate:ExercisesDelegate!
    
    override func viewDidLoad() {
        title = workout.name
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ExercisesViewController.getExercise), name: "getExerciseID", object: nil)
        super.viewDidLoad()
    }
    
    //Receiving exercises and adding them to Exercises View Controller
    func getExercise(notification: NSNotification){
        let info:[String:Exercise] = notification.userInfo as! [String:Exercise]
        let myExercise = info["exerciseKey"]
        addExercise(myExercise!)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.exerciseArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath) as! ExerciseCustomCell
        
       let exercise = workout.exerciseArray[indexPath.row]
       cell.titleOutlet.text = exercise.name + " (" + exercise.result + ")"
       cell.descriptionOutlet.text = exercise.exerciseDescription
        cell.numberOutlet.text = String(indexPath.row + 1)
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
    
    //Saves the result from the ExerciseDetailViewController
    func passExercise(exercise:Exercise){
        workout.exerciseArray[selectedRow] = exercise
        delegate.saveExercises(workout)
        tableViewOutlet.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailExerciseSegue"){
            let edv:ExerciseDetailViewController = segue.destinationViewController as! ExerciseDetailViewController
            edv.delegate = self
            
            selectedRow = tableViewOutlet.indexPathForSelectedRow!.row
            edv.exercise = workout.exerciseArray[selectedRow]
        }
    }
}
