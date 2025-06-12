
//
//  UIView+Extensions.swift
//  GoferEats
//
//  Created by trioangle on 16/04/20.
//  Copyright © 2020 Balajibabu. All rights reserved.
//

import Foundation
import UIKit

private var AssociatedObjectHandle: UInt8 = 25
private var ButtonAssociatedObjectHandle: UInt8 = 10

extension UIView{
    func setSpecificCorners() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 35
        self.layer.maskedCorners = [.layerMaxXMinYCorner,
                                    .layerMinXMinYCorner] // Top right corner, Top left corner respectively
    }
    
}


extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}



extension UIViewController {
    var sharedUtilities : Utilities{
        return Utilities.sharedInstance
    }
    var sharedVariable: SharedVariables {
        return SharedVariables.sharedInstance
    }
    
    var sharedAppdelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func setSemantic(_ val : Bool)->Bool{//If semantic is set to RTL returns true
        if val{
            if isRTLLanguage {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                return true
            }else{
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                return false
            }
        }else{
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft{
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                return true
            }
            return false
        }
        
    }
}

extension UILabel {
    func customFont(_ name:CustomFont,
                    textColor: UIColor = UIColor.IndicatorColor) {
        self.font = UIFont(name: name.instance,
                           size: self.font.pointSize)
        self.textColor = textColor
    }
}


extension UIViewController {
    func dynamicHeight(tempModelArray:[String]) -> CGFloat{
        var text = ""
        let textArray = tempModelArray.map({$0.count})
        if let index = tempModelArray.firstIndex(where:{$0.count == textArray.max()}){
            text = tempModelArray[index]
        }
        let customWidth = (self.view.frame.width / 2.0) - 5
        let customHeight = text.heightWithConstrainedWidth(width: customWidth, font: UIFont(name: CustomFont.bold.instance, size: 13.0)!) + customWidth + 5
        
        return customHeight
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
}
private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&pound;"    : "£",
    "&euro;"     : "€",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]






extension UIViewController {
  
 
    
    var roundBox : CheckImage{
        return .round
        //            (UIImage(named: "check_selected")?.withRenderingMode(.alwaysTemplate))!
    }
    
    var checkBox :CheckImage {
        return .checkBox
        //            (UIImage(named: "check_deselected")?.withRenderingMode(.alwaysTemplate))!
    }
    
//    var dropDownImage:UIImage {
//        return (UIImage(named: "down-arrow1.png")?.withRenderingMode(.alwaysTemplate))!
//    }
//
//    var closeImage:UIImage {
//        return (UIImage(named: "close_icon.png")?.withRenderingMode(.alwaysTemplate))!
//    }
    
}

extension UIView {
    func viewOfType<T:UIView>(type:T.Type, process: (_ view:T) -> Void)
    {
        if let view = self as? T
        {
            process(view)
        }
        else {
            for subView in subviews
            {
                subView.viewOfType(type:type, process:process)
            }
        }
    }
    
}
//extension UIStoryboard {
//    static var karuppasamy : UIStoryboard{
//        return UIStoryboard(name: "Karuppasamy", bundle: nil)
//    }
//    static var Ismayil : UIStoryboard{
//        return UIStoryboard(name: "Main", bundle: nil)
//    }
//}
extension UIView {
    
    
    
    
    func StatusBarColor()
    {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared.windows.first { $0.isKeyWindow }
            let statusBarHeight: CGFloat = (app?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = #colorLiteral(red: 0.6941176471, green: 0.137254902, blue: 0.1450980392, alpha: 1)
            self.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: self.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: self.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = #colorLiteral(red: 0.6941176471, green: 0.137254902, blue: 0.1450980392, alpha: 1)
        }
    }
    
}

//Mark:- Tap Gestures

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}

//Mark:- Shadow effect

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

//Mark:- Rotate Animation

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
//        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}





extension UIView {
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
        
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func removeAddedBorder() {
        self.layer.sublayers?.popLast()
    }
    
    func setCornerRadius(borderColor:UIColor,borderWidth:CGFloat,cornerRadius:CGFloat) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
 
}


extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
    
    func rounderCornerTrying(_ corners:UIRectCorner, radius: CGSize){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension UIView {
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 5.0, height: 1.0)
    }
}
extension UIView {
func addBottomShadow() {
   layer.masksToBounds = false
    layer.shadowRadius = 4
    layer.shadowOpacity = 1
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize(width: 0 , height: 2)
    layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                 y: bounds.maxY - layer.shadowRadius,
                                                 width: bounds.width,
                                                 height: layer.shadowRadius)).cgPath
}
}


extension UIView {
    func isChangeArabicButton() {
        
        if Languages.RTL.instance == .forceRightToLeft {
            self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
           
        }else {
            self.transform = .identity
        
        }
    }
}




extension UIView {
    func getViewExactHeight(view:UIView)->UIView {
        
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = view.frame
        if height != frame.size.height {
            frame.size.height = height
            view.frame = frame
        }
        return view
    }
}

extension UIView{
  
 
    
    var roundBox : CheckImage{
        return .round
        //            (UIImage(named: "check_selected")?.withRenderingMode(.alwaysTemplate))!
    }
    
    var checkBox :CheckImage {
        return .checkBox
        //            (UIImage(named: "check_deselected")?.withRenderingMode(.alwaysTemplate))!
    }
    
//    var dropDownImage:UIImage {
//        return (UIImage(named: "down-arrow1.png")?.withRenderingMode(.alwaysTemplate))!
//    }
//
//    var closeImage:UIImage {
//        return (UIImage(named: "close_icon.png")?.withRenderingMode(.alwaysTemplate))!
//    }
    
}
extension UIView{
   
    var sharedUtilities : Utilities{
        return Utilities.sharedInstance
    }
}
