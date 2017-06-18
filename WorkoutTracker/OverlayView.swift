//
//  OverlayView.swift
//  
//
//  Created by Stefan Auvergne on 5/15/17.
//
//

import UIKit

class OverlayView: UIView {

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "OverlayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OverlayView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
