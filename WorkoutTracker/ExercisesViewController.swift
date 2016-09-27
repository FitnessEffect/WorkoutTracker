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
    func saveExercises(_ workout:Workout)
}

class ExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateExerciseDelegate, ExerciseResultDelegate {

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var workout = Workout()
    var selectedRow:Int = 0
    var delegate:ExercisesDelegate!
    
    override func viewDidLoad() {
        title = workout.name
        NotificationCenter.default.addObserver(self, selector: #selector(ExercisesViewController.getExercise), name: NSNotification.Name(rawValue: "getExerciseID"), object: nil)
        super.viewDidLoad()
    }
    
    //Receiving exercises and adding them to Exercises View Controller
    func getExercise(_ notification: Notification){
        let info:[String:Exercise] = (notification as NSNotification).userInfo as! [String:Exercise]
        let myExercise = info["exerciseKey"]
        addExercise(myExercise!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCustomCell
        
       let exercise = workout.exerciseArray[(indexPath as NSIndexPath).row]
       cell.titleOutlet.text = exercise.name + " (" + exercise.result + ")"
       cell.descriptionOutlet.text = exercise.exerciseDescription
        cell.numberOutlet.text = String((indexPath as NSIndexPath).row + 1)
       return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            workout.exerciseArray.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            delegate.saveExercises(workout)
        }
    }
    
    //Add exercise to workout and saves to file
    func addExercise(_ exercise:Exercise){
        workout.exerciseArray.append(exercise)
        delegate.saveExercises(workout)
        tableViewOutlet.reloadData()
    }
    
    //Saves the result from the ExerciseDetailViewController
    func passExercise(_ exercise:Exercise){
        workout.exerciseArray[selectedRow] = exercise
        delegate.saveExercises(workout)
        tableViewOutlet.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailExerciseSegue"){
            let edv:ExerciseDetailViewController = segue.destination as! ExerciseDetailViewController
            edv.delegate = self
            
            selectedRow = (tableViewOutlet.indexPathForSelectedRow! as NSIndexPath).row
            edv.exercise = workout.exerciseArray[selectedRow]
        }
    }
}
