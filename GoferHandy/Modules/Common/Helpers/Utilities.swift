//
//  Utilities.swift
//  GoferEats
//
// Created by trioangle on 25/07/18.
//  Copyright © 2018 Balajibabu. All rights reserved.
//

import UIKit
import CoreLocation

protocol PromoValuePassedProtocol{
    func promoDetailId(id:Int)
    func reloadPromo()
    func promoUpdate(promoId:Int)
    func promoCodeName(code:String)
}

class Utilities: NSObject {
    
    static let sharedInstance = Utilities()
    
    class func showAlertMessage(message: String,
                                onView: UIViewController) {
        let alertController = UIAlertController(title: appName,
                                                message: message,
                                                preferredStyle: .alert)
//        alertController.setValue(myMutableString, forKey: "attributedTitle")
        
        let action2 = UIAlertAction(title: LangCommon.ok,
                                    style: .default) { (action:UIAlertAction) in
            alertController.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(action2)
        onView.present(alertController,
                       animated: true,
                       completion: nil)
    }
    
    func changeStatusBarStyles(style: UIStatusBarStyle)
         {
           
              if #available(iOS 13.0, *){
                
                               let view = UIApplication.shared.statusBarView
                let app = UIApplication.shared.windows.first { $0.isKeyWindow }
                let statusBarHeight: CGFloat = (app?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
                                                                      
                                 let statusbarView = UIView()
                                //UIApplication.shared.isStatusBarHidden = false
                                //app.statusBarStyle = .default
                //statusbarView.backgroundColor = UIColor.PrimaryColor
                                         view!.addSubview(statusbarView)
                                         statusbarView.translatesAutoresizingMaskIntoConstraints = false
                                         statusbarView.heightAnchor                                                      .constraint(equalToConstant:statusBarHeight).isActive = true
                         statusbarView.widthAnchor                                                            .constraint(equalTo: view!.widthAnchor, multiplier: 1.0).isActive = true
                         statusbarView.topAnchor                                                            .constraint(equalTo: view!.topAnchor).isActive = true
                         statusbarView.centerXAnchor                                                          .constraint(equalTo: view!.centerXAnchor).isActive = true
                                   view?.backgroundColor = style == .lightContent ? UIColor.SecondaryColor : .clear
             //                             view?.setValue(style == .lightContent ? UIColor.white : .ThemeMain, forKey: "foregroundColor")
                         
                     }else{
                        UIApplication.shared.statusBarStyle = style
                             
                           }
         }

    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    func getCountryPhonceCode (_ country : String) -> String
    {
        let countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
                                  "AI":"1",
                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
                                  "DM":"1",
                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
                                  "GD":"1",
                                  "GP":"590",
                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
                                  "KN":"1",
                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340"]
        if countryDictionary[country] != nil {
            return countryDictionary[country]!
        }
            
        else {
            return ""
        }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func isValidEmail(mail:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: mail)
    }
//    func isValidPassword(mypassword:String) -> Bool {
//
//        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,15}$"
//        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//        return passwordtesting.evaluate(with: mypassword)
//    }
    class func widthOf(view:UIView) -> CGFloat {
        return view.frame.size.width
    }
    
    class func heightOf(view:UIView) -> CGFloat {
        return view.frame.size.height
    }
    
    func xOriginOf(view:UIView) -> CGFloat {
        return view.frame.origin.x
    }
    
    func yOriginOf(view:UIView) -> CGFloat {
        return view.frame.origin.y
    }
    
    func sizeOf(view:UIView) -> CGSize {
        return view.frame.size
    }
    
    func originOf(view:UIView) -> CGPoint {
        return view.frame.origin
    }
    
    func frameOf(view:UIView) -> CGRect {
        return view.frame
    }
    
//    func setLatandLong(lat:Double,long:Double) {
//
//        let latData = NSKeyedArchiver.archivedData(withRootObject: lat)
//        UserDefaults.standard.set(latData, forKey: "CurrentLatitude")
//        let longData = NSKeyedArchiver.archivedData(withRootObject: long)
//        UserDefaults.standard.set(longData, forKey: "CurrentLongitude")
//
//        if let CurrentLatitude = UserDefaults.standard.data(forKey: "CurrentLatitude"){
//            SharedVariables.sharedInstance.currentCoordinates.latitude = NSKeyedUnarchiver.unarchiveObject(with: CurrentLatitude) as! CLLocationDegrees
//            print(SharedVariables.sharedInstance.currentCoordinates.latitude)
//        }
//        if let CurrentLongitude = UserDefaults.standard.data(forKey: "CurrentLongitude") {
//            SharedVariables.sharedInstance.currentCoordinates.longitude = NSKeyedUnarchiver.unarchiveObject(with: CurrentLongitude) as! CLLocationDegrees
//            print(SharedVariables.sharedInstance.currentCoordinates.longitude)
//        }
//        SharedVariables.sharedInstance.currentCoordinates = CLLocationCoordinate2D(latitude:lat, longitude: long)
//    }
//
    func addAttributeText(originalText: String,attributedText: String,attributedColor:UIColor,isStrikeLine:Bool=false) -> NSMutableAttributedString {
        let strName = originalText
        let string_to_color2 = attributedText
        let attributedString1 = NSMutableAttributedString(string:strName)
        let range2 = (strName as NSString).range(of: string_to_color2)
        print(range2)
        attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: attributedColor, range: range2)
        if isStrikeLine {
            attributedString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range2)
        }
        
