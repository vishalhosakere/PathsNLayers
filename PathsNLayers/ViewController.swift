//
//  ViewController.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 12/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate  {
//    @IBOutlet weak var subView: UIView!
//    @IBOutlet weak var scrollView: UIScrollView!
    
    var allData = entireData()
    
    var scrollView: UIScrollView?
    var subView: UIView?
    var gridView: GridView!
    //keep track of all views that contain a diagram(BezierPath)
    var views = [processView]()
    var viewsAndData = [processView: uiViewData]()
    var idAndView = [Int: processView]()
    var arrows = [ArrowShape]()
    //variables that falicitate drawing arrows between two pluses(circle view with plus image inside)
    var firstCircle : CircleView? = nil
    var secondCircle : CircleView? = nil
    var jsonData : Data?
    static var uniqueProcessID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.restorationIdentifier = "mainController"
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scrollView!)
        self.scrollView!.backgroundColor = UIColor.blue
        
        self.scrollView?.delegate = self
        
        self.scrollView!.contentSize = CGSize(width: self.view.frame.width.rounded(to: 50) * 3, height: self.view.frame.height.rounded(to: 50) * 3)
        self.subView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width.rounded(to: 50) * 3, height: self.view.frame.height.rounded(to: 50) * 3))
        self.scrollView!.addSubview(subView!)
        self.subView!.backgroundColor = UIColor.white
        self.scrollView?.canCancelContentTouches = false
        //set appropriate zoom scale for the scroll view
        self.scrollView!.maximumZoomScale = 6.0
        self.scrollView!.minimumZoomScale = 0.5
        self.scrollView!.setZoomScale(1.0, animated: true)
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        
        let screenshotButton = UIButton(frame: CGRect(x: self.view.frame.width - 100, y: 30, width: 100, height: 70))
        screenshotButton.setTitle("Screenshot", for: UIControl.State.normal)
        screenshotButton.backgroundColor = UIColor.black
        
        self.view.addSubview(screenshotButton)
        let screenshotGesture = UITapGestureRecognizer(target: self, action: #selector(take_screenshot))
        screenshotGesture.numberOfTapsRequired = 1
        screenshotGesture.delegate = self
        screenshotButton.addGestureRecognizer(screenshotGesture)
        
        
        let saveButton = UIButton(frame: CGRect(x: self.view.frame.width - 210, y: 30, width: 100, height: 70))
        saveButton.setTitle("Save", for: UIControl.State.normal)
        saveButton.backgroundColor = UIColor.black
        
        self.view.addSubview(saveButton)
        let saveGesture = UITapGestureRecognizer(target: self, action: #selector(save_action))
        saveGesture.numberOfTapsRequired = 1
        saveGesture.delegate = self
        saveButton.addGestureRecognizer(saveGesture)
        
        
        let loadButton = UIButton(frame: CGRect(x: self.view.frame.width - 320, y: 30, width: 100, height: 70))
        loadButton.setTitle("Load", for: UIControl.State.normal)
        loadButton.backgroundColor = UIColor.black
        
        self.view.addSubview(loadButton)
        let loadGesture = UITapGestureRecognizer(target: self, action: #selector(load_action))
        loadGesture.numberOfTapsRequired = 1
        loadGesture.delegate = self
        loadButton.addGestureRecognizer(loadGesture)
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //tap gesture for anything other than demoviews
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delegate = self
        subView!.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        subView!.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
        
        
        
        
        gridView = GridView(frame : subView!.frame)
        gridView.backgroundColor = UIColor.clear
        gridView.isUserInteractionEnabled = false
        
        
        subView!.addSubview(gridView)
        //add shapes required
       // add_a_shape(shape: "Triangle",x:100 ,y:100)
        add_a_shape(shape: "Rectangle",x:100, y:100, width: 100, height: 100, withID: getUniqueID(), withText: "")
        add_a_shape(shape: "Diamond",x:100, y: 400, width: 100, height: 100, withID: getUniqueID(), withText: "")
        add_a_shape(shape: "Rounded Rectangle", x:450, y:400, width: 100, height: 100, withID: getUniqueID(), withText: "")
        add_a_shape(shape: "Database", x:100, y:700, width: 100, height: 100, withID: getUniqueID(), withText: "")
        add_a_shape(shape: "Harddisk", x:450, y:700, width: 100, height: 100, withID: getUniqueID(), withText: "")
        disable_all()
        
        
        
        
    }
    
    func getUniqueID() -> Int{
        ViewController.uniqueProcessID += 1
        return ViewController.uniqueProcessID
    }
    //pass touch from viewcontroller to the demoViews
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Prevent subviews of a specific view to send touch events to the view's gesture recognizers.
        if let touchedView = touch.view, let gestureView = gestureRecognizer.view, touchedView.isDescendant(of: gestureView), touchedView !== gestureView {
            return false
        }
        return true
    }
    
    
    //enable zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("zooming in")
        return self.subView!
    }

    
    
    func add_a_shape(shape: String , x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, withID id: Int, withText text: String){
        //choose frame size
        let demoView = processView(frame: CGRect(x: x,
                                              y: y,
                                              width: width,
                                              height: height), ofShape: shape, withID: id, withText: text)
        views.append(demoView) // keep track
        
        
        demoView.isUserInteractionEnabled = true
        
        subView!.addSubview(demoView)
        
        //create the pluses around the view. need to do it here inorder to add it to its superview. which will only be assigned after addSubview above
        demoView.createCircles()
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(circlegesture))
        
        //add gesture to all the pluses
        for circle in demoView.circles{
            circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circlegesture)))
        }
        demoView.delete?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletegesture)))
        
        
        
        viewsAndData[demoView] = uiViewData(x: Double(x), y: Double(y), width: Double(width), height: Double(height), shape: shape, leftLine: lineData(id: 0, isSrc: false), rightLine: lineData(id: 0, isSrc: false), topLine: lineData(id: 0, isSrc: false), bottomLine: lineData(id: 0, isSrc: false), text: demoView.textView.text, id: id)
        idAndView[id] = demoView
        
