//
//  ProfileViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/20/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//
import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate{
    
    var history:[String] = ["History"]
    var selectedRow:Int = 0
    var currentClient:Client!
    var menuView:MenuView!
    var overlayView: OverlayView!
    var challengeOverlay = true
    var menuShowing = false
    var button:UIButton!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var notificationNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:#selector(ClientViewController.appEnteredForeground(_:)), name: NSNotification.Name(rawValue: "appEnteredForegroundKey"), object: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "DJB Chalk It Up", size: 30)!,NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        notificationNumber.layer.cornerRadius = 10.0
        notificationNumber.clipsToBounds = true
        notificationNumber.layer.borderWidth = 1
        notificationNumber.layer.borderColor = UIColor.red.cgColor
                
        button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        button.titleLabel!.font =  UIFont(name: "DJB Chalk It Up", size: 30)
        button.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
        button.setTitle("Profile", for: .normal)
        button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
        self.navigationItem.titleView = button
        UIApplication.shared.keyWindow?.addSubview(notificationNumber)
        
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationNumber.alpha = 0
        }else{
            notificationNumber.alpha = 1
            notificationNumber.text = String(num)
        }
    }
    
    func clickOnButton(button: UIButton) {
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        
        xPosition = self.view.frame.width/2
        yPosition = self.view.frame.minY + 60
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileStatsVC") as! ProfileStatsViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = self.view
        popController.preferredContentSize = CGSize(width: 300, height: 450)
        popController.popoverPresentationController?.sourceRect = CGRect(x: xPosition, y: yPosition, width: 0, height: 0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }

    
    func appEnteredForeground(_ notification: Notification){
        let num  = UIApplication.shared.applicationIconBadgeNumber
        if num == 0{
            notificationNumber.alpha = 0
        }else{
            notificationNumber.alpha = 1
            notificationNumber.text = String(num)
        }
    }
    
    //TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = "History"
        return cell
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
    
    func didTapOnTableView(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: tableViewOutlet)
        let row = tableViewOutlet.indexPathForRow(at: touchPoint)?.row
        if row != nil{
            performSegue(withIdentifier: "historySegue", sender: sender)
        }
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
            if tableViewOutlet.frame.contains(sender.location(in: view)){
                performSegue(withIdentifier: "historySegue", sender: sender)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

