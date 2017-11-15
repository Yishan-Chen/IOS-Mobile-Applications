//
//  LineView.swift
//  lab3
//
//  Created by Labuser on 2/13/17.
//  Copyright © 2017 wustl. All rights reserved.
//

import UIKit

class LineView: UIView {
    var array:[CGPoint]?{
        didSet {
            setNeedsDisplay()
        }
    }
    var lineColor: UIColor?
    var lineSize : CGFloat?
    
    init(frame: CGRect, size: CGFloat, color: UIColor){
        super.init(frame: frame)
        lineSize = size
        lineColor = color
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
       
        if array!.count == 1 {
            let path = UIBezierPath()
            path.addArc(withCenter: array![0], radius: lineSize!/2,
                        startAngle: 0, endAngle: CGFloat(M_PI * 2) , clockwise: false)
            lineColor!.setStroke()
            path.fill()
        } else if array!.count > 1{
            let path = createQuadPath(points: array!)
            lineColor!.setStroke()
            path.lineWidth = lineSize!
            path.stroke()
        } else {}
        
    }
    
    private func midpoint(first: CGPoint, second: CGPoint) -> CGPoint {
        var midpoint = CGPoint.zero;
        midpoint.x = (first.x + second.x) / 2
        midpoint.y = (first.y + second.y) / 2
        return midpoint
    }
    
    func createQuadPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        if points.count < 2 { return path }
        let firstPoint = points[0]
        let secondPoint = points[1]
        let firstMidpoint = midpoint(first: firstPoint, second: secondPoint)
        path.move(to: firstPoint)
        path.addLine(to: firstMidpoint)
        for index in 1 ..< points.count-1 {
            let currentPoint = points[index]
            let nextPoint = points[index + 1]
            let midPoint = midpoint(first: currentPoint, second: nextPoint)
            path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
        }
        guard let lastLocation = points.last else { return path }
        path.addLine(to: lastLocation)
        return path
    }
}
