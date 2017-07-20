//
//  EnduranceCategoryTableViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/19/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class EnduranceCategoryTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var categories = [String]()
    var typePassed:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePassed = "Endurance"
        title = typePassed
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Have a Great Day", size: 22)!,NSForegroundColorAttributeName: UIColor.darkText]
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))
        self.tableView.backgroundView?.alpha = 0.1
        
        let rightBarButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EnduranceCategoryTableViewController.rightSideBarButtonItemTapped(_:)))
        rightBarButton.image = UIImage(named:"addIcon")
        rightBarButton.imageInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveEnduranceCategories(completion: {
            self.categories = DBService.shared.enduranceCategories
            self.tableView.reloadData()
        })
    }
    
    func rightSideBarButtonItemTapped(_ sender: UIBarButtonItem){
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createEnduranceCategoryID") as! CreateEnduranceCategoryViewController
        popController.typePassed = "Endurance"
        self.navigationController?.pushViewController(popController, animated: true)
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
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        return cell
    }
    
    func setType(type:String){
        typePassed = type
    }
    
    func cellClicked(x:CGPoint){
        let index = tableView.indexPathForRow(at: x)
        let cell = tableView.cellForRow(at: index!)!
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "enduranceSelectionVC") as! EnduranceSelectionViewController
        let title = cell.textLabel?.text
        DBService.shared.setCategory(category: title!)
        nextVC.setCategory(category:title!)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this category?", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let x = indexPath.row
                let id = self.categories[x]
                DBService.shared.deleteEnduranceCategory(category: id)
                self.categories.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
}
