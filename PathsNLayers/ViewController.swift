//
//  ViewController.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 12/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate  {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var views = [DemoView]()
    var firstCircle : CircleView? = nil
    var secondCircle : CircleView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.minimumZoomScale = 0.5
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        mytapGestureRecognizer.delegate = self
        subView.addGestureRecognizer(mytapGestureRecognizer)
        
        add_a_shape(shape: "Triangle",x:100 ,y:100)
        add_a_shape(shape: "Rectangle",x:450, y:100)
        add_a_shape(shape: "Diamond",x:100, y: 400)
        add_a_shape(shape: "Rounded Rectangle", x:450, y:400)
        add_a_shape(shape: "Database", x:100, y:700)
        add_a_shape(shape: "Harddisk", x:450, y:700)
        disable_all()
        
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Prevent subviews of a specific view to send touch events to the view's gesture recognizers.
        if let touchedView = touch.view, let gestureView = gestureRecognizer.view, touchedView.isDescendant(of: gestureView), touchedView !== gestureView {
            return false
        }
        return true
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //print("zooming in")
        return subView
    }

    func add_a_shape(shape: String , x: CGFloat, y: CGFloat){
        let width: CGFloat = 240.0
        let height: CGFloat = 160.0
        let demoView = DemoView(frame: CGRect(x: x,
                                              y: y,
                                              width: width,
                                              height: height),inshape: shape)
        views.append(demoView)
        
        demoView.isUserInteractionEnabled = true
        subView.addSubview(demoView)
        demoView.createCircles()
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(circlegesture))
        for circle in demoView.circles{
            circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circlegesture)))
        }

    }
    
    func disable_all() {
        for view in views {
            view.disable_resize()
        }
    }
  
//    @objc func myTapAction(_ sender: UITapGestureRecognizer) {
//        if var sublayers = sender.view?.layer.sublayers{
//            if sublayers[0] is CATextLayer{
//
//                let textLayer = CATextLayer()
//                textLayer.string = "WOW!\nNew Text!"
//                textLayer.foregroundColor = UIColor.white.cgColor
//                textLayer.font = UIFont(name: "Avenir", size: 15.0)
//                textLayer.fontSize = 15.0
//                textLayer.alignmentMode = CATextLayerAlignmentMode.center
//                textLayer.backgroundColor = UIColor.orange.cgColor
//                textLayer.contentsScale = UIScreen.main.scale
//                textLayer.frame = CGRect(x: 0.0, y: (sender.view?.frame.size.height)!/2.0 - 20.0, width: (sender.view?.frame.size.width)!, height: 40.0)
//                sender.view?.layer.replaceSublayer(sublayers[0], with: textLayer)
//
//            }
//        }
//
//    }

    @objc func circlegesture(_ sender: UITapGestureRecognizer){
        print("print circle")
        if firstCircle == nil {
            firstCircle = sender.view as! CircleView?
            firstCircle?.hasConnection = true
            firstCircle?.isHidden = true
        }else{
//            draw_line(point1: (firstCircle?.center)!, point2: (sender.view?.center)!)
            secondCircle = sender.view as! CircleView?
            subView.layer.addSublayer((firstCircle?.lineTo(circle: secondCircle!))! )
            secondCircle?.hasConnection = true
            secondCircle?.isHidden = true
            firstCircle = nil
            secondCircle = nil
        }
    }
    @objc func myTapAction(_ sender: UITapGestureRecognizer) {
        if sender.view is CircleView {
            print("touched a circle")
        }
        else{
            
            if firstCircle == nil{
                for view in views{
                    view.disable_resize()
                }
            }
            
            firstCircle?.hasConnection = false
            firstCircle?.isHidden = false
            firstCircle = nil
            print("touches in viewcontroller")
        }
//        var touch = sender.location(in: scrollView)
//        var done = false
//        for view in views{
//            if view.bounds.contains(touch){
//                done = true
//            }
//        }
//        if !done{
//            for view in views{
//                view.disable_resize()
//            }
//        }
//        draw_line()
        
    }

    
    func draw_line(point1: CGPoint, point2: CGPoint) {
        var arrow = UIBezierPath()
        arrow.move(to: point1)
        arrow.addLine(to: point2)
//        arrow.close()
        let line = CAShapeLayer()
        line.path = arrow.cgPath
        line.lineWidth = 2
        line.strokeColor = UIColor.black.cgColor
        subView.layer.addSublayer(line)
    }

}

