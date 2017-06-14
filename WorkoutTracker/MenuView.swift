//
//  MenuView.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/15/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func handleSelection(type: String)
}

class MenuView: UIView {
    
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var clientBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var delegate: MenuViewDelegate?
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MenuView
    }
    
    func addFx() {
        profileBtn.layer.shadowColor = UIColor.black.cgColor
        profileBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        profileBtn.layer.shadowOpacity = 0.6
        profileBtn.layer.shadowRadius = 5
        
        clientBtn.layer.shadowColor = UIColor.black.cgColor
        clientBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        clientBtn.layer.shadowOpacity = 0.6
        clientBtn.layer.shadowRadius = 5
        
        historyBtn.layer.shadowColor = UIColor.black.cgColor
        historyBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        historyBtn.layer.shadowOpacity = 0.6
        historyBtn.layer.shadowRadius = 5
        
        challengeBtn.layer.shadowColor = UIColor.black.cgColor
        challengeBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        challengeBtn.layer.shadowOpacity = 0.6
        challengeBtn.layer.shadowRadius = 5
        
        settingsBtn.layer.shadowColor = UIColor.black.cgColor
        settingsBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        settingsBtn.layer.shadowOpacity = 0.6
        settingsBtn.layer.shadowRadius = 5
        
        logoutBtn.layer.shadowColor = UIColor.black.cgColor
        logoutBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        logoutBtn.layer.shadowOpacity = 0.6
        logoutBtn.layer.shadowRadius = 5
    }
    
    func dismissMenu() {
        self.removeFromSuperview()
    }
    
    func profileButtonAction() {
        // delegate.handleSelection(type: "profile")
        // self.removeFromSuperview()
    }
    
//    func addSelector() {
//        //slide view in here
//        if menuShowing == false{
//            addFx()
//            UIView.animate(withDuration: 0.3, animations: {
//                self.frame = CGRect(x: 0, y: 0, width: 126, height: 500)
//                self.view.isHidden = false
//                self.overlayView.alpha = 1
//            })
//            menuShowing = true
//        }else{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.frame = CGRect(x: -140, y: 0, width: 126, height: 500)
//                self.overlayView.alpha = 0
//            })
//            menuShowing = false
//        }
//        profileBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        clientBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        historyBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        challengeBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        settingsBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        logoutBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//    }

    var navigationController: UINavigationController?
    
    @IBAction func btnAction(_ sender: UIButton) {
        if sender.tag == 1{
            let inputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputVC") as! WorkoutInputViewController
            //self.present(inputVC, animated: true, completion: nil)
            
            inputVC.handleSelection(type: "home")
            
        }else if sender.tag == 2{
            let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyNavID") as! UINavigationController
            //self.present(historyVC, animated: true, completion: nil)
           
        }else if sender.tag == 3{
            let clientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clientNavID") as! UINavigationController
            //self.present(clientVC, animated: true, completion: nil)
            
        }else if sender.tag == 4{
            let challengesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "challengesNavID") as! UINavigationController
            //self.present(challengesVC, animated: true, completion: nil)
        }else if sender.tag == 5{
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            //self.present(loginVC, animated: true, completion: nil)
        }
    }
    
//    func triggerButton1(completion: () -> Void) {
//        completion()
//    }


    // or from main view controller
    // let menu = MenuView.instanceFromNib()
    // menu.button1.action...
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
