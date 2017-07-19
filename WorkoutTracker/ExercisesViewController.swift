//
//  ExercisesViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/3/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//
//  The ExerciseViewController is responsible for displaying exercises in the
//  tableView

import UIKit
import Firebase

class ExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var selectedRow:Int = 0
    var clientPassed = Client()
    var exerciseArray = [Exercise]()
    var ref:FIRDatabaseReference!
    var tempKey:String!
    var user:FIRUser!
    var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 30)!,NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        button.titleLabel!.font =  UIFont(name: "DJB Chalk It Up", size: 30)
        button.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
        button.setTitle(clientPassed.firstName, for: .normal)
        button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
        self.navigationItem.titleView = button
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DBService.shared.retrieveExercisesForClient(completion: {
            self.exerciseArray = DBService.shared.exercisesForClient
            self.tableViewOutlet.reloadData()
        })
        clientPassed = DBService.shared.retrieveClientInfo(lastName: clientPassed.lastName)
    }
    
    func clickOnButton(button: UIButton) {
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        
        xPosition = self.view.frame.width/2
        yPosition = self.view.frame.minY + 60
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newClientVC") as! NewClientViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 500)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        popController.setClient(client: clientPassed)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCustomCell
        let exercise = exerciseArray[(indexPath as NSIndexPath).row]
        cell.titleOutlet.text = exercise.name + " (" + exercise.result + ")"
        cell.dateOutlet.text = exercise.date
        cell.numberOutlet.text = String((indexPath as NSIndexPath).row + 1)
        return cell
    }
    
    //Allows exercise cell to be deleted
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this exercise?", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let x = indexPath.row
                let id = self.exerciseArray[x].exerciseKey
                DBService.shared.deleteExerciseForClient(id:id)
                self.exerciseArray.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.reloadData()
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(deleteAlert, animated: true, completion:nil)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editExerciseSegue"){
            let wivc:InputExerciseViewController = segue.destination as! InputExerciseViewController
            DBService.shared.setPassedClient(client: clientPassed)
            selectedRow = (tableViewOutlet.indexPathForSelectedRow! as NSIndexPath).row
            DBService.shared.setPassedExercise(exercise: exerciseArray[selectedRow])
            wivc.setEdit(bool:true)
        }
        if(segue.identifier == "addExerciseSegue"){
            let edv:InputExerciseViewController = segue.destination as! InputExerciseViewController
            DBService.shared.setPassedClient(client: clientPassed)
            edv.setEdit(bool:false)
        }
    }
}
