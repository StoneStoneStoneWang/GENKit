//
//  WLDrawStyle1View.swift
//  WLCompoentViewDemo
//
//  Created by three stone 王 on 2019/4/17.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import UIKit

@objc public enum FBDrawType: Int {
    
    case shape
}

@objc (FBDrawView)
public final class FBDrawView: UIView {
    
    @objc public static func createDraw(_ drawType: FBDrawType) -> FBDrawView {
        
        return Self.init(drawType)
    }
    
    private var drawType: FBDrawType = .shape
    
    @objc public var drawRadius: CGFloat = 20
    
    @objc (fillColor)
    public var fillColor: UIColor = .white {
        
        willSet {
            
            setNeedsDisplay()
        }
    }
    private convenience init(_ drawType: FBDrawType) {
        self.init(frame: .zero)
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FBDrawView {
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if drawType == .shape {
            
            let pi:CGFloat = CGFloat(Double.pi)
            
            fillColor.setFill()
            
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            // MARK: draw highlighted
            // 0 开始的点
            context.move(to: CGPoint(x: bounds.minX, y: bounds.minY + drawRadius))
            // 1  左线
            context.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY * 3 / 4 - drawRadius ))
            // 2  左下圆角
            context.addArc(center: CGPoint(x: bounds.minX + drawRadius, y: bounds.maxY * 3 / 4 ), radius: drawRadius, startAngle: pi, endAngle: pi / 2 + pi / 10, clockwise: true)
            // 3 下线
            context.addLine(to: CGPoint(x: bounds.maxX - drawRadius, y: bounds.maxY))
            // 4 右下圆角
            context.addArc(center: CGPoint(x: bounds.maxX - drawRadius, y: bounds.maxY - drawRadius), radius: drawRadius, startAngle: pi / 2, endAngle: 0, clockwise: true)
            // 5 右线
            context.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY + drawRadius))
            // 5 右上圆角
            context.addArc(center: CGPoint(x: bounds.maxX - drawRadius, y: bounds.minY + drawRadius), radius: drawRadius, startAngle: 0.0, endAngle: -pi / 2, clockwise: true)
            // 6 上线
            context.addLine(to: CGPoint(x: bounds.minX + drawRadius, y:bounds.minY))
            // 7 左上圆角
            context.addArc(center: CGPoint(x: bounds.minX + drawRadius, y: bounds.minY + drawRadius), radius: drawRadius, startAngle: -pi / 2, endAngle: pi, clockwise: true)
            
            context.fillPath()
        }
        
    }
}
