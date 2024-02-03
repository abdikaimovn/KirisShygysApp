//
//  CustomTabBar.swift
//  KirisShygysAppStore
//
//  Created by Нурдаулет on 03.02.2024.
//

import UIKit

final class CustomTabBar: UITabBar {
    private var shapeLayer: CAShapeLayer?
    
    override func draw(_ rect: CGRect) {
        addShape()
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.lightGrayColor.cgColor
        shapeLayer.lineWidth = 2.0
        self.layer.insertSublayer(shapeLayer, at: 0)
        
        self.shapeLayer = shapeLayer
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = createMaskPath()
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.lineWidth = 0
        maskLayer.backgroundColor = UIColor.clear.cgColor
        self.layer.insertSublayer(maskLayer, above: shapeLayer)
    }
    
    private func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    private func createMaskPath() -> CGPath {
        let height: CGFloat = 34.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.close()
        
        return path.cgPath
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extendedBounds = bounds.insetBy(dx: -30, dy: -30)
        return extendedBounds.contains(point)
    }
}
