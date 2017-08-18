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
    
    var exerciseTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.clearSupersetExercises()
        DBService.shared.retrieveTypes(completion: {
            self.exerciseTypes = DBService.shared.types
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.exerciseTypes[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        
        return cell
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        if tableView.frame.contains(sender.location(in: view)){
            cellClicked(x: sender.location(in: view))
        }
    }
    
    func cellClicked(x:CGPoint){
        let index = tableView.indexPathForRow(at: x)
        let cell = tableView.cellForRow(at: index!)!
        if cell.textLabel?.text == "Bodybuilding"{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bodybuildingCategoryVC") as! BodybuildingCategoryTableViewController
            DBService.shared.setPassedType(type: "Bodybuilding")
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if cell.textLabel?.text == "Crossfit"{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "crossfitVC") as! CrossfitCategoryTableViewController
            DBService.shared.setPassedType(type: "Crossfit")
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "enduranceCategoryVC") as! EnduranceCategoryTableViewController
            DBService.shared.setPassedType(type: "Endurance")
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
