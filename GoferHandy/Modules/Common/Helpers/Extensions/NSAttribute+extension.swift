//
//  NSAttribute+extension.swift
//  GoferHandy
//
//  Created by trioangle on 14/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

//import Foundation
//extension NSMutableAttributedString {
//    var fontSize:CGFloat { return 17 }
//    var boldFont:UIFont { return AppTheme.Fontbold(size: fontSize).font }
//    var normalFont:UIFont { return AppTheme.Fontlight(size: fontSize).font}
//
////    func bold(_ value:String,fontSize: CGFloat = 17) -> NSMutableAttributedString {
////
////        let attributes:[NSAttributedString.Key : Any] = [
////            .font : AppTheme.Fontbold(size: fontSize).font
////        ]
////
////        self.append(NSAttributedString(string: value, attributes:attributes))
////        return self
////    }
////
////    func normal(_ value:String,fontSize: CGFloat = 17) -> NSMutableAttributedString {
////
////        let attributes:[NSAttributedString.Key : Any] = [
////            .font : AppTheme.Fontlight(size: fontSize).font,
////        ]
////
////        self.append(NSAttributedString(string: value, attributes:attributes))
////        return self
////    }
//    /* Other styling methods */
//    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
//
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .foregroundColor : UIColor.white,
//            .backgroundColor : UIColor.orange
//        ]
//
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//
//    func blackHighlight(_ value:String) -> NSMutableAttributedString {
//
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .foregroundColor : UIColor.white,
//            .backgroundColor : UIColor.black
//        ]
//
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//    func greenTextColor(_ value:String) -> NSMutableAttributedString {
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .foregroundColor : UIColor.init(named: "Green") ?? .init(hex: AppWebConstants.ThemeTextColor)
//        ]
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//
//    func underlined(_ value:String,
//                    fontSize: CGFloat = 17,
//                    fontWeight: UIFont.Weight = .bold) -> NSMutableAttributedString {
//        let font : UIFont!
//        if fontWeight == .bold {
//            font = AppTheme.Fontbold(size: fontSize).font
//        } else {
//            font = AppTheme.Fontlight(size: fontSize).font
//        }
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  font ?? .systemFont(ofSize: fontSize),
//            .underlineStyle : NSUnderlineStyle.single.rawValue
//        ]
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//}
