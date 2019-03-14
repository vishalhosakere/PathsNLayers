//
//  ViewController.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 12/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var views = [DemoView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.minimumZoomScale = 0.5
        
        // Do any additional setup after loading the view, typically from a nib.
        let width: CGFloat = 240.0
        let height: CGFloat = 160.0
        
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        
        let demoView = DemoView(frame: CGRect(x: self.view.frame.size.width/2 - width/2,
                                              y: self.view.frame.size.height/2 - height/2,
                                              width: width,
                                              height: height))
        views.append(demoView)
        
        demoView.isUserInteractionEnabled = true
        
        let demoView2 = DemoView(frame: CGRect(x: self.view.frame.size.width/2 - width/2,
                                              y: self.view.frame.size.height/2 - height/2,
                                              width: width,
                                              height: height), inshape: "Rectangle")
        
        views.append(demoView2)
        demoView2.isUserInteractionEnabled = true
        
//        scrollView.addGestureRecognizer(mytapGestureRecognizer)
        
        subView.addSubview(demoView)
        subView.addSubview(demoView2)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //print("zooming in")
        return subView
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

    @objc func myTapAction(_ sender: UITapGestureRecognizer) {
        print("touches in viewcontroller")
        var touch = sender.location(in: scrollView)
        var done = false
        for view in views{
            if view.
        }
    }


}

