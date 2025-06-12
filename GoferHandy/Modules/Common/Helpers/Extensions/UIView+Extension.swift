//
//  UIView+Extension.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
        
    @IBInspectable
        var isRounded: Bool{
        get{
            return layer.cornerRadius == frame.width * 0.5
        }
        set{
            if newValue{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
                    self.layer.cornerRadius = self.frame.width * 0.5
                }
            }else{
//                layer.cornerRadius = 0.0
            }
        }
    }
   
    
    // The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    //The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowOpacity = newValue
        }
    }
    
    //The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowOffset = newValue
        }
    }
    
    //The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable
    var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
    
    func anchor(toView : UIView,
                leading : CGFloat? = nil,
                trailing : CGFloat? = nil,
                top : CGFloat? = nil,
                bottom : CGFloat? = nil){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let _leading = leading{
            self.leadingAnchor
                .constraint(equalTo: toView.leadingAnchor, constant: _leading)
                .isActive = true
        }
        if let _trailing = trailing{
            self.trailingAnchor
                .constraint(equalTo: toView.trailingAnchor, constant: _trailing)
                .isActive = true
        }
        if let _top = top{
            self.topAnchor
                .constraint(equalTo: toView.topAnchor, constant: _top)
                .isActive = true
        }
        if let _bottom = bottom{
            self.bottomAnchor
                .constraint(equalTo: toView.bottomAnchor, constant: _bottom)
                .isActive = true
        }
        
    }
   
    func setEqualHightWidthAnchor(toView : UIView,height: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: toView.heightAnchor).isActive = true
        if let _height = height {
            self.heightAnchor.constraint(equalToConstant: _height).isActive = true
        }
    }
    
    func setCenterXYAncher(toView : UIView,
                           centerX: Bool = false,
                           centerY: Bool = false) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if centerX {
            self.centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
        }
        if centerY {
            self.centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true
        }
    }
    
    
    func getSwipebleView(content: String) {
        enum state {
            case middle
            case full
        }
        
        var _ : state = .middle
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.addSubview(bgView)
        bgView.anchor(toView: self,
                      leading: 0,
                      trailing: 0,
                      top: 0,
                      bottom: 0)
        
        let contentView = UIView(frame: self.frame)
        bgView.addSubview(contentView)
        contentView.anchor(toView: bgView,
                           leading: 0,
                           trailing: 0,
                           top: 0,
                           bottom: 0)

        let label = UILabel(frame: self.frame)
        label.text = content
        label.numberOfLines = 0
//        label.textAlignment = .justified
        contentView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        label.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        label.font = AppTheme.Fontlight(size: 15).font
        label.textAlignment = .left
        contentView.addSubview(label)
        label.anchor(toView : contentView,
                     leading : 10,
                     trailing : -10,
                     top : 10)
        label.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor,
                                      constant: -10).isActive = true
       
        // Inital View Postion
        contentView.frame.origin.y = self.frame.maxY * 1.5
        
        UIView.animate(withDuration: 0.5) {
            contentView.frame.origin.y = self.frame.midY
        } completion: { (completed) in
            print("Initiated SwipeView")
        }

        bgView.bringSubviewToFront(contentView)
        
      
    }
}

func cornerRadiusWithShadow(view: UIView){
    
    view.layer.cornerRadius = 12
    view.layer.masksToBounds = true;
    view.backgroundColor = view.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    view.layer.shadowColor = view.isDarkStyle ? UIColor.DarkModeBorderColor.cgColor : UIColor.TertiaryColor.withAlphaComponent(0.5).cgColor
    view.layer.shadowOpacity = 0.8
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.layer.shadowRadius = 6.0
    view.layer.masksToBounds = false
    
}


extension UIView {

    var isDarkStyle : Bool {
        get {
            self.traitCollection.userInterfaceStyle == .dark
        }
    }
    
    
    var isHiddenInStackView: Bool {
        get {
            return isHidden
        }
        set {
            if isHidden != newValue {
                isHidden = newValue
            }
        }
    }
    
    func setTopCorners(radius: CGFloat) {
        self.layer.maskedCorners = [.layerMinXMinYCorner,
                                    .layerMaxXMinYCorner]
        self.layer.cornerRadius = radius
    }
    func setBottomCorners(radius: CGFloat) {
        self.layer.maskedCorners = [.layerMaxXMaxYCorner,
                                    .layerMinXMaxYCorner]
        self.layer.cornerRadius = radius
    }
}
extension UITableView {
   func reloadDataWithAutoSizingCellWorkAround() {
       self.reloadData()
       self.setNeedsLayout()
       self.layoutIfNeeded()
       self.reloadData()
   }
}
extension UILabel {

    func calculateMaxLines() -> Int {
            let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
            let charSize = font.lineHeight
            let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? .systemFont(ofSize: self.font.pointSize)], context: nil)
            let linesRoundedUp = Int(ceil(textSize.height/charSize))
            return linesRoundedUp
        }
}
extension UITextView {
func calculateMaxLines() -> Int {
    guard let _font = font else { return 0 }
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = _font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? .systemFont(ofSize: _font.pointSize)], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
extension UIStackView {

    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }

}

