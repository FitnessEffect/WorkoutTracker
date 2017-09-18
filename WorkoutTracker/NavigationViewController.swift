//
//  NavigationViewController.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 8/31/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    var passToNextVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if passToNextVC == true{
            passToNextVC = false
            
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clientID") as! ClientViewController
            DBService.shared.setPassToNextVC(bool: true)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    func setPassToNextVC(bool:Bool){
        passToNextVC = bool
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