//        allData.allViews.append(uiViewData(x: Double(x), y: Double(y), width: Double(width), height: Double(height), shape: shape, leftLine: lineData(id: 0, isSrc: false), rightLine: lineData(id: 0, isSrc: false), topLine: lineData(id: 0, isSrc: false), bottomLine: lineData(id: 0, isSrc: false), text: demoView.textView.text))
        
    }
    
    
    //helper to disable resize of all views
    func disable_all() {
        for view in views {
            view.disable_resize()
        }
        print("number of arrows = \(arrows.count)")
        for arrow in arrows{
            arrow.disable_resize()
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

    
    func addLineData(from input: CircleView, to output: CircleView){
        let ID = CircleView.getUniqueID()
        switch input.side {
        case sides.left.rawValue :
            viewsAndData[input.myView!]?.leftLine.id = ID
            viewsAndData[input.myView!]?.leftLine.isSrc = true
            break
        case sides.top.rawValue :
            viewsAndData[input.myView!]?.topLine.id = ID
            viewsAndData[input.myView!]?.topLine.isSrc = true
            break
        case sides.right.rawValue:
            viewsAndData[input.myView!]?.rightLine.id = ID
            viewsAndData[input.myView!]?.rightLine.isSrc = true
            break
        case sides.bottom.rawValue:
            viewsAndData[input.myView!]?.bottomLine.id = ID
            viewsAndData[input.myView!]?.bottomLine.isSrc = true
            break
        case .none:
            break
        case .some(_):
            break
        }
        
        switch output.side {
        case sides.left.rawValue :
            viewsAndData[output.myView!]?.leftLine.id = ID
            viewsAndData[output.myView!]?.leftLine.isSrc = false
            break
        case sides.top.rawValue :
            viewsAndData[output.myView!]?.topLine.id = ID
            viewsAndData[output.myView!]?.topLine.isSrc = false
            break
        case sides.right.rawValue:
            viewsAndData[output.myView!]?.rightLine.id = ID
            viewsAndData[output.myView!]?.rightLine.isSrc = false
            break
        case sides.bottom.rawValue:
            viewsAndData[output.myView!]?.bottomLine.id = ID
            viewsAndData[output.myView!]?.bottomLine.isSrc = false
            break
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    //gesture to add arrow
    @objc func circlegesture(_ sender: UITapGestureRecognizer){
        print("print circle")
        if firstCircle == nil {
            firstCircle = sender.view as! CircleView?
            firstCircle?.hasConnection = true
//            firstCircle?.isHidden = true
        }else{
//            draw_line(point1: (firstCircle?.center)!, point2: (sender.view?.center)!)
            secondCircle = sender.view as! CircleView?
            let arrowShape = (firstCircle?.lineTo(circle: secondCircle!))!
            arrowShape.setSubView(self.subView!)
            arrowShape.createCircles()
            arrows.append(arrowShape)
            arrowShape.circle?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circlegesture)))
            arrowShape.delete?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletegesture)))

            subView!.layer.addSublayer(arrowShape)
            addLineData(from: firstCircle!, to: secondCircle!)
            secondCircle?.hasConnection = true
