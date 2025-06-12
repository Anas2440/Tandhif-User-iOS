//
//  StarStackView.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit


class StarStackView : UIStackView{
    @IBOutlet var stars : [UIImageView]!
    
    
    private var rating : Double = 0.0
    private var initalStartPoint : CGFloat?
    lazy var panGesture : UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(self.onPanGesutreAction(_:)))
    }()
    lazy var tapGesture : UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.onTapGesutreAction(_:)))
    }()
    func setRating(_ rating : Double){
        
        if rating.isZero{
            self.stars.forEach({$0.isHiddenInStackView = true})
        }else{
            self.stars.forEach({$0.isHiddenInStackView = false})
        }
//        self.isHiddenInStackView = rating.isZero
        self.layoutIfNeeded()
        self.rating = rating
        let intRatingValue = Int(rating)
        _ = Double(intRatingValue)
       
        for index in Array(0...stars.count-1){
            let star = stars.value(atSafe: index)
            
            if index < intRatingValue{
                star?.image = UIImage(named: "StarFull")?.withRenderingMode(.alwaysTemplate)
                star?.tintColor = UIColor(hex: "F8C109")
            }else{
                star?.image = UIImage(named: "StarEmpty")//?.withRenderingMode(.alwaysTemplate)
                //star?.tintColor = UIColor.lightGray.withAlphaComponent(0.25)//(hex: "EFF1F3")
            }
            
        }
        if rating - Double(intRatingValue) > 0{
            self.stars.value(atSafe: intRatingValue)?.image = UIImage(named: "StarHalf")
        }
        
        for star in self.stars{
            
            star.transform = isRTLLanguage ? CGAffineTransform(scaleX: -1, y: 1) : .identity
        }
        
    }
    func getRating() -> Double{
        return rating
    }
    
    func ratingValue(canBeEdited editingEnabled : Bool){
        if editingEnabled{
            self.addGestureRecognizer(self.panGesture)
            self.addGestureRecognizer(self.tapGesture)
            self.isUserInteractionEnabled = true
           
        }else{
            self.removeGestureRecognizer(self.panGesture)
            self.removeGestureRecognizer(self.tapGesture)
        }
    }
    @objc
    func onPanGesutreAction(_ gesture : UIPanGestureRecognizer){
//        let isRTL = Shared.instance.language!.isRTLLanguage()
//        let rtlValue : CGFloat = isRTL ? 1 : -1
        let translation = gesture.translation(in: self)
        gesture.location(in: self)
        let xMovement = translation.x
        let finalXValue : CGFloat
        switch gesture.state {
        case .began:
            let viewX = gesture.location(in: self).x
            self.initalStartPoint = viewX
            finalXValue = viewX + xMovement
        case .changed:
            finalXValue = (self.initalStartPoint ?? 0.0) + xMovement
        case .ended:
            fallthrough
        default:
            finalXValue = (self.initalStartPoint ?? 0.0) + xMovement
            self.initalStartPoint = nil
            
        }
        let calculateXValue = ((finalXValue / self.frame.width) * 100) / 20
        let doubleValue = Double(calculateXValue < 1 ? 1 : calculateXValue > 4.5 ? 5 : calculateXValue)
        self.setRating(doubleValue)
    }
        @objc
        func onTapGesutreAction(_ gesture : UITapGestureRecognizer){

            let finalXValue = gesture.location(in: self).x
            let calculateXValue = ((finalXValue / self.frame.width) * 100) / 20
            print("ş:\(calculateXValue)")
            let doubleValue = Double(calculateXValue < 1 ? 1 : calculateXValue > 4.5 ? 5 : calculateXValue)
            self.setRating(doubleValue.rounded(.up))
        }
}
