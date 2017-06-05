//
//  BodybuildingBodyPartsTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/9/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  This controller provides a list of bodyParts

import UIKit
import Firebase

class BodybuildingCategoryTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate{

    var categories = [String]()
    var user:FIRUser!
    var ref:FIRDatabaseReference!
    var typePassed:String!
    
        //["Arms", "Chest", "Back", "Abs", "Legs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePassed = "Bodybuilding"
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BodybuildingCategoryTableViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        self.navigationItem.rightBarButtonItem = rightBarButton
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Types").child("Bodybuilding").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value != nil{
                let keyArray = value?.allKeys as! [String]
                self.categories = keyArray
                self.categories.sort()
                self.tableView.reloadData()
            }
            // self.exerciseType.insert("Personal", at: 0)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){

        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createCategoryID") as! CreateBodybuildingCategoryViewController
        popController.typePassed = "Bodybuilding"
        self.navigationController?.pushViewController(popController, animated: true)
        
        // present the popover
        //self.present(popController, animated: true, completion: nil)
        
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
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = self.categories[indexPath.row]
        cell.tag = indexPath.row
        
        return cell
    }
    
    func setType(type:String){
        typePassed = type
    }
    
    func cellClicked(x:CGPoint){
        let index = tableView.indexPathForRow(at: x)
        let cell = tableView.cellForRow(at: index!)!
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bodybuildingSelectionVC") as! BodybuildingSelectionViewController
        let title = cell.textLabel?.text
        nextVC.setCategory(category:title!)
        self.navigationController?.pushViewController(nextVC, animated: true)

    }
}
