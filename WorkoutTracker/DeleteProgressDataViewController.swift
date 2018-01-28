//
//  DeleteProgressDataViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 10/28/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class DeleteProgressDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var arrowLabel1: UILabel!
    @IBOutlet weak var arrowLabel2: UILabel!
    @IBOutlet weak var arrowLabel3: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataValues = [(key: String, value: String)]()
    var selection:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector (self.tapTableView(_:)))
        tableView.addGestureRecognizer(tap)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector (self.swipe(_:)))
        
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        arrowLabel1.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        arrowLabel2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        arrowLabel3.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as! ProgressDataCustomCell
        cell.weightOutlet.text = self.dataValues[indexPath.row].value
        let tempDate = self.dataValues[indexPath.row].key
        let tempDateArr = tempDate.components(separatedBy: " ")
        cell.dateOutlet.text = tempDateArr[0]
        cell.numberOutlet.text = String(indexPath.row + 1)
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deleteAlert = UIAlertController(title: "Delete \(dataValues[indexPath.row].value)?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let data = self.dataValues[indexPath.row]
                
                self.dataValues.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                if DBService.shared.passedClient.clientKey != ""{
                    DBService.shared.deleteProgressDataForClient(data:data, selection:self.selection)
                }else{
                    DBService.shared.deleteProgressDataForPersonal(data:data, selection:self.selection)
                }
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    @objc func tapTableView(_ sender:UITapGestureRecognizer){
        if tableView.indexPathForRow(at: sender.location(in: tableView)) != nil{
            tableView(tableView, commit: .delete, forRowAt: tableView.indexPathForRow(at: sender.location(in: tableView))!)
        }
    }
    
    @objc func swipe(_ sender:UISwipeGestureRecognizer){
        if sender.direction == .left{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func passSelection(passedSelection:String){
        selection = passedSelection
    }
    
    func passDataValues(passedData:[(key: String, value: String)]){
        dataValues = passedData
    }
}
