//
//  Ex + UIView.swift
//  Goferjek
//
//  Created by Trioangle on 03/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit


private var AssociatedObjectHandle: UInt8 = 25
private var ButtonAssociatedObjectHandle: UInt8 = 10
public enum closureActions : Int{
    case none = 0
    case tap = 1
    case swipe_left = 2
    case swipe_right = 3
    case swipe_down = 4
    case swipe_up = 5
}
public struct closure {
    typealias emptyCallback = ()->()
    static var actionDict = [Int:[closureActions : emptyCallback]]()
    static var btnActionDict = [Int:[String: emptyCallback]]()
}

extension UIView {
    
    /// Note : - Variable used For Set CornerRadius in all Views
    var cornerRadius : CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    /// Note : - Variable used For Set Border Width Alone in all Views
    var borderWidth : CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /// Note : - Variable used For Set Border Color Alone in all Views
    var borderColor : UIColor? {
        get { return UIColor(cgColor: self.layer.shadowColor!) }
        set {
            layer.borderColor = newValue?.cgColor
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /// Note : - Method used For Set Border in all Views
    /// Default Values :- Color 'black' and width '1'
    func border(width: CGFloat = 1,
                color: UIColor = .black) {
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func elevate(_ elevation : CGFloat,
                 radius : CGFloat,
                 opacity : Float = 0.3,
                 fillcolor : UIColor = .clear,
                 shadowColor : UIColor = .darkGray){
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: self.bounds,
                                            cornerRadius: radius).cgPath
            shadowLayer.fillColor = fillcolor.cgColor
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shouldRasterize = true
            shadowLayer.rasterizationScale = UIScreen.main.scale
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: elevation, height: elevation)
            shadowLayer.shadowOpacity = opacity
            shadowLayer.shadowRadius = elevation
            self.layer.sublayers?.forEach({ (sub) in
                sub.removeFromSuperlayer()
            })
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    var closureId:Int{
        get {
            let value = objc_getAssociatedObject(self,
                                                 &AssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObjectHandle,
                                     newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func actionHandleBlocks(_ type : closureActions = .none,
                            action:(() -> Void)? = nil) {
        
        if type == .none { return }
        var actionDict : [closureActions : closure.emptyCallback]
        if self.closureId == Int(){
            self.closureId = closure.actionDict.count + 1
            closure.actionDict[self.closureId] = [:]
        }
        if action != nil {
            actionDict = closure.actionDict[self.closureId]!
            actionDict[type] = action
            closure.actionDict[self.closureId] = actionDict
        } else {
            let valueForId = closure.actionDict[self.closureId]
            if let exe = valueForId![type]{
                exe()
            }
        }
    }
    
    @objc
    func triggerTapActionHandleBlocks() {
        self.actionHandleBlocks(.tap)
    }
    
    @objc
    func triggerSwipeLeftActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_left)
    }
    
    @objc
    func triggerSwipeRightActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_right)
    }
    
    @objc
    func triggerSwipeUpActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_up)
    }
    
    @objc
    func triggerSwipeDownActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_down)
    }
    
    open
    func addAction(for type: closureActions ,
                   Action action:@escaping() -> Void) {
        self.isUserInteractionEnabled = true
        self.actionHandleBlocks(type,action:action)
        switch type{
        case .none:
            return
        case .tap:
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self,
                              action: #selector(triggerTapActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_left:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.left
            gesture.addTarget(self,
                              action: #selector(triggerSwipeLeftActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_right:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.right
            gesture.addTarget(self,
                              action: #selector(triggerSwipeRightActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_up:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.up
            gesture.addTarget(self,
                              action: #selector(triggerSwipeUpActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_down:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.down
            gesture.addTarget(self,
                              action: #selector(triggerSwipeDownActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        }
    }
}
