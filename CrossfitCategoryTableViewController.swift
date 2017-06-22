//
//  CrossfitWorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/14/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
// This tableView Controller displays a list of crossfit workouts

import UIKit
import Firebase

class CrossfitCategoryTableViewController: UITableViewController {
    
    var categories = [String]()
    var typePassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePassed = "Crossfit"
        title = typePassed
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day Demo", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveCrossfitCategories(completion: {
            self.categories = DBService.shared.crossfitCategories
            self.tableView.reloadData()
        })
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            cellClicked(x: sender.location(in: view))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x = (indexPath as NSIndexPath).row
        
        if x == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell1", for: indexPath)
            let exercise = categories[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
        }else if x == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell2", for: indexPath)
            let exercise = categories[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
        }else if x == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell3", for: indexPath)
            let exercise = categories[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
        }else if x == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell4", for: indexPath)
            let exercise = categories[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossfitCell5", for: indexPath)
            let exercise = categories[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func cellClicked(x:CGPoint){
        let index = tableView.indexPathForRow(at: x)
        let cell = tableView.cellForRow(at: index!)!
        
        if cell.textLabel?.text == "1 Rep Max" || cell.textLabel?.text == "Wods"{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wodsVC") as! WodsViewController
            let title = cell.textLabel?.text
            DBService.shared.setCategory(category: title!)
            nextVC.setCategory(category:title!)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if cell.textLabel?.text == "Tabata"{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabataVC") as! TabataViewController
            let title = cell.textLabel?.text
            DBService.shared.setCategory(category: title!)
            nextVC.setCategory(category:title!)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if cell.textLabel?.text == "Metcon"{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "metconVC") as! MetconViewController
            let title = cell.textLabel?.text
            DBService.shared.setCategory(category: title!)
            nextVC.setCategory(category:title!)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "amrapVC") as! AmrapViewController
            let title = cell.textLabel?.text
            DBService.shared.setCategory(category: title!)
            nextVC.setCategory(category:title!)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
