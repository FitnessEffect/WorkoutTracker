//
//  ClientViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/4/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  The ClientViewController is responsible for displaying the clients in the
//  tableView and for saving the workouts and exercises for the respective
//  client to a file

import UIKit

class ClientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, createClientDelegate, WorkoutsDelegate{
    
    var clientArray:[Client] = []
    var clientKey:String = "clients"
    var selectedRow:Int = 0
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveClients()
        tableViewOutlet.reloadData()
    }
    
    func saveWorkouts(client:Client){
        clientArray[selectedRow] = client
        saveClients()
    }
    
    func saveWorkoutFromExercise(client:Client){
        saveWorkouts(client)
    }
    
    //Save clients to file
    func saveClients(){
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
        let path: AnyObject = paths[0]
        let arrPath = path.stringByAppendingString("/clients.plist")
        
        print(path)
        NSKeyedArchiver.archiveRootObject(clientArray, toFile: arrPath)
    }
    
    //Retrieve clients from file
    func retrieveClients(){
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
        let path: AnyObject = paths[0]
        let arrPath = path.stringByAppendingString("/clients.plist")
        
       clientArray = [Client]()
        
        if let tempArr: [Client] = NSKeyedUnarchiver.unarchiveObjectWithFile(arrPath) as? [Client] {
            clientArray = tempArr
        }
    }
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "NewClientSegue"){
          
            let ncv:NewClientViewController = segue.destinationViewController as! NewClientViewController
            ncv.delegate = self
        }
        
        if(segue.identifier == "workoutsSegue"){
            let wvc:WorkoutsViewController = segue.destinationViewController as! WorkoutsViewController
            wvc.delegate = self
            selectedRow = tableViewOutlet.indexPathForSelectedRow!.row
            wvc.client = clientArray[selectedRow]
        }
    }

    //add created client from NewClientViewController
     func addClient(client:Client){
        clientArray.append(client)
        saveClients()
        tableViewOutlet.reloadData()
    }
    
    //TableView
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientArray.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClientCell", forIndexPath: indexPath) as! ClientCustomCell
        
        let client = clientArray[indexPath.row]
        
       // var myMutableString = NSMutableAttributedString()
//        let ln:String = client.lastName
//        let att = [NSFontAttributeName : UIFont.boldSystemFontOfSize(15)]
//        
//        let boldName = NSMutableAttributedString(string:ln, attributes:att)
       // let stringLength = NSString(string: ln).length
//        myMutableString = NSMutableAttributedString(
//            string: ln)
        
//        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Optima-Bold", size: 10.0)!, range: NSRange(location:0, length: stringLength))
        
        cell.nameOutlet.text = client.firstName + " " + client.lastName
        cell.ageOutlet?.text = client.age
        
        if client.gender == "Male" {
            cell.nameOutlet.textColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }else if client.gender == "Female" {
            cell.nameOutlet.textColor = UIColor(red: 255.0/255.0, green: 140.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        
        return cell
    }
    
    //Allows client cells to be deleted
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            clientArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            saveClients()
        }
    }
}
