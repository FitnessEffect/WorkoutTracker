//
//  CrossfitWorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/14/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// This tableView Controller displays a list of crossfit workouts

import UIKit

class CrossfitWorkoutTableViewController: UITableViewController {
    
    let crossfitWorkouts = ["1RM", "Amrap", "Metcon", "Tabata", "Wods"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crossfitWorkouts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let x = indexPath.row
        
        if x == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("crossfitCell1", forIndexPath: indexPath)

        let exercise = crossfitWorkouts[indexPath.row]
        cell.textLabel?.text = exercise

        return cell
            
        }else if x == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("crossfitCell2", forIndexPath: indexPath)
            
            let exercise = crossfitWorkouts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
            
        }else if x == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("crossfitCell3", forIndexPath: indexPath)
            
            let exercise = crossfitWorkouts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
            
        }else if x == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier("crossfitCell4", forIndexPath: indexPath)
            
            let exercise = crossfitWorkouts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("crossfitCell5", forIndexPath: indexPath)
            
            let exercise = crossfitWorkouts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
        }
    }
}