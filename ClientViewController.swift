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
import Firebase

class ClientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, createClientDelegate{
    
    var clientArray:[Client] = []
    var clientKey:String = "clients"
    var selectedRow:Int = 0
    var ref:FIRDatabaseReference!
    var currentClient:Client!
    var menuView:MenuView!
    var overlayView: OverlayView!
    var challengeOverlay = true
    var menuShowing = false
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        tableViewOutlet.reloadData()

        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveClients()
        //tableViewOutlet.reloadData()
    }
    
    func saveWorkouts(_ client:Client){
        clientArray[selectedRow] = client
        //saveClients()
    }
    
    func saveWorkoutFromExercise(_ client:Client){
        saveWorkouts(client)
    }
    
    
    //Retrieve clients from file
    func retrieveClients(){
        clientArray.removeAll()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).child("Clients").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // let value = snapshot.value as! NSDictionary
            if let clientsVal = snapshot.value as? [String: [String: AnyObject]] {
                for client in clientsVal {
                    let tempClient = Client()
                    tempClient.age = client.value["age"] as! String
                    tempClient.firstName = client.value["firstName"] as! String
                    tempClient.lastName = client.value["lastName"] as! String
                    tempClient.gender = client.value["gender"] as! String
                    
                    self.clientArray.append(tempClient)

                }
            }
            self.tableViewOutlet.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //add created client from NewClientViewController
     func addClient(_ client:Client){
        clientArray.append(client)
        //saveClients()
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
            //saveClients()
        }
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        addSelector()
    }
    
    func addSelector() {
        //slide view in here
        if menuShowing == false{
            menuView.addFx()
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: 0, y: 0, width: 126, height: 500)
                self.view.isHidden = false
                self.overlayView.alpha = 1
            })
            menuShowing = true
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
                self.overlayView.alpha = 0
            })
            menuShowing = false
        }
        menuView.profileBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.clientBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.historyBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.challengeBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        menuView.settingsBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
    }
    
    func hitTest(_ sender:UITapGestureRecognizer){
        
        if menuShowing == true{
            //remove menu view
            
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
                self.overlayView.alpha = 0
            })
            menuShowing = false
            
        }else{
            performSegue(withIdentifier: "exercisesSegue", sender: sender)
            }
    }

    
    func btnAction(_ sender: UIButton) {
        if sender.tag == 1{
            
        }else if sender.tag == 2{
            let clientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clientNavID") as! UINavigationController
            self.present(clientVC, animated: true, completion: nil)
        }else if sender.tag == 3{
            let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyNavID") as! UINavigationController
            self.present(historyVC, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "NewClientSegue"){
            
            
            let ncv:NewClientViewController = segue.destination as! NewClientViewController
            ncv.delegate = self
        }
        
        if(segue.identifier == "exercisesSegue"){
            let s = sender as! UITapGestureRecognizer
            let evc:ExercisesViewController = segue.destination as! ExercisesViewController
             let selectedRow = tableViewOutlet.indexPathForRow(at:s.location(in: tableViewOutlet))?.row
            print(clientArray[selectedRow!])
            evc.client = clientArray[selectedRow!]
            
        }
    }

}
