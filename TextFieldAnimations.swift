//
//  TextFieldAnimations.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 11/6/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

class TextFieldAnimations: UITextField {

    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x + 4, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }

}
