// Extension to BezierPath to draw custom arrow path

import UIKit

extension UIBezierPath {
    
    class func arrow2(from start: CGPoint, to end: CGPoint, circle1 : CircleView, circle2 : CircleView) -> Self {
        
        let dx = start.x - end.x
        let dy = start.y - end.y
        var srcType = 0   // 1- top plus||| 2- right||| 3- bottom||| 4 - right
        var dstType = 0
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        
        
        if circle1.mainPoint!.x == circle1.center.x {
            if circle1.mainPoint!.y < circle1.center.y{
                srcType = 3
            }
            else{
                srcType = 1
            }
        }
        else{
            if circle1.mainPoint!.x < circle1.center.x{
                srcType = 2
            }
            else{
                srcType = 4
            }
        }
        
        
        if circle2.mainPoint!.x == circle2.center.x {
            if circle2.mainPoint!.y < circle2.center.y{
                dstType = 3
            }
            else{
                dstType = 1
            }
        }
        else{
            if circle2.mainPoint!.x < circle2.center.x{
                dstType = 2
            }
            else{
                dstType = 4
            }
        }
        
        
//        print("src type = \(srcType) and dst type = \(dstType)")
        
        if dx <= 0 , dy <= 0 {
            if srcType == 1 && dstType == 1{
                let path = CGMutablePath()
                let points: [CGPoint] = [
                p(circle1.mainPoint!.x , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x - 1 , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x - 1, circle1.mainPoint!.y - 55),
                p(circle2.mainPoint!.x + 1, circle1.mainPoint!.y - 55),
                p(circle2.mainPoint!.x + 1, circle2.mainPoint!.y - 15),
                p(circle2.mainPoint!.x + 15 , circle2.mainPoint!.y - 15),
                p(circle2.mainPoint!.x , circle2.mainPoint!.y),
                p(circle2.mainPoint!.x - 15,circle2.mainPoint!.y - 15),
                p(circle2.mainPoint!.x - 1 , circle2.mainPoint!.y - 15),
                p(circle2.mainPoint!.x - 1, circle1.mainPoint!.y - 55 + 2),
                p(circle1.mainPoint!.x + 1, circle1.mainPoint!.y - 55 + 2),
                p(circle1.mainPoint!.x + 1, circle1.mainPoint!.y),
                p(circle1.mainPoint!.x , circle1.mainPoint!.y),
                ]
                path.addLines(between: points)
                return self.init(cgPath: path)
            }
            if srcType == 1 && dstType == 4{
                let path = CGMutablePath()
                let points: [CGPoint] = [
                p(circle1.mainPoint!.x , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x + 1 , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x + 1, circle1.mainPoint!.y - 55),
                p(circle2.mainPoint!.x - 55 - 1, circle1.mainPoint!.y - 55),
                p(circle2.mainPoint!.x - 55 - 1, circle2.mainPoint!.y + 1),
                p(circle2.mainPoint!.x - 15, circle2.mainPoint!.y + 1),
                p(circle2.mainPoint!.x - 15, circle2.mainPoint!.y + 15),
                p(circle2.mainPoint!.x , circle2.mainPoint!.y),
                p(circle2.mainPoint!.x - 15, circle2.mainPoint!.y - 15),
                p(circle2.mainPoint!.x - 15, circle2.mainPoint!.y - 1),
                p(circle2.mainPoint!.x - 55 + 1, circle2.mainPoint!.y - 1),
                p(circle2.mainPoint!.x - 55 + 1, circle1.mainPoint!.y - 55 - 2),
                p(circle1.mainPoint!.x - 1, circle1.mainPoint!.y - 55 - 2),
                p(circle1.mainPoint!.x - 1 , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x , circle1.mainPoint!.y),
                ]
                path.addLines(between: points)
                return self.init(cgPath: path)
            }
            
            if srcType == 1 && dstType == 3{
                let path = CGMutablePath()
                let points: [CGPoint] = [
                p(circle1.mainPoint!.x , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x + 1 , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x + 1 , circle1.mainPoint!.y - 55),
                p(circle2.mainPoint!.x - circle2.myView!.bounds.width/2 - 55 - 1 , circle1.mainPoint!.y - 55),
                p(circle2.mainPoint!.x - circle2.myView!.bounds.width/2 - 55 - 1 , circle2.mainPoint!.y + 55 + 1),
                p(circle2.mainPoint!.x + 1 , circle2.mainPoint!.y + 55 + 1),
                p(circle2.mainPoint!.x + 1 , circle2.mainPoint!.y + 15),
                p(circle2.mainPoint!.x + 15 , circle2.mainPoint!.y + 15),
                p(circle2.mainPoint!.x , circle2.mainPoint!.y),
                p(circle2.mainPoint!.x - 15 , circle2.mainPoint!.y + 15),
                p(circle2.mainPoint!.x - 1 , circle2.mainPoint!.y + 15),
                p(circle2.mainPoint!.x - 1 , circle2.mainPoint!.y + 55 - 1),
                p(circle2.mainPoint!.x - circle2.myView!.bounds.width/2 - 55 + 1 , circle2.mainPoint!.y + 55 - 1),
                p(circle2.mainPoint!.x - circle2.myView!.bounds.width/2 - 55 + 1 , circle1.mainPoint!.y - 55 - 2),
                p(circle1.mainPoint!.x - 1 , circle1.mainPoint!.y - 55 - 2),
                p(circle1.mainPoint!.x - 1 , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x , circle1.mainPoint!.y),
                ]
                path.addLines(between: points)
                return self.init(cgPath: path)
            }
            
            if srcType == 1 && dstType == 2{
                let path = CGMutablePath()
                let points: [CGPoint] = [
                p(circle1.mainPoint!.x , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x + 1 , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x + 1 , circle1.mainPoint!.y - 55),
                p(circle2.mainPoint!.x + 55 - 1 , circle1.mainPoint!.y - 55),
                p(circle2.mainPoint!.x + 55 - 1 , circle2.mainPoint!.y - 1),
                p(circle2.mainPoint!.x + 15 , circle2.mainPoint!.y - 1),
                p(circle2.mainPoint!.x + 15 , circle2.mainPoint!.y - 15),
                p(circle2.mainPoint!.x , circle2.mainPoint!.y),
                p(circle2.mainPoint!.x + 15 , circle2.mainPoint!.y + 15),
                p(circle2.mainPoint!.x + 15 , circle2.mainPoint!.y + 1),
                p(circle2.mainPoint!.x + 55 + 1 , circle2.mainPoint!.y + 1),
                p(circle2.mainPoint!.x + 55 + 1 , circle1.mainPoint!.y - 55 - 2),
                p(circle1.mainPoint!.x - 1 , circle1.mainPoint!.y - 55 - 2),
                p(circle1.mainPoint!.x - 1 , circle1.mainPoint!.y),
                p(circle1.mainPoint!.x , circle1.mainPoint!.y),
                ]
                path.addLines(between: points)
                return self.init(cgPath: path)
            }
            
        }
        
        
        
        
        
//        let length = hypot(end.x - start.x, end.y - start.y)
//        let tailLength = length - headLength
//
//        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
//        let points: [CGPoint] = [
//            p(0, tailWidth / 2),
//            p(tailLength, tailWidth / 2),
//            p(tailLength, headWidth / 2),
//            p(length, 0),
//            p(tailLength, -headWidth / 2),
//            p(tailLength, -tailWidth / 2),
//            p(0, -tailWidth / 2)
//        ]
//
//        let cosine = (end.x - start.x) / length
//        let sine = (end.y - start.y) / length
//        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
//
        let path = CGMutablePath()
//        path.addLines(between: points, transform: transform )
//        path.closeSubpath()
        return self.init(cgPath: path)
    }
    
}