//            secondCircle?.isHidden = true
            firstCircle = nil
            secondCircle = nil
        }
    }
    
    @objc func deletegesture(_ sender: UITapGestureRecognizer){
        
        print("print delete")
        let del = sender.view as! CircleView?
        if del?.myView != nil{
            for circle in (del?.myView?.circles)!{
    //            circle.inComingLine
    //            circle.outGoingLine
                circle.removeFromSuperview()
                
            }
            views.removeObjFromArray(object: del?.myView)
            let data = viewsAndData[(del?.myView)!]
            idAndView.removeValue(forKey: data!.id)
            viewsAndData.removeValue(forKey: (del?.myView)!)
            
            del?.myView?.removeFromSuperview()
            del?.removeFromSuperview()
            
            print(idAndView.count)
            print(viewsAndData.count)
            print(views.count)
        }
        if del?.myLayer != nil{
            del?.myLayer?.inputCircle.hasConnection = false
            del?.myLayer?.outputCircle.hasConnection = false
            del?.myLayer?.circle?.removeFromSuperview()
            del?.myLayer?.expand?.removeFromSuperview()
            del?.myLayer?.removeFromSuperlayer()
            del?.removeFromSuperview()
        }

        
    }
    
    
    //gesture to recognize tap in subView which contains all the diagrams
    @objc func singleTap(_ sender: UITapGestureRecognizer) {
        if firstCircle == nil{
            disable_all()
        }
        
        firstCircle?.hasConnection = false
        firstCircle?.isHidden = false
        firstCircle = nil
        print("touches in viewcontroller")

    }
    
    @objc func doubleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation:CGPoint = sender.location(in: subView)
        if let sublayers = subView!.layer.sublayers {
            for layer in sublayers {
                if let temp = layer as? ArrowShape{
                    if (temp.path?.contains(tapLocation))!{
                        print("touched arrow")
                        temp.updateViews(withPoint: tapLocation)
                        if temp.viewsHidden{
                            temp.enable_resize()
                        }
                        else{
                            temp.disable_resize()
                        }
                    }
                }
            }
        }
    }
    


    @objc func take_screenshot(_ sender: UITapGestureRecognizer) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let imgPath = subView!.exportAsPdfFromView()
        print("\(imgPath)")
    }
 
    
    @objc func save_action(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Enter the Filename", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your file name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("File name: \(name)")
            }
        }))
        
        self.present(alert, animated: true)
        
        let jsonEncoder = JSONEncoder()
        //jsonEncoder.outputFormatting = .prettyPrinted
        allData.allViews.removeAll()
        
        for view in views{
            viewsAndData[view]?.text = view.textView.text
            allData.allViews.append(viewsAndData[view]!)
        }
        self.jsonData = try? jsonEncoder.encode(allData.allViews)
        
        print(String(data: jsonData!, encoding: .utf8)!)
        
    }
    
    @objc func load_action(_ sender: UITapGestureRecognizer) {
        let jsonDecoder = JSONDecoder()
        let decodedData = try? jsonDecoder.decode([uiViewData].self, from: self.jsonData!)
        allData.allViews = decodedData!
        print(allData.allViews)
        restoreState()
    }
    
    
    func restoreState() {
        views.removeAll()
        viewsAndData.removeAll()
        for view in (subView?.subviews)!{
            view.removeFromSuperview()
        }
        subView!.layer.sublayers = nil
        subView?.addSubview(gridView)
        
        for viewData in allData.allViews{
            add_a_shape(shape: viewData.shape, x: CGFloat(viewData.x), y: CGFloat(viewData.y
            ), width: CGFloat(viewData.width), height: CGFloat(viewData.height), withID:  viewData.id, withText: viewData.text)
        }
        disable_all()
        print(idAndView.count)
        
        
        for viewData in allData.allViews{
            var firstCircle: CircleView
            var secondCircle: CircleView
            if viewData.leftLine.id != 0, viewData.leftLine.isSrc == true{
                firstCircle = idAndView[viewData.id]!.circles[0]
                for viewData2 in allData.allViews{
                    if viewData2.leftLine.id == viewData.leftLine.id, viewData2.leftLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[0]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.topLine.id == viewData.leftLine.id, viewData2.topLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[1]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.bottomLine.id == viewData.leftLine.id, viewData2.bottomLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[2]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.rightLine.id == viewData.leftLine.id, viewData2.rightLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[3]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)

                    }
                }
            }
            if viewData.topLine.id != 0, viewData.topLine.isSrc == true{
                print("found first line point")
                firstCircle = idAndView[viewData.id]!.circles[1]
                for viewData2 in allData.allViews{
                    if viewData2.leftLine.id == viewData.topLine.id, viewData2.leftLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[0]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)

                    }
                    if viewData2.topLine.id == viewData.topLine.id, viewData2.topLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[1]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.bottomLine.id == viewData.topLine.id, viewData2.bottomLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[2]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.rightLine.id == viewData.topLine.id, viewData2.rightLine.isSrc == false{
                        print("found second line")
                        secondCircle = idAndView[viewData2.id]!.circles[3]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                }
            }
            if viewData.bottomLine.id != 0, viewData.bottomLine.isSrc == true{
                firstCircle = idAndView[viewData.id]!.circles[2]
                for viewData2 in allData.allViews{
                    if viewData2.leftLine.id == viewData.bottomLine.id, viewData2.leftLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[0]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.topLine.id == viewData.bottomLine.id, viewData2.topLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[1]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.bottomLine.id == viewData.bottomLine.id, viewData2.bottomLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[2]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.rightLine.id == viewData.bottomLine.id, viewData2.rightLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[3]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                }
            }
            if viewData.rightLine.id != 0, viewData.rightLine.isSrc == true{
                firstCircle = idAndView[viewData.id]!.circles[3]
                for viewData2 in allData.allViews{
                    if viewData2.leftLine.id == viewData.rightLine.id, viewData2.leftLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[0]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.topLine.id == viewData.rightLine.id, viewData2.topLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[1]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.bottomLine.id == viewData.rightLine.id, viewData2.bottomLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[2]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                    if viewData2.rightLine.id == viewData.rightLine.id, viewData2.rightLine.isSrc == false{
                        secondCircle = idAndView[viewData2.id]!.circles[3]
                        subView!.layer.addSublayer(firstCircle.lineTo(circle: secondCircle))
                        addLineData(from: firstCircle, to: secondCircle)
                    }
                }
            }
        }

//        subView!.layer.addSublayer((firstCircle?.lineTo(circle: secondCircle!))! )
        
    }
    
}


extension FloatingPoint {
    func rounded(to value: Self, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self{
        return (self / value).rounded(roundingRule) * value
        
    }
}

extension CGPoint {
    func rounded(to value: CGFloat, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> CGPoint{
        return CGPoint(x: CGFloat((self.x / value).rounded(.toNearestOrAwayFromZero) * value), y: CGFloat((self.y / value).rounded(.toNearestOrAwayFromZero) * value))
    }
}

extension CGRect {
    func rounded(to value: CGFloat, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> CGRect{
        return CGRect(x: self.origin.x, y: self.origin.y, width: CGFloat((self.width / value).rounded(.toNearestOrAwayFromZero) * value), height: CGFloat((self.height / value).rounded(.toNearestOrAwayFromZero) * value))
    }
}

extension Array{
    mutating func removeObjFromArray<U: Equatable>(object: U){
        var index: Int?
        for (idx, objectToCompare) in self.enumerated(){
            if let to = objectToCompare as? U{
                if object == to{
                    index = idx
                }
            }
        }
        
        if index != nil {
            self.remove(at: index!)
        }
    }
}
