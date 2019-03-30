//
//  ArrowShape.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 26/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

class ArrowShape: CAShapeLayer, UIGestureRecognizerDelegate {
    var point: CGPoint?{
        didSet{
            setNeedsDisplay()
        }
    }
    var circle: CircleView?
    var delete: CircleView?
    var subView: UIView?
    var viewsHidden: Bool!
    var inputCircle: CircleView!
    var outputCircle: CircleView!
    
    var mainPath: CGPath!{
        didSet{
            self.path = mainPath
//            self.strokeColor = mainStroke
//            self.fillColor = mainFill
        }
    }
    var alternatePath: CGPath!{
        didSet{
            
            thinArrow?.path = alternatePath
//            thinArrow.strokeColor = altStroke
//            thinArrow.fillColor = altFill
        }
    }
    var expand: CircleView?
    var setAlternatePath = false
    var thinArrow: CAShapeLayer!
    override init() {
        print("init arrow")
        super.init()
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = UIColor.clear.cgColor
        self.lineWidth = 2.0
        thinArrow = CAShapeLayer()
        thinArrow.path = alternatePath
        thinArrow.fillColor = UIColor.black.cgColor
        thinArrow.strokeColor = UIColor.black.cgColor
        thinArrow.lineWidth = 2.0
        self.addSublayer(thinArrow)
    }
    
    override init(layer: Any) {
        print("override init arrow")
        super.init(layer: layer)
        
        guard layer is ArrowShape else { return }
    }
    
    convenience init(withPoint point: CGPoint , inputCircle: CircleView, outputCircle: CircleView) {
        print("convenience init arrow")
        self.init()
        self.point = point
        self.viewsHidden = false
        self.inputCircle = inputCircle
        self.outputCircle = outputCircle
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func createCircles(){
        circle = CircleView(frame: CGRect(x: point!.x+20, y: point!.y+20, width: 40, height: 40))
        circle?.mainPoint = point
        delete = CircleView(frame: CGRect(x: point!.x+60, y: point!.y+20, width: 40, height: 40), isDelete: true)
        delete?.myLayer = self
        
        expand = CircleView(frame: CGRect(x: point!.x+100, y: point!.y+20, width: 40, height: 40), isExpand: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapExpand))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        expand?.addGestureRecognizer(tapGesture)
        disable_resize()
        if self.subView != nil {
            self.subView?.addSubview(circle!)
            self.subView?.addSubview(delete!)
            self.subView?.addSubview(expand!)
        }
    }
    
    
    @objc func tapExpand(_ sender: UITapGestureRecognizer){
        print("expand touched")
        if self.strokeColor == UIColor.black.cgColor{

            self.strokeColor = UIColor.clear.cgColor
            thinArrow.strokeColor = UIColor.black.cgColor
            thinArrow.fillColor = UIColor.black.cgColor

        }else{

            self.strokeColor = UIColor.black.cgColor
            thinArrow.strokeColor = UIColor.clear.cgColor
            thinArrow.fillColor = UIColor.clear.cgColor

        }
//        self.setAlternatePath = !self.setAlternatePath
//        let tempPath = self.path
//        self.path = alternatePath
//        alternatePath  = tempPath
        setNeedsDisplay()
    }
    
    func setSubView(_ view : UIView){
        self.subView = view
    }
    
    func updateViews(withPoint: CGPoint){
        self.point = withPoint
        circle?.mainPoint = point
        circle?.frame = CGRect(x: point!.x+20, y: point!.y+20, width: 40, height: 40)
        delete?.frame = CGRect(x: point!.x+60, y: point!.y+20, width: 40, height: 40)
        expand?.frame = CGRect(x: point!.x+100, y: point!.y+20, width: 40, height: 40)
    }
    
    
    func disable_resize() {
        self.viewsHidden = true
        self.circle?.isHidden = true
        self.delete?.isHidden = true
        self.expand?.isHidden = true
    }
    
    func enable_resize() {
        self.viewsHidden = false
        self.circle?.isHidden = false
        self.delete?.isHidden = false
        self.expand?.isHidden = false
    }
    
    
    
