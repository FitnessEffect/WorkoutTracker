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
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crossfitWorkouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x = (indexPath as NSIndexPath).row
        
        
        if x == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell1", for: indexPath)

        let exercise = crossfitWorkouts[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = exercise
        cell.backgroundColor = UIColor.clear
        
            return cell
            
        }else if x == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell2", for: indexPath)
            
            let exercise = crossfitWorkouts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else if x == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell3", for: indexPath)
            
            let exercise = crossfitWorkouts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else if x == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell4", for: indexPath)
            
            let exercise = crossfitWorkouts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell5", for: indexPath)
            
            let exercise = crossfitWorkouts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
}
