//
//  DoubleCircleButton.swift
//  HaQ
//
//  Created by Ognyan Kossov on 2/8/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

import UIKit

class DoubleCircleButton: UIView {
    
    var scale: CGFloat = 0.0;
    var layerr = CAShapeLayer();
    
    override func drawRect(rect: CGRect) {
        let outsideCircle = UIBezierPath(ovalInRect: rect)
        UIColor.greenColor().setStroke()
        outsideCircle.stroke()
        
        let label = UILabel(frame: CGRectMake(16,rect.height/2 - 25,rect.width,50))
        label.text = "Hold to Initialize";
        label.textColor = UIColor.whiteColor();
        self.addSubview(label)
        
//        layerr.path = UIBezierPath(roundedRect: CGRect(x: rect.size.width/2, y:  rect.size.height/2, width: 1,height: 1), cornerRadius: 50).CGPath
//        //innerCircle.applyTransform(CGAffineTransformMakeScale(5, 5))
//        layerr.fillColor = UIColor.greenColor().CGColor
//        self.layer.addSublayer(layer)
    }
    
    func addToInnerSize() {

    }
    
    func takeFromInnerSize() {

    }
}
