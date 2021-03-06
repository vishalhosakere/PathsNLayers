//
//  DemoView.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 12/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class DemoView: UIView , UIGestureRecognizerDelegate {

    private var shape: String
    
    var kResizeThumbSize : CGFloat = 45.0
    var isResizingLR = false
    var isResizingUL = false
    var isResizingUR = false
    var isResizingLL = false
    var touchStart = CGPoint.zero
    let borderlayer = CAShapeLayer()
    let textView = UITextView()
    let textLabel = UITextField()
    var circles = [CircleView]()
    
//    let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
    
    
    var path: UIBezierPath!
    
    convenience init(frame: CGRect, inshape: String) {
        self.init(frame: frame)
        self.shape = inshape
    }
    
    override init(frame: CGRect) {
        
        self.shape = "Triangle"
        super.init(frame: frame)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        gestureRecognizer.numberOfTapsRequired = 2
        gestureRecognizer.delegate = self
        self.addGestureRecognizer(gestureRecognizer)
        self.backgroundColor = UIColor.clear


        let bounds = self.bounds
        borderlayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
        borderlayer.strokeColor = UIColor.black.cgColor
        borderlayer.fillColor = nil
        borderlayer.lineDashPattern = [8, 6]
        borderlayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        self.layer.addSublayer(borderlayer)
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = borderlayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        animation.duration = 1
        animation.repeatCount = .infinity
        borderlayer.add(animation, forKey: "line")
        
        createTextView()
//        createCircles()
        
        //createTextLayer()



    }

    required init?(coder aDecoder: NSCoder) {
        self.shape = "Triangle"
        super.init(coder: aDecoder)
    }
    
    

    
    func createRectangle() {
        // Initialize the path.
        path = UIBezierPath()
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 10.0, y: 10.0))
        
        // Create a line between the starting point and the bottom-left side of the view.
        path.addLine(to: CGPoint(x: 10.0, y: self.frame.size.height - 10))
        
        // Create the bottom line (bottom-left to bottom-right).
        path.addLine(to: CGPoint(x: self.frame.size.width - 10, y: self.frame.size.height - 10))
        
        // Create the vertical line from the bottom-right to the top-right side.
        path.addLine(to: CGPoint(x: self.frame.size.width - 10, y: 10.0))
        
        // Close the path. This will create the last line automatically.
        path.close()
    }
    
    func createDiamond() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width/2, y: 10))
        path.addLine(to: CGPoint(x: 10 , y: self.frame.height/2))
        path.addLine(to: CGPoint(x: self.frame.width/2 , y: self.frame.height - 10))
        path.addLine(to: CGPoint(x: self.frame.width - 10, y: self.frame.height/2))
        path.close()
    }
   
    func createTriangle() {
//        mytapGestureRecognizer.numberOfTapsRequired = 1
//        self.addGestureRecognizer(mytapGestureRecognizer)
        
        path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width/2, y: 10))
        path.addLine(to: CGPoint(x: 10, y: self.frame.size.height - 10))
        path.addLine(to: CGPoint(x: self.frame.size.width - 10 , y: self.frame.size.height - 10))
        path.close()
    }

    
    func createRoundedRectangle() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 40, y: 10))
        path.addLine(to: CGPoint(x: self.frame.width - 40, y: 10))
        path.addCurve(to: CGPoint(x: self.frame.width - 40, y: self.frame.height - 10), controlPoint1: CGPoint(x: self.frame.width, y: (self.frame.height)/3), controlPoint2: CGPoint(x: self.frame.width, y: 2*(self.frame.height)/3))
        path.addLine(to: CGPoint(x: 40, y: self.frame.height - 10))
        path.addCurve(to: CGPoint(x: 40, y: 10), controlPoint1: CGPoint(x: 0, y: 2*(self.frame.height)/3), controlPoint2: CGPoint(x: 0, y: 	(self.frame.height)/3))
        path.close()
    }
    
    func createDatabase() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 20))
        path.addCurve(to: CGPoint(x: self.frame.width - 10, y: 20), controlPoint1: CGPoint(x: self.frame.width/3, y: 0), controlPoint2: CGPoint(x: 2*self.frame.width/3, y: 0))
        path.addCurve(to: CGPoint(x: 10, y: 20), controlPoint1: CGPoint(x: self.frame.width*2/3, y: 40), controlPoint2: CGPoint(x: self.frame.width/3, y: 40))
        path.addLine(to: CGPoint(x: 10, y: self.frame.height - 20))
        path.addCurve(to: CGPoint(x: self.frame.width - 10, y: self.frame.height - 20), controlPoint1: CGPoint(x: self.frame.width/3, y: self.frame.height), controlPoint2: CGPoint(x: self.frame.width*2/3, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width - 10, y: 20))
        
    }
    
    func createHarddisk(){
        path = UIBezierPath()
        //path.move(to: CGPoint(x: 20, y: 10))
        path.move(to: CGPoint(x: self.frame.width - 20, y: 10))
        path.addCurve(to: CGPoint(x: self.frame.width - 20, y: self.frame.height - 10), controlPoint1: CGPoint(x: self.frame.width, y: self.frame.height/3), controlPoint2: CGPoint(x: self.frame.width, y: self.frame.height*2/3))
        path.addCurve(to: CGPoint(x: self.frame.width - 20, y: 10), controlPoint1: CGPoint(x: self.frame.width - 40, y: self.frame.height*2/3), controlPoint2: CGPoint(x: self.frame.width - 40, y: self.frame.height/3))
        path.addLine(to: CGPoint(x: 20, y: 10))
        path.addCurve(to: CGPoint(x: 20, y: self.frame.height - 10), controlPoint1: CGPoint(x: 0, y: self.frame.height/3), controlPoint2: CGPoint(x: 0, y: self.frame.height*2/3))
        path.addLine(to: CGPoint(x: self.frame.width - 20, y: self.frame.height - 10))
    }
    
    
    
    
    
    func createTextView() {
        
        textView.text = "Hello"
        textView.frame = CGRect(x: 0.0, y: self.frame.size.height/2 - 20.0, width: self.frame.size.width, height: 40.0)
//        textView.frame = CGRect(x: 20.0, y: 20.0, width: self.bounds.size.width - 20, height: self.bounds.size.height - 20.0)
        textView.textAlignment = NSTextAlignment.center
        textView.backgroundColor = UIColor.clear
        textView.isUserInteractionEnabled = true
        textView.isEditable = true
        textView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        //textView.adjustsFontForContentSizeCategory = true
        textView.textContainer.maximumNumberOfLines = 3
//        textView.isScrollEnabled = false
        //textView.textContainer.exclusionPaths = [path]
        self.addSubview(textView)
    }
    
    func createTextView_1() {
        
        textLabel.text = "Hello"
        textLabel.frame = CGRect(x: 0.0, y: self.frame.size.height/2 - 20.0, width: self.frame.size.width, height: 40.0)
        //        textView.frame = CGRect(x: 20.0, y: 20.0, width: self.bounds.size.width - 20, height: self.bounds.size.height - 20.0)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.backgroundColor = UIColor.clear
        textLabel.isUserInteractionEnabled = true
        textLabel.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
//        textLabel = 2
        textLabel.sizeToFit()
//        textLabel.lines
//        textLabel.textContainer.exclusionPaths = [path]
        self.addSubview(textLabel)	
    }
    
    
    func createTextLayer() {
        let textLayer = CATextLayer()
        textLayer.string = "WOW!\nThis is text on a layer!"
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.font = UIFont(name: "Avenir", size: 15.0)
        textLayer.fontSize = 15.0
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.backgroundColor = UIColor.orange.cgColor
        textLayer.frame = CGRect(x: 0.0, y: self.frame.size.height/2 - 20.0, width: self.frame.size.width, height: 40.0)
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
    }
    
    
    func createCircles(){
        let cir1 = CircleView(frame: CGRect(x: self.center.x - (self.bounds.size.width / 2) - 50 , y: self.center.y - 25, width: 50, height: 50))
        let cir2 = CircleView(frame: CGRect(x: self.center.x - 25 , y: self.center.y - (self.bounds.size.height / 2) - 50, width: 50, height: 50))
        let cir3 = CircleView(frame: CGRect(x: self.center.x + (self.bounds.size.width / 2) , y: self.center.y - 25, width: 50, height: 50))
        let cir4 = CircleView(frame: CGRect(x: self.center.x - 25 , y: self.center.y + (self.bounds.size.height / 2) , width: 50, height: 50))
        if self.shape == "Triangle" {
            print("its a triangle!!!")
            cir1.mainPoint = CGPoint(x: self.center.x - (self.bounds.size.width / 4) , y: self.center.y) //left
            cir2.mainPoint = CGPoint(x: self.center.x  , y: self.center.y - (self.bounds.size.height / 2)) //top
            cir3.mainPoint = CGPoint(x: self.center.x + (self.bounds.size.width / 4) , y: self.center.y) //right
            cir4.mainPoint = CGPoint(x: self.center.x , y: self.center.y + (self.bounds.size.height / 2)) //bottom
        }else{
            cir1.mainPoint = CGPoint(x: self.center.x - (self.bounds.size.width / 2) , y: self.center.y)
            cir2.mainPoint = CGPoint(x: self.center.x  , y: self.center.y - (self.bounds.size.height / 2))
            cir3.mainPoint = CGPoint(x: self.center.x + (self.bounds.size.width / 2) , y: self.center.y)
            cir4.mainPoint = CGPoint(x: self.center.x , y: self.center.y + (self.bounds.size.height / 2))
        }
        cir1.backgroundColor = .clear
        cir2.backgroundColor = .clear
        cir3.backgroundColor = .clear
        cir4.backgroundColor = .clear
//        circles.append(cir1,cir2,cir3,cir4)
        circles.append(contentsOf: [cir1,cir2,cir3,cir4])
        superview?.addSubview(cir1)
        superview?.addSubview(cir2)
        superview?.addSubview(cir3)
        superview?.addSubview(cir4)

    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("drawing again")
        // Drawing code
        if self.shape == "Triangle" {
            self.createTriangle()
        }else if self.shape == "Diamond"{
            self.createDiamond()
        }else if self.shape == "Rounded Rectangle"{
            self.createRoundedRectangle()
        }else if self.shape == "Rectangle"{
            self.createRectangle()
        }else if self.shape == "Database"{
            self.createDatabase()
        }else if self.shape == "Harddisk"{
            self.createHarddisk()
        }
        
        
        UIColor.clear.setFill()
        path.fill()

        // Specify a border (stroke) color.
        UIColor.black.setStroke()
        path.stroke()
        path.lineWidth = 4.0
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
//        if self.borderlayer.isHidden{
//            return
//        }
        let touch = touches.first
        //print("Touchesbegan")
        let touchStart = touch!.location(in: self)
        //print("\(self.bounds.size.width) \(self.bounds.size.height) \(touchStart.x) \(touchStart.y)")
        if (self.bounds.size.width - touchStart.x < kResizeThumbSize) && (self.bounds.size.height - touchStart.y < kResizeThumbSize){
            isResizingLR = true
        }else{
            isResizingLR = false
        }
        if (touchStart.x < kResizeThumbSize && touchStart.y < kResizeThumbSize){
            isResizingUL = true
        }else{
            isResizingUL = false
        }
        
        if (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize){
            isResizingUR = true
        }else{
            isResizingUR = false
        }
        if (touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize){
            isResizingLL = true
        }else{
            isResizingLL = false
        }
        //print("\(isResizingLL) \(isResizingLR) \(isResizingUL) \(isResizingUR)")
    }
    
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.borderlayer.isHidden{
            self.center = touches.first!.location(in: self.superview)
            self.subviews[0].center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            self.borderlayer.path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
            circles[0].center = CGPoint(x: self.center.x - (self.bounds.size.width / 2) - 50 + 25 , y: self.center.y - 25 + 25)
            circles[1].center = CGPoint(x: self.center.x - 25 + 25, y: self.center.y - (self.bounds.size.height / 2) - 50 + 25)
            circles[2].center = CGPoint(x: self.center.x + (self.bounds.size.width / 2) + 25 , y: self.center.y - 25 + 25)
            circles[3].center = CGPoint(x: self.center.x - 25 + 25 , y: self.center.y + (self.bounds.size.height / 2) + 25)
            if self.shape == "Triangle"{
                circles[0].mainPoint = CGPoint(x: self.center.x - (self.bounds.size.width / 4) , y: self.center.y)
                circles[1].mainPoint = CGPoint(x: self.center.x  , y: self.center.y - (self.bounds.size.height / 2))
                circles[2].mainPoint = CGPoint(x: self.center.x + (self.bounds.size.width / 4) , y: self.center.y)
                circles[3].mainPoint = CGPoint(x: self.center.x , y: self.center.y + (self.bounds.size.height / 2))
            }
            else{
                circles[0].mainPoint = CGPoint(x: self.center.x - (self.bounds.size.width / 2) , y: self.center.y)
                circles[1].mainPoint = CGPoint(x: self.center.x  , y: self.center.y - (self.bounds.size.height / 2))
                circles[2].mainPoint = CGPoint(x: self.center.x + (self.bounds.size.width / 2) , y: self.center.y)
                circles[3].mainPoint = CGPoint(x: self.center.x , y: self.center.y + (self.bounds.size.height / 2))
            }
            for circle in circles{
                if let outGoingCircle = circle.outGoingCircle, let line = circle.outGoingLine, let path = circle.outGoingLine?.path {
//                    let newPath = UIBezierPath(cgPath: path)
//                    newPath.removeAllPoints()
//                    newPath.move(to: circle.mainPoint!)
//                    newPath.addLine(to: outGoingCircle.mainPoint!)
//                    line.path = newPath.cgPath
                    line.path = circle.getPath(circle: circle.outGoingCircle!)
                }
                
                if let inComingCircle = circle.inComingCircle, let line = circle.inComingLine, let path = circle.inComingLine?.path {
//                    let newPath = UIBezierPath(cgPath: path)
//                    newPath.removeAllPoints()
//                    newPath.move(to: inComingCircle.mainPoint!)
//                    newPath.addLine(to: circle.mainPoint!)
//                    line.path = newPath.cgPath
                    line.path = circle.inComingCircle!.getPath(circle: circle)
                }
            }
            return
        }
        let touchPoint =  touches.first?.location(in: self)
        let previous = touches.first?.previousLocation(in: self)
        
        let deltaWidth = (touchPoint?.x)! - (previous?.x)!
        let deltaHeight = (touchPoint?.y)! - (previous?.y)!
        
        let x : CGFloat = self.frame.origin.x
        let y : CGFloat = self.frame.origin.y
        let width : CGFloat = self.frame.size.width
        let height : CGFloat = self.frame.size.height
        
        
        
        if (isResizingLR) {
            self.frame = CGRect(x: x, y: y, width: touchPoint!.x+deltaWidth, height :touchPoint!.y+deltaWidth)
        } else if (isResizingUL) {
            self.frame = CGRect(x: x+deltaWidth, y: y+deltaHeight,width: width-deltaWidth,height:  height-deltaHeight)
        } else if (isResizingUR) {
            self.frame = CGRect(x: x, y: y+deltaHeight, width: width+deltaWidth, height: height-deltaHeight)
        } else if (isResizingLL) {
            self.frame = CGRect(x: x+deltaWidth, y: y, width: width-deltaWidth, height: height+deltaHeight)
        } else {
            // not dragging from a corner -- move the view
            //self.center = CGPoint(x: self.center.x + touchPoint!.x - touchStart.x, y: self.center.y + touchPoint!.y - touchStart.y)
            self.center = touches.first!.location(in: self.superview)
        }
        
        self.subviews[0].center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        self.borderlayer.path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
        circles[0].center = CGPoint(x: self.center.x - (self.bounds.size.width / 2) - 50 + 25 , y: self.center.y - 25 + 25)
        circles[1].center = CGPoint(x: self.center.x - 25 + 25, y: self.center.y - (self.bounds.size.height / 2) - 50 + 25)
        circles[2].center = CGPoint(x: self.center.x + (self.bounds.size.width / 2) + 25 , y: self.center.y - 25 + 25)
        circles[3].center = CGPoint(x: self.center.x - 25 + 25 , y: self.center.y + (self.bounds.size.height / 2) + 25)
        if self.shape == "Triangle"{
            circles[0].mainPoint = CGPoint(x: self.center.x - (self.bounds.size.width / 4) , y: self.center.y)
            circles[1].mainPoint = CGPoint(x: self.center.x  , y: self.center.y - (self.bounds.size.height / 2))
            circles[2].mainPoint = CGPoint(x: self.center.x + (self.bounds.size.width / 4) , y: self.center.y)
            circles[3].mainPoint = CGPoint(x: self.center.x , y: self.center.y + (self.bounds.size.height / 2))
        }
        else{
            circles[0].mainPoint = CGPoint(x: self.center.x - (self.bounds.size.width / 2) , y: self.center.y)
            circles[1].mainPoint = CGPoint(x: self.center.x  , y: self.center.y - (self.bounds.size.height / 2))
            circles[2].mainPoint = CGPoint(x: self.center.x + (self.bounds.size.width / 2) , y: self.center.y)
            circles[3].mainPoint = CGPoint(x: self.center.x , y: self.center.y + (self.bounds.size.height / 2))
        }
        for circle in circles{
            if let outGoingCircle = circle.outGoingCircle, let line = circle.outGoingLine, let path = circle.outGoingLine?.path {
//                let newPath = UIBezierPath(cgPath: path)
//                newPath.removeAllPoints()
//                newPath.move(to: circle.mainPoint!)
//                newPath.addLine(to: outGoingCircle.mainPoint!)
//                line.path = newPath.cgPath
                line.path = circle.getPath(circle: circle.outGoingCircle!)
                
            }
            
            if let inComingCircle = circle.inComingCircle, let line = circle.inComingLine, let path = circle.inComingLine?.path {
//                let newPath = UIBezierPath(cgPath: path)
//                newPath.removeAllPoints()
//                newPath.move(to: inComingCircle.mainPoint!)
//                newPath.addLine(to: circle.mainPoint!)
//                line.path = newPath.cgPath
                line.path = circle.inComingCircle!.getPath(circle: circle)
            }
        }
        
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touches moved")
//        let touch = touches.first
//        self.center = touch!.location(in: self.superview)
//    }
    


    func disable_resize() {
        self.borderlayer.isHidden = true
        self.textView.isUserInteractionEnabled = false
        for circle in circles{
            circle.isHidden = true
        }
    }
    
    func enable_resize() {
        self.borderlayer.isHidden = false
        self.textView.isUserInteractionEnabled = true
        for circle in circles{
            if !circle.hasConnection{
                circle.isHidden = false
            }
        }
    }
    @objc func myTapAction(_ sender: UITapGestureRecognizer) {

        if self.borderlayer.isHidden {
            enable_resize()
        }
        else{
            disable_resize()
        }
        
    }
    
    
    
}
