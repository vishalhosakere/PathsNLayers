//
//  CircleView.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 14/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class CircleView : UIView , UIGestureRecognizerDelegate {
    
    var outGoingLine : CAShapeLayer?
    var inComingLine : CAShapeLayer?
    var inComingCircle : CircleView?
    var outGoingCircle : CircleView?
    var mainPoint : CGPoint?
    var hasConnection : Bool
    
    override init(frame: CGRect) {
        hasConnection = false
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.size.width / 2
//        let plus = UIImageView(image: UIImage(contentsOfFile: "plus"))
//        plus.frame = self.frame
//        plus.contentMode = .sca
//        self.addSubview(plus)
        let myLayer = CALayer()
        let myImage = UIImage(named: "plus")?.cgImage
        myLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        myLayer.contents = myImage
        self.layer.addSublayer(myLayer)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lineTo2(circle: CircleView) -> CAShapeLayer {
        let path = UIBezierPath()
//        path.move(to: self.center)
//        path.addLine(to: circle.center)
        path.move(to: (self.mainPoint)!)
        path.addLine(to: (circle.mainPoint)!)
        
        let line = CAShapeLayer()
        line.path = path.cgPath
        line.lineWidth = 2
        line.strokeColor = UIColor.black.cgColor

        circle.inComingLine = line
        outGoingLine = line
        outGoingCircle = circle
        circle.inComingCircle = self
        return line
    }
    
    
    
    
    func lineTo(circle: CircleView) -> CAShapeLayer {
        let arrow = UIBezierPath.arrow(from: (self.mainPoint)!, to: (circle.mainPoint)!,tailWidth: 1, headWidth: 20, headLength: 20)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = arrow.cgPath
        
        circle.inComingLine = shapeLayer
        outGoingLine = shapeLayer
        outGoingCircle = circle
        circle.inComingCircle = self
        
        return shapeLayer
    }
    
    func getPath(circle: CircleView) -> CGPath {
        let arrow = UIBezierPath.arrow(from: (self.mainPoint)!, to: (circle.mainPoint)!,tailWidth: 1, headWidth: 20, headLength: 20)
        return arrow.cgPath
    }
}




