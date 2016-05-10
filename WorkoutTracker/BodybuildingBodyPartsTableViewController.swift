//
//  BodybuildingBodyPartsTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  This controller provides a list of bodyParts

import UIKit

class BodybuildingBodyPartsTableViewController: UITableViewController {

    let bodyParts = ["Arms", "Chest", "Back", "Abs", "Legs", "Custom Workout"]
    
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
        return bodyParts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let x = indexPath.row
        
        if x == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ArmsCell", forIndexPath: indexPath)
            
            let exercise = bodyParts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
            
        }else if x == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("ChestCell", forIndexPath: indexPath)
            
            let exercise = bodyParts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
            
        }else if x == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("BackCell", forIndexPath: indexPath)
            
            let exercise = bodyParts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
            
        }else if x == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier("AbsCell", forIndexPath: indexPath)
            
            let exercise = bodyParts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
        }else if x == 4{
            let cell = tableView.dequeueReusableCellWithIdentifier("LegsCell", forIndexPath: indexPath)
            
            let exercise = bodyParts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("CustomWorkoutCell", forIndexPath: indexPath)
            
            let exercise = bodyParts[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
        }
    }
}