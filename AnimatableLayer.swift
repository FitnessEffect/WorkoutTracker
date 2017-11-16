//
//  TextFieldAnimations.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 11/6/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

//class TextFieldAnimations: UITextField {
//
//    func shake(){
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 0.05
//        animation.repeatCount = 5
//        animation.autoreverses = true
//        animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 4, y: self.center.y))
//        animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x + 4, y: self.center.y))
//        
//        self.layer.add(animation, forKey: "position")
//    }
//    
//    func makeThings() {
//        let myField = UITextField(frame: frame)
//        let animationLayer = AnimatableLayer()
//        myField.layer.addSublayer(animationLayer)
//        animationLayer.shake(from: CGPoint.zero, to: CGPoint.zero)
//    }
//    
//    //btn
//
//}

class AnimatableLayer: CALayer {
    func shake(from: CGPoint, to: CGPoint) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: from)
        animation.toValue = NSValue(cgPoint: to)
        add(animation, forKey: "position")
        return animation
    }
}