extension UISearchBar {
    func setAlignment() {
        let searchTextField:UITextField = self.value(forKey: "searchField") as? UITextField ?? UITextField()
        let image = UIImage(named: "search_field")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        searchTextField.leftView = isRTLLanguage ? nil : imageView
        searchTextField.rightView = !isRTLLanguage ? nil : imageView
        searchTextField.leftViewMode = isRTLLanguage ? .never : .always
        searchTextField.rightViewMode = !isRTLLanguage ? .never : .always
        searchTextField.setTextAlignment()
    }
}

// EXTENSION UITEXTFIELD PADDING SUPPORT
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension UIImage {
    func template() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
             path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }

        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }

        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }

        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        path.closeSubpath()
        cgPath = path
    }
}

extension UIView{
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension UIViewController {
    func findLastBeforeVC() -> UIViewController? {
        if let controllers = self.navigationController?.viewControllers,
           controllers.count >= 2 {
            return controllers.value(atSafe: controllers.count - 2)
        } else {
            return self.navigationController?.viewControllers.last
        }
    }
    // Handy Splitup Start
//    func setRootVC() {
    func setRootVC(busnessType: BusinessType = AppWebConstants.businessType) {
        switch busnessType {
        case .Services:
            // break
            // Delivery Splitup Start

            if let vc = self.navigationController?.viewControllers.filter({$0.isKind(of: HandyHomeVC.self)}).first {
                self.navigationController?.popToViewController(vc,
                                        animated: true)
            } else {
                self.navigationController?.pushViewController(HandyHomeVC.initWithStory(),
                                         animated: true)
            }
        default:
            break
        }
        // Handy Splitup End
    }
}

extension UIViewController {
    func openThemeSheet() {
        let actionSheet = UIAlertController(title: LangCommon.changeTheme, message: "", preferredStyle: .actionSheet)
        let redThemeAction = UIAlertAction(title: "Brown \(LangCommon.theme)", style: .default) { (_) in
            UIColor.PrimaryColor = UIColor.init(hex: "964B00")
            UIColor.ThemeTextColor = UIColor.init(hex: "964B00")
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let yellowThemeAction = UIAlertAction(title: "Orange \(LangCommon.theme)", style: .default) { (_) in
            UIColor.PrimaryColor = UIColor.init(hex: "ff8308")
            UIColor.ThemeTextColor = UIColor.init(hex: "ff8308")
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let violatThemeAction = UIAlertAction(title: "Violat \(LangCommon.theme)", style: .default) { (_) in
            UIColor.PrimaryColor = UIColor.init(hex: "9909b3")
            UIColor.ThemeTextColor = UIColor.init(hex: "9909b3")
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let makeDefault = UIAlertAction(title: "Default \(LangCommon.theme)", style: .default) { (_) in
            UIColor.PrimaryColor = UIColor.init(hex: ThemeColors?.string("PrimaryColor"))
            UIColor.ThemeTextColor = UIColor.init(hex: ThemeColors?.string("ThemeTextColor"))
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let cancelThemesAction = UIAlertAction(title: "\(LangCommon.cancel)", style: .destructive) { (_) in
            print("Theme Canceled")
        }
        actionSheet.addAction(redThemeAction)
        actionSheet.addAction(yellowThemeAction)
        actionSheet.addAction(violatThemeAction)
        actionSheet.addAction(makeDefault)
        actionSheet.addAction(cancelThemesAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openChangeFontSheet() {
        let actionSheet = UIAlertController(title: LangCommon.changeFont, message: "", preferredStyle: .actionSheet)
        let ClanProFont = UIAlertAction(title: "Clan Pro \(LangCommon.font)", style: .default) { (_) in
            G_RegularFont = "ClanPro-Book"
            G_BoldFont = "ClanPro-Medium"
            G_MediumFont = "ClanPro-News"
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let GoogleSans = UIAlertAction(title: "Default \(LangCommon.font)", style: .default) { (_) in
            G_RegularFont = "ProductSans-Regular"
            G_BoldFont = "ProductSans-Bold"
            G_MediumFont = "ProductSans-Medium"
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let cancelThemesAction = UIAlertAction(title: "\(LangCommon.cancel)", style: .destructive) { (_) in
            print("Font Selection Canceled")
        }
        actionSheet.addAction(ClanProFont)
        actionSheet.addAction(GoogleSans)
        actionSheet.addAction(cancelThemesAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func checkMobileNumeber(isDirectCall:Bool = false) {
        
        guard let number : String = UserDefaults.value(for: .admin_mobile_number) else{return}
        let contactNumber = number.split(separator: " ").last ?? ""
        if number == "" {
            self.presentAlertWithTitle(title: LangCommon.noContactFound,
                                       message: "",
                                       options: LangCommon.ok) { (index) in
                switch index {
                    
                default:
                    break
                }
            }
        } else {
            if isDirectCall {
                if let phoneCallURL = URL(string:"tel://\(contactNumber)") {
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }
                }
            } else {
                self.presentAlertWithTitle(title: LangCommon.dial.capitalized + "\(contactNumber)",
                    message: LangCommon.contactAdmin,//"Contact admin for manual booking".localize
                    options: LangCommon.call.capitalized,LangCommon.cancel.capitalized) { (index) in
                        switch index{
                        case 0:
                            if let phoneCallURL = URL(string:"tel://\(contactNumber)") {
                                let application:UIApplication = UIApplication.shared
                                if (application.canOpenURL(phoneCallURL)) {
                                    application.open(phoneCallURL,
                                                     options: [:],
                                                     completionHandler: nil)
                                }
                            }
                        default:
                            break
                        }
                }
            }
        }
        
    }
}
