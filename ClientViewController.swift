//
//  ClientViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 3/4/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class ClientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate{
    
    var clientArray:[Client] = []
    var clientKey:String = "clients"
    var selectedRow:Int = 0
    var currentClient:Client!
    var menuView:MenuView!
    var overlayView: OverlayView!
    var challengeOverlay = true
    var menuShowing = false
    var spinner = UIActivityIndicatorView()
    var passToNextVC = false
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var noClientsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noClientsLabel.alpha = 0
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "DJB Chalk It Up", size: 30)!,NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnTableView(_:)))
        tableViewOutlet.addGestureRecognizer(tapGesture)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hitTest(_:)))
        self.view.addGestureRecognizer(gesture)
        overlayView = OverlayView.instanceFromNib() as! OverlayView
        menuView = MenuView.instanceFromNib() as! MenuView
        view.addSubview(overlayView)
        view.addSubview(menuView)
        overlayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        overlayView.alpha = 0
        menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
        
        spinner.frame = CGRect(x:(self.tableViewOutlet.frame.width/2)-25, y:(self.tableViewOutlet.frame.height/2)-25, width:50, height:50)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        spinner.color = UIColor.white
        spinner.alpha = 0
        tableViewOutlet.addSubview(spinner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let internetCheck = Reachability.isInternetAvailable()
        if internetCheck == false{
            let alertController = UIAlertController(title: "Error", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            spinner.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 1})
            DispatchQueue.global(qos: .userInitiated).async {
                DBService.shared.retrieveClients {
                    UIView.animate(withDuration: 0.2, animations: {self.spinner.alpha = 0})
                    self.spinner.stopAnimating()
                    self.clientArray = DBService.shared.clients
                    self.tableViewOutlet.reloadData()
                    if self.clientArray.count == 0{
                        self.noClientsLabel.alpha = 1
                    }else{
                        self.noClientsLabel.alpha = 0
                    }
                    
                    if DBService.shared.passToNextVC == true{
                        for i in 0...self.clientArray.count-1{
                            if self.clientArray[i].clientKey == DBService.shared.passedClient.clientKey{
                                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sessionsVC") as! SessionsViewController
                                nextVC.clientPassed = self.clientArray[self.selectedRow]
                                DBService.shared.setPassedClient(client: self.clientArray[i])
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
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
        if client.gender == "Male" {
            cell.nameOutlet.textColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }else if client.gender == "Female" {
            cell.nameOutlet.textColor = UIColor(red: 255.0/255.0, green: 140.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteAlert = UIAlertController(title: "Delete Client?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(controller) in
                let x = indexPath.row
                let id = self.clientArray[x].clientKey
                DBService.shared.deleteClient(id: id)
                self.clientArray.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                if self.clientArray.count == 0{
                    self.noClientsLabel.alpha = 1
                }else{
                    self.noClientsLabel.alpha = 0
                }
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func createClient(_ sender: UIBarButtonItem) {
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
        popController.preferredContentSize = CGSize(width: 300, height: 580)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
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
    }
    
    @objc func didTapOnTableView(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: tableViewOutlet)
        let row = tableViewOutlet.indexPathForRow(at: touchPoint)?.row
        if row != nil{
            performSegue(withIdentifier: "exercisesSegue", sender: sender)
        }
    }
    
    @objc func hitTest(_ sender:UITapGestureRecognizer){
        if menuShowing == true{
            //remove menu view
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
                self.overlayView.alpha = 0
            })
            menuShowing = false
        }else{
            if tableViewOutlet.frame.contains(sender.location(in: view)){
                performSegue(withIdentifier: "exercisesSegue", sender: sender)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "exercisesSegue"){
            let s = sender as! UITapGestureRecognizer
            let evc:SessionsViewController = segue.destination as! SessionsViewController
            let selectedRow = tableViewOutlet.indexPathForRow(at:s.location(in: tableViewOutlet))?.row
            evc.clientPassed = clientArray[selectedRow!]
            DBService.shared.setPassedClient(client: clientArray[selectedRow!])
        }
    }
}
