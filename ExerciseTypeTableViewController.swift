//
//  ExerciseTypeTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/14/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit

class ExerciseTypeTableViewController: UITableViewController{

    let exerciseType = ["Bodybuilding", "Crossfit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseType.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let x = indexPath.row
        
        if x == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("BodybuildingCell", forIndexPath: indexPath)
        
        let exercise = exerciseType[indexPath.row]
        cell.textLabel?.text = exercise
        cell.backgroundColor = UIColor.clearColor()            
        return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("CrossfitCell", forIndexPath: indexPath)
            
            let exercise = exerciseType[indexPath.row]
            cell.textLabel?.text = exercise
            
            return cell
        }
    }
}