    static func getArrowpoints(inSide: sides.RawValue, outSide: sides.RawValue, from circle1: CircleView, to circle2: CircleView) -> [CGPoint] {
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        
        var arrowFlag = false
        
        
        
        let start = circle1.mainPoint!
        let end = circle2.mainPoint!
        var _start: CGPoint!
        var _end: CGPoint!
        var points1 = [CGPoint]()
        var points2 = [CGPoint]()
        
        points1.append(start)
        points2.append(end)
        switch inSide {
        case sides.left.rawValue:
            _start = CGPoint(x: start.x - 40, y: start.y)
        case sides.right.rawValue:
            _start = CGPoint(x: start.x + 40, y: start.y)
        case sides.top.rawValue:
            _start = CGPoint(x: start.x, y: start.y - 40)
        case sides.bottom.rawValue:
            _start = CGPoint(x: start.x, y: start.y + 40)
        default:
            _start = start
        }
        
        switch outSide {
        case sides.left.rawValue:
            _end = CGPoint(x: end.x - 40, y: end.y)
        case sides.right.rawValue:
            _end = CGPoint(x: end.x + 40, y: end.y)
        case sides.top.rawValue:
            _end = CGPoint(x: end.x, y: end.y - 40)
        case sides.bottom.rawValue:
            _end = CGPoint(x: end.x, y: end.y + 40)
        default:
            _end = end
        }
        let dx = _start.x - _end.x
        let dy = _start.y - _end.y
        
        points1.append(_start)
        points2.append(_end)
        
        //Bottom Right Quadrant
        if dx <= 0, dy <= 0{
            if inSide == sides.left.rawValue, outSide == sides.left.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50 , roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.top.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.right.rawValue {
                if _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) ])
                    
                    
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)),  p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.bottom.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) , p(_end.x ,(_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) )])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.right.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _start.y), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.right.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _start.y), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.right.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _start.y), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
            }
            else{
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            
        }
            
        //Top Right Quadrant
        else if dx <= 0, dy >= 0 {
            if inSide == sides.left.rawValue, outSide == sides.left.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50 , roundingRule: .towardZero))])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.top.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.right.rawValue {
                if _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) ])
                    
                    
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)),  p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.bottom.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 50 , (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y) ])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.right.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.right.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.left.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _start.y ), p(_end.x - ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) - 50, _end.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.right.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100 , _start.y) , p(_end.x - (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) - 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else{
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
        }
            
            
        //Top Left Quadrant
        else if dx >= 0, dy >= 0{
            if inSide == sides.left.rawValue, outSide == sides.left.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _start.y), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
            }
            else if inSide == sides.left.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.left.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.left.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _start.y), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            if inSide == sides.right.rawValue, outSide == sides.left.rawValue {
                if _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) ])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)),  p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.top.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)) , p(_end.x ,(_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) )])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.right.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50 , roundingRule: .towardZero))])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.bottom.rawValue {
                if _end.y > (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, (_start.y - (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .towardZero)), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.left.rawValue {
                if (_end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) > _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y + ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _start.y), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else{
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
        }
            
        //Bottom Left Quadrant
        else if dx >= 0, dy <= 0{
            if inSide == sides.left.rawValue, outSide == sides.left.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.left.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.left.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.left.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.left.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.top.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.top.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _start.y ), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
            }
            else if inSide == sides.right.rawValue, outSide == sides.left.rawValue {
                if _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) ])
                    
                    
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)),  p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.top.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 50 , (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y) ])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.right.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50 , roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.right.rawValue, outSide == sides.bottom.rawValue {
                if _end.y < (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero) {
                    points1.append(contentsOf: [p(_start.x, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, (_start.y + (circle1.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x + ((circle2.myView?.frame.width)!/2).rounded(to: 50, roundingRule: .awayFromZero) + 50, _end.y)])
                }
                else{
                    points1.append(contentsOf: [p(_start.x, _end.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.left.rawValue {
                if (_end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)) < _start.y {
                    points1.append(contentsOf: [p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100 , _start.y) , p(_end.x + (circle2.myView?.frame.width)!.rounded(to: 50, roundingRule: .awayFromZero) + 100, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero)), p(_end.x, _end.y - ((circle2.myView?.frame.height)!/2).rounded(to: 50, roundingRule: .awayFromZero))])
                }
                else{
                    points1.append(contentsOf: [p(_end.x, _start.y)])
                }
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.top.rawValue {
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.right.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else if inSide == sides.bottom.rawValue, outSide == sides.bottom.rawValue {
                points1.append(contentsOf: [p(_start.x, _end.y)])
            }
            else{
                points1.append(contentsOf: [p(_end.x, _start.y)])
            }
        }
        points1.append(contentsOf: points2.reversed())
        return points1
    }

}
