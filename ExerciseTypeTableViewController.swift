//
//  ExerciseTypeTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 4/14/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ExerciseTypeTableViewController: UITableViewController{

    var exerciseType = ["Bodybuilding", "Crossfit"]
    var user:FIRUser!
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let userID = FIRAuth.auth()?.currentUser?.uid
//        ref.child("users").child(userID!).child("Types").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            if value != nil{
//                let keyArray = value?.allKeys as! [String]
//                self.exerciseType = keyArray
//                self.tableView.reloadData()
//            }
//           // self.exerciseType.insert("Personal", at: 0)
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodybuildingCell", for: indexPath)
        //cell.textLabel?.font = UIFont(name: "BasicSharpie", size: 12)
        let exercise = exerciseType[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = exercise
        cell.backgroundColor = UIColor.clear
            
        return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CrossfitCell", for: indexPath)
            //cell.textLabel?.font = UIFont(name: "BasicSharpie", size: 12)
            let exercise = exerciseType[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "bodybuildingSegue"{
//            //let destinationVC = segue.destination as! BodybuildingCategoryTableViewController
//            //destinationVC.setType(type:"Bodybuilding")
//            //destinationVC.typePassed = "Bodybuilding"
//        }else if segue.identifier == "crossfitSegue"{
////            let destinationVC = segue.destination as! CrossfitCategoryTableViewController
////            destinationVC.setType(type:"Crossfit")
//        }
//    }
}