        return attributedString1
    }
    
    func createRatingImage(_ rating: Float)-> UIImage {
        if rating == 0.5 {
            return #imageLiteral(resourceName: "star0.5")
        }
        else if rating == 1.0 {
            return #imageLiteral(resourceName: "star1.0")
        }
        else if rating == 1.5 {
            return #imageLiteral(resourceName: "star1.5")
        }
        else if rating == 2.0 {
            return #imageLiteral(resourceName: "star2.0")
        }
        else if rating == 2.5 {
            return #imageLiteral(resourceName: "star2.5")
        }
        else if rating == 3.0 {
            return #imageLiteral(resourceName: "star3.0")
        }
        else if rating == 3.5 {
            return #imageLiteral(resourceName: "star3.5")
        }
        else if rating == 4.0 {
            return #imageLiteral(resourceName: "star4.0")
        }
        else if rating == 4.5 {
          return #imageLiteral(resourceName: "star4.5")
        }
        else if rating == 5.0 {
           return #imageLiteral(resourceName: "star5.0")
        }else {
             return #imageLiteral(resourceName: "star0.0")
        }
    }
    // DeliveryAll Splitup Start
    
    // DeliveryAll Splitup end
     // Delivery Splitup End
    func confirmAsInt(value:Any?) -> Int{
        return Int(("\(String(describing: value ?? "0"))" as NSString).intValue)
    }
    
    func getDeviceToken() -> String {
        return isSimulator ? "94c8a93426e12a874c8e9355da737a15db2f4a1da0d9c38de7340e8f66812b34" : Constants().GETVALUE(keyname :"device_token")
    }

}
extension NSObject{
    public func topMostViewController() -> UIViewController {
        return self.topMostViewController(withRootViewController: (UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController!)!)
    }
    
    public func topMostViewController(withRootViewController rootViewController: UIViewController) -> UIViewController {
        if (rootViewController is UITabBarController) {
            let tabBarController = (rootViewController as! UITabBarController)
            return self.topMostViewController(withRootViewController: tabBarController.selectedViewController!)
        }
        else if (rootViewController is UINavigationController) {
            let navigationController = (rootViewController as! UINavigationController)
            return self.topMostViewController(withRootViewController: navigationController.topViewController!)
        }
        
        
        else if rootViewController.presentedViewController != nil {
            let presentedViewController = rootViewController.presentedViewController!
            return self.topMostViewController(withRootViewController: presentedViewController)
        }
        else {
            return rootViewController
        }
        
    }
    
    
}


extension String{
    func toFloat()->Float {
        let number = (self as NSString? ?? "0").floatValue
        return number
    }
    
    func withDecimalPoints()->String {
        return String(format: "%.2f",Float(self) ?? 0.00)
    }
    
    func toBool()->Bool {
        if self.capitalized == "No" || self.toInt() == 0 {
            return false
        }
        return true
    }
}

extension Bool {
    func toInt()->Int{
        if self {
            return 1
        }
        return 0
    }
}


extension Int{
    func toFloat()->Float
    {
        let number = Float(self)
        return number
    }
    func toDouble()->Double
    {
        let number = Double(self)
        return number
    }
}
extension Float {
    func toString() ->String {
        
        let number = self.description
        return number
    }
}


class KeyedUnarchiver : NSKeyedUnarchiver {
    open override class func unarchiveObject(with data: Data) -> Any? {
        do {
            let object = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data)
            return object
        }
        catch let error {
            Swift.print("unarchiveObject(with:) \(error.localizedDescription)")
            return nil
        }
    }

}




