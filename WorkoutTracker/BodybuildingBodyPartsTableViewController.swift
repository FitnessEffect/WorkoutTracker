//
//  BodybuildingBodyPartsTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  This controller provides a list of bodyParts

import UIKit

class BodybuildingBodyPartsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate{

    let bodyParts = ["Arms", "Chest", "Back", "Abs", "Legs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BodybuildingBodyPartsTableViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){

        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createCategoryID") as! CreateBodybuildingCategoryViewController
        self.navigationController?.pushViewController(popController, animated: true)
        
        // present the popover
        //self.present(popController, animated: true, completion: nil)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodyParts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x = (indexPath as NSIndexPath).row
        
        if x == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArmsCell", for: indexPath)
            
            let exercise = bodyParts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            
            return cell
            
        }else if x == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChestCell", for: indexPath)
            
            let exercise = bodyParts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else if x == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BackCell", for: indexPath)
            
            let exercise = bodyParts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else if x == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AbsCell", for: indexPath)
            
            let exercise = bodyParts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LegsCell", for: indexPath)
            
            let exercise = bodyParts[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = exercise
            cell.backgroundColor = UIColor.clear
            return cell
            
        }
    }
}
