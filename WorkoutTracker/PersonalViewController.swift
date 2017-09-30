//
//  ProfileViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 7/20/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase

class PersonalViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    var currentClient:Client!
    var menuView:MenuView!
    var overlayView: OverlayView!
    var challengeOverlay = true
    var menuShowing = false
    var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "DJB Chalk It Up", size: 30)!,NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 170, height: 60)
        button.titleLabel!.font =  UIFont(name: "DJB Chalk It Up", size: 30)
        button.setBackgroundImage(UIImage(named:"chalkBackground"), for: .normal)
        button.setTitle("Personal", for: .normal)
        button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
        self.navigationItem.titleView = button
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
    
    @objc func clickOnButton(button: UIButton) {
        var xPosition:CGFloat = 0
        var yPosition:CGFloat = 0
        
        xPosition = self.view.frame.width/2
        yPosition = self.view.frame.minY + 60
        
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "personalStatsVC") as! PersonalStatsViewController
        
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
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "History"{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "exerciseHistoryVC") as! ExercisesHistoryViewController
           self.navigationController?.pushViewController(nextVC, animated: true)
        }else if sender.titleLabel?.text == "Delete Exercise"{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "deleteExerciseVC") as! DeleteExerciseViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
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
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

