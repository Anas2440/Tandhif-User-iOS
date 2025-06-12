//
//  ReusableView.swift
//  Gofer
//
//  Created by trioangle on 16/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Extensions
protocol ReusableView: AnyObject {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
  
}
extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension ReusableView where Self : UIView {
     static func nib() -> UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
    static func getViewFromXib<T: ReusableView>() -> T?{
        return self.nib().instantiate(withOwner: nil, options: nil).first as? T
    }

    func setupFromNib<T: ReusableView & UIView>(_ object : T) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
            guard let view : T = Self.getViewFromXib(),
                !object.subviews.compactMap({$0.tag}).contains(2523143) else { fatalError("Error loading \(self) from nib") }
            view.tag = 2523143
            view.frame = object.bounds
            view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            object.addSubview(view)
            object.bringSubviewToFront(view)
      }
       
    }
}

// UIViewController.swift
extension UIViewController: ReusableView { }

// UIStoryboard.swift
extension UIStoryboard {
    
   
    // Gofer Splitup Start
    static var payment : UIStoryboard{
        return UIStoryboard(name: "Payment", bundle: nil)
    }
    static var tripBooking : UIStoryboard{
        return UIStoryboard(name: "TripBooking", bundle: nil)
    }
    static var trip : UIStoryboard{
        return UIStoryboard(name: "Trip", bundle: nil)
    }
    static var account : UIStoryboard{
        return UIStoryboard(name: "Account", bundle: nil)
    }
    // Gofer Splitup end
    static var gojekAccount : UIStoryboard{
        return UIStoryboard(name: "GoJek_Account", bundle: nil)
    }
    // Gofer Splitup Start
    static var gojekMain : UIStoryboard{
        return UIStoryboard(name: "GoJek_Main", bundle: nil)
    }
    static var gojekHandyUnique : UIStoryboard{
        return UIStoryboard(name: "GoJek_HandyUnique", bundle: nil)
    }
    
    static var kbabu : UIStoryboard{
        return UIStoryboard(name: "Kbabu", bundle: nil)
    }
    // Gofer Splitup end
    static var gojekCommon : UIStoryboard{
        return UIStoryboard(name: "GoJek_Common", bundle: nil)
    }
    // Gofer Splitup Start
    static var common : UIStoryboard{
        return UIStoryboard(name: "Common", bundle: nil)
    }
    static var handy : UIStoryboard{
        return UIStoryboard(name: "Handy", bundle: nil)
    }
    static var gojekDeliveryAllBooking : UIStoryboard {
        return UIStoryboard(name: "GojekDeliveryAllBooking", bundle: nil)
    }
    static var gojekHandyBooking : UIStoryboard{
        return UIStoryboard(name: "GoJek_HandyBooking", bundle: nil)
    }
    static var delivery : UIStoryboard{
        return UIStoryboard(name: "Delivery", bundle: nil)
    }
    static var karthi : UIStoryboard{
        return UIStoryboard(name: "Karthi", bundle: nil)
    }
  
    static var anush : UIStoryboard{
        return UIStoryboard(name: "Anush", bundle: nil)
    }
    static var gojekDeliveryAllUnique : UIStoryboard {
        return UIStoryboard(name: "GojekDeliveryAllUnique", bundle: nil)
    }
    static var damu : UIStoryboard{
        return UIStoryboard(name: "Damu", bundle: nil)
    }
    static var deliveryAll: UIStoryboard{
        return UIStoryboard(name: "DeliveryAll", bundle: nil)
    }
    static var gojekDeliveryBooking : UIStoryboard{
        return UIStoryboard(name: "GoJek_DeliveryBooking", bundle: nil)
    }
    // Gofer Splitup end
    static var yamini : UIStoryboard{
        return UIStoryboard(name: "Yamini", bundle: nil)
    }
    // Gofer Splitup Start
    static var YaminiGofer : UIStoryboard{
        return UIStoryboard(name: "YaminiGofer", bundle: nil)
    }
    static var shruti : UIStoryboard{
        return UIStoryboard(name: "shruti", bundle: nil)
    }
    // Gofer Splitup end
    static var gojekGoferBooking : UIStoryboard {
        return UIStoryboard(name: "GojekGoferBooking", bundle: nil)
    }
    static var kiranGofer : UIStoryboard {
        return UIStoryboard(name: "Kiran", bundle: nil)
    }
    /**
     initialte viewController with identifier as class name
     - Author: Abishek Robin
     - Returns: ViewController
     - Warning: Only ViewController which has identifier equal to class should be parsed
     */
    func instantiateViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
    }
    /**
     initialte viewController with identifier as class name and suffix("ID")
     - Author: Abishek Robin
     - Returns: ViewController
     - Warning: Only ViewController with "ID" in suffix should be parsed
     */
    func instantiateIDViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier + "ID") as! T
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionViewCell: ReusableView {}
extension UITableView{
    
    /**
    Registers UITableViewCell with identifier and nibName as class name
    - Author: Abishek Robin
    - Parameters:
       - cell: the Cell class instance to be registered
    - Warning: Only UITableViewCell which has identifier equal to class should be parsed
    */
    func registerNib(forCell cell : ReusableView.Type){
        
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        
        self.register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
  
    /**
     initialte UITableViewCell with identifier as class name
     - Author: Abishek Robin
     - Returns: ReusableView(UITableViewCell)
     - Warning: Only UITableViewCell which has identifier equal to class should be parsed
     */
    func dequeueReusableCell<T>(for index : IndexPath) -> T where T : ReusableView{
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: index) as! T
    }
}

extension UICollectionView{
    /**
     Registers UICollectionViewCell with identifier and nibName as class name
     - Author: Abishek Robin
     - Parameters:
        - cell: the Cell class instance to be registered
     - Warning: Only UICollectionViewCell which has identifier equal to class should be parsed
     */
    func registerNib(forCell cell : ReusableView.Type){
         
         let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
         
        self.register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
     }
    /**
     initialte UICollectionViewCell with identifier as class name
     - Author: Abishek Robin
     - Returns: ReusableView(UITableViewCell)
     - Warning: Only UICollectionViewCell which has identifier equal to class should be parsed
     */
    func dequeueReusableCell<T>(for index : IndexPath) -> T where T : ReusableView{
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: index) as! T
    }
}


