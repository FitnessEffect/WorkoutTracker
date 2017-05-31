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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let x = (indexPath as NSIndexPath).row
        
        if x == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodybuildingCell", for: indexPath)
        //cell.textLabel?.font = UIFont(name: "BasicSharpie", size: 12)
        let exercise = exerciseType[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = exercise
        cell.backgroundColor = UIColor.clear
            
        return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CrossfitCell", for: indexPath)
            
            let exercise = exerciseType[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise

            
            return cell
        }
    }
}
