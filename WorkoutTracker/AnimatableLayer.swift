//
//  AnimatableLayer.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 11/6/17.
//  Copyright © 2017 Stefan Auvergne. All rights reserved.
//

import UIKit

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
