//
//  MenuView.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 5/15/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var clientBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    
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
    }
    
    func dismissMenu() {
        self.removeFromSuperview()
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
