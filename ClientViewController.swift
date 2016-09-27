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
    
    func saveWorkouts(_ client:Client){
        clientArray[selectedRow] = client
        saveClients()
    }
    
    func saveWorkoutFromExercise(_ client:Client){
        saveWorkouts(client)
    }
    
    //Save clients to file
    func saveClients(){
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        let path: AnyObject = paths[0] as AnyObject
        let arrPath = path.appending("/clients.plist")
        
        print(path)
        NSKeyedArchiver.archiveRootObject(clientArray, toFile: arrPath)
    }
    
    //Retrieve clients from file
    func retrieveClients(){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        let path: AnyObject = paths[0] as AnyObject
        let arrPath = path.appending("/clients.plist")
        
       clientArray = [Client]()
        
        if let tempArr: [Client] = NSKeyedUnarchiver.unarchiveObject(withFile: arrPath) as? [Client] {
            clientArray = tempArr
        }
    }
    
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "NewClientSegue"){
          
            let ncv:NewClientViewController = segue.destination as! NewClientViewController
            ncv.delegate = self
        }
        
        if(segue.identifier == "workoutsSegue"){
            let wvc:WorkoutsViewController = segue.destination as! WorkoutsViewController
            wvc.delegate = self
            selectedRow = (tableViewOutlet.indexPathForSelectedRow! as NSIndexPath).row
            wvc.client = clientArray[selectedRow]
        }
    }

    //add created client from NewClientViewController
     func addClient(_ client:Client){
        clientArray.append(client)
        saveClients()
        tableViewOutlet.reloadData()
    }
    
    //TableView
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientArray.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientCustomCell
        
        let client = clientArray[(indexPath as NSIndexPath).row]
        
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
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            clientArray.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            saveClients()
        }
    }
}
