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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector (self.swipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        arrowLabel1.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        arrowLabel2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        arrowLabel3.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.dateOutlet.text = self.dataValues[indexPath.row].key
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteAlert = UIAlertController(title: "Delete Client?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
//                let x = indexPath.row
//                let id = self.clientArray[x].clientKey
//                DBService.shared.deleteClient(id: id)
//                self.clientArray.remove(at: (indexPath as NSIndexPath).row)
//                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//                if self.clientArray.count == 0{
//                    self.noClientsLabel.alpha = 1
//                }else{
//                    self.noClientsLabel.alpha = 0
//                }
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    @objc func swipe(_ sender:UISwipeGestureRecognizer){
        
        if sender.direction == .left{
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    func passDataValues(passedData:[(key: String, value: String)]){
        dataValues = passedData
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
