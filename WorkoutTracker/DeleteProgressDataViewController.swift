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
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.dataValues[indexPath.row].key
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        cell.accessibilityIdentifier = "Type" + String(indexPath.row)
        
        return cell
    }
    
    @objc func swipe(_ sender:UISwipeGestureRecognizer){
        
        if sender.direction == .left{
        self.navigationController?.popViewController(animated: true)
        }
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
