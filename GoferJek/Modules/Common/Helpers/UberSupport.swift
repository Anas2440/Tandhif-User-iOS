/**
* UberSupport.swift
*
* @package Gofer
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
//import ifaddrs

class UberSupport: NSObject {
    var userDefaults = UserDefaults.standard
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    static var shared = UberSupport()
    
    func changeStatusBarStyle(style: UIStatusBarStyle) {
        if #available(iOS 13, *) {
            let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = UIColor(hex: "007AFF")
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.addSubview(statusBar)
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = UIColor(hex: "007AFF")
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.addSubview(statusBar)
            let view = UIApplication.shared.statusBarView
            let app = UIApplication.shared.windows.first { $0.isKeyWindow }
            let statusBarHeight: CGFloat = (app?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
            let statusbarView = UIView()
            statusbarView.backgroundColor = .PrimaryColor
            view!.addSubview(statusbarView)
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor                                                      .constraint(equalToConstant:statusBarHeight).isActive = true
            statusbarView.widthAnchor                                                            .constraint(equalTo: view!.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor                                                            .constraint(equalTo: view!.topAnchor).isActive = true
            statusbarView.centerXAnchor                                                          .constraint(equalTo: view!.centerXAnchor).isActive = true
            view?.backgroundColor = style == .lightContent ? .PrimaryColor : .clear
        }else{
            UIApplication.shared.isStatusBarHidden = false
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = style == .lightContent ? .PrimaryColor : .clear
                UIApplication.shared.statusBarStyle = .lightContent
            }
            
        }
    }
    func changeStatusBarStyles(style: UIStatusBarStyle) {
        if #available(iOS 13.0, *){
            let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = UIColor(hex: "007AFF")
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.addSubview(statusBar)
            let view = UIApplication.shared.statusBarView
            let app = UIApplication.shared.windows.first { $0.isKeyWindow }
            let statusBarHeight: CGFloat = (app?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = .SecondaryColor
            view!.addSubview(statusbarView)
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor                                                      .constraint(equalToConstant:statusBarHeight).isActive = true
            statusbarView.widthAnchor                                                            .constraint(equalTo: view!.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor                                                            .constraint(equalTo: view!.topAnchor).isActive = true
            statusbarView.centerXAnchor                                                          .constraint(equalTo: view!.centerXAnchor).isActive = true
            view?.backgroundColor = style == .lightContent ? UIColor.SecondaryColor : .clear
        } else {
            UIApplication.shared.statusBarStyle = style
            UIApplication.shared.isStatusBarHidden = false
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            UIApplication.shared.statusBarStyle = .default
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = style == .default ? .SecondaryColor : .clear
            }
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validateZipCode(strZipCode:String) -> Bool
    {
        let postcodeRegex: String = "^[0-9]{6}$"
        let postcodeValidate : NSPredicate = NSPredicate(format: "SELF MATCHES %@", postcodeRegex)
        if postcodeValidate.evaluate(with: strZipCode) == true {
            return true
        }
        else {
            return false
        }
    }
    
    func isNetworkRechable(_ viewctrl : UIViewController) -> Bool {
        return NetworkManager.instance.isNetworkReachable
    }
    
    func checkNetworkIssue(_ viewctrl : UIViewController, errorMsg: String) -> Bool {
        if !NetworkManager.instance.isNetworkReachable {
            return false
        } else if errorMsg.count > 0 {
            return false
        } else {
            return true
        }
    }
    
    //MARK: Check Param Type
    func checkParamTypes(params:NSDictionary, keys:NSString) -> NSString
    {
        if let latestValue = params[keys] as? NSString {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? String {
            return latestValue as NSString
        }
        else if let latestValue = params[keys] as? Int {
            return String(format:"%d",latestValue) as NSString
        }
        else if (params[keys] as? NSNull) != nil {
            return ""
        }
        else
        {
            return ""
        }
    }
    
    func showProgress(viewCtrl:UIViewController , showAnimation:Bool)
    {
        Shared.instance.showLoader(in: viewCtrl.view)
////        let main = Stories.Main.instance
//        let viewProgress = ProgressHud.initWithStory()
//        viewProgress.isShowLoaderAnimaiton = showAnimation
//        viewProgress.view.tag = Int(123456)
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.window?.isUserInteractionEnabled = true
//        viewCtrl.view.addSubview(viewProgress.view)
//        viewCtrl.view.bringSubviewToFront(viewProgress.view)
    }
    
    func removeProgress(viewCtrl:UIViewController)
    {
        Shared.instance.removeLoader(in: viewCtrl.view)
//        viewCtrl.view.viewWithTag(Int(123456))?.removeFromSuperview()
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.window?.isUserInteractionEnabled = true
    }
    
    func showProgressInWindow(viewCtrl:UIViewController = UIViewController() , showAnimation:Bool)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//         let viewProgress = ProgressHud.initWithStory()
//        viewProgress.isShowLoaderAnimaiton = showAnimation
//
//        viewProgress.view.tag = Int(123456)
//        appDelegate.window?.isUserInteractionEnabled = true
//        appDelegate.window?.addSubview(viewProgress.view)
        if let window = appDelegate.window{
            Shared.instance.showLoader(in: window)
        }
        
    }
    
    func removeProgressInWindow(viewCtrl:UIViewController = UIViewController())
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
//        appDelegate.window?.isUserInteractionEnabled = true
        if let window = appDelegate.window{
               Shared.instance.removeLoader(in: window)
           }
    }

    func makeViewAnimaiton(viewObj:UIView) {
        //        let rectImg = imgUberIcon.frame;
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions(), animations: { () -> Void in
            viewObj.frame = CGRect(x: 0, y: viewObj.frame.origin.y,width: viewObj.frame.size.width ,height: viewObj.frame.size.height)
        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    func isPad() -> Bool
    {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom)
        {
        case .pad:
            return true
        case .phone:
            return false
        default:
            break
        }
        return false
    }
    
    
    func getScreenSize() -> CGRect
    {
        var rect = UIScreen.main.bounds as CGRect
        //let orientation = UIApplication.shared.statusBarOrientation as UIInterfaceOrientation
        let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation
       
        
        if UberSupport().isPad()
        {
            if(orientation!.isLandscape)
            {
                rect = CGRect(x: 0, y:0,width: 1024 ,height: 768)
            }
            else
            {
                rect = CGRect(x: 0, y:0,width: 768 ,height: 1024)
            }
        }
        return rect
    }
    
    func keyboardWillShowOrHide(keyboarHeight: CGFloat , btnView : UIButton)
    {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            let rect = self.getScreenSize()
            btnView.frame.origin.y = (rect.size.height) - btnView.frame.size.height - keyboarHeight - 25
        })
    }
    
    func keyboardWillShowOrHideForView(keyboarHeight: CGFloat , btnView : UIView)
    {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            let rect = self.getScreenSize()
            btnView.frame.origin.y = (rect.size.height) - btnView.frame.size.height - keyboarHeight
        })
    }
    
    func createAttributUserName(originalText: NSString,normalText: NSString,textColor: UIColor, boldText: NSString , fontSize : CGFloat)->NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string: originalText as String, attributes: [NSAttributedString.Key.font:UIFont (name: G_MediumFont, size: fontSize)!])
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, originalText.length - 1))

        let boldFontAttribute = [NSAttributedString.Key.font: UIFont (name: ImageFont, size: fontSize - 4)!]
        attributedString.addAttributes(boldFontAttribute, range: NSMakeRange(originalText.length - 1, boldText.length))

        return attributedString
    }
    
    func onGetStringWidth(_ width:CGFloat, strContent:NSString, font:UIFont) -> CGFloat
    {
        let textSize: CGSize = strContent.size(withAttributes: [NSAttributedString.Key.font : font])
        return textSize.width
    }

    func onGetStringHeight(_ width:CGFloat, strContent:NSString, font:UIFont) -> CGFloat
    {
        let sizeOfString = strContent.boundingRect( with: CGSize(width: width, height: CGFloat.infinity), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font: font], context: nil).size
        return sizeOfString.height
    }    
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    // MARK: Convert Currency Code to Symbol
    func getSymbolForCurrencyCode(code: NSString) -> NSString?
    {
        let locale = NSLocale(localeIdentifier: code as String)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code) as NSString?
    }
    
}
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
       func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
                #if os(iOS)
                switch identifier {
                case "iPod5,1":                                 return "iPod touch (5th generation)"
                case "iPod7,1":                                 return "iPod touch (6th generation)"
                case "iPod9,1":                                 return "iPod touch (7th generation)"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
                case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
                case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
                case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
                case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
                case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
                case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
                case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
                case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
                case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
                case "AppleTV5,3":                              return "Apple TV"
                case "AppleTV6,2":                              return "Apple TV 4K"
                case "AudioAccessory1,1":                       return "HomePod"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
                }
                #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
                #endif
            }

            return mapToDevice(identifier: identifier)
        }()
    static func getIphoneXAbove()->Bool
    {
        if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "Simulator iPhone XS Max" || UIDevice.modelName == "iPhone X" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone 11" || UIDevice.modelName == "Simulator iPhone 11" || UIDevice.modelName == "Simulator iPhone 11 Pro" || UIDevice.modelName == "iPhone 11 Pro" || UIDevice.modelName == "Simulator iPhone 11 Pro Max" || UIDevice.modelName == "iPhone 11 Pro Max"{
            return true
        }
        return false
    }
    
}
extension UIViewController {
    func checkDevice()-> Bool {
        if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "Simulator iPhone XS" || UIDevice.modelName == "Simulator iPhone XR" || UIDevice.modelName == "Simulator iPhone XS Max" || UIDevice.modelName == "iPhone X" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "iPhone XS Max" {
            return true
        }
        return false
    }
    
}
extension UIView{
    func getJsonFormattedString(_ params: Any)-> String {
        var jsonParamString = String()
        var jsonParamDict = [String:Any]()
        print(jsonParamDict)
        do {
            if #available(iOS 11.0, *) {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
                // here "jsonData" is the dictionary encoded in JSON data
                
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                // here "decoded" is of type `Any`, decoded from JSON data
                
                // you can now cast it with the right type
                if let dictFromJSON = decoded as? [String:Any] {
                    // use dictFromJSON
                    print(dictFromJSON)
                    jsonParamString = "\(decoded)"
                    jsonParamDict = decoded as! [String : Any]
                    
                }
                do {
                    let data1 =  try JSONSerialization.data(withJSONObject: decoded, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                    jsonParamString = String(data: data1, encoding: String.Encoding.utf8)! // the data will be converted to the string
                    print(jsonParamString)
                } catch let myJSONError {
                    print(myJSONError)
                }
            } else {
                // Fallback on earlier versions
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
        let test = String(jsonParamString.filter { !" \n\t\r".contains($0) })
        return test
    }
}
extension UIView{
    
    func addWithoutAnimationClosure(_ closure:@escaping ()->Void){
        UIView.performWithoutAnimation {
            closure()
        }
    }
}
extension UIImageView {
    func addRemoteImage(imageURL: String,placeHolderURL: String,isRound: Bool = false) {
        if isRound {
            self.layer.cornerRadius = self.frame.size.width / 2
            self.clipsToBounds = true
        }
        self.sd_setImage(with: URL(string: imageURL),
                         placeholderImage: UIImage(named: placeHolderURL))
    }
}
extension UIView {
    func getOrderDisplayName(pickedDate:Date)->String{
        let today = Date()
        var dateTitle = Date()
        print(dateTitle)
        let dateFormatter = DateFormatter()
        var setTime = String()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MM YYYY hh:mm", options: 0, locale: Locale.current)
        if pickedDate < today {
            dateTitle = today
        } else {
           dateTitle = pickedDate
        }
        let date1 = today
        let date2 = pickedDate
        
        let components: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
        
        if components.day! >= 1 {
            print("\(components.day! + 1) day ago")
            dateFormatter.dateFormat = "E,d"
            setTime = dateFormatter.string(from: pickedDate)
        } else {
            dateFormatter.dateFormat =  "hh:mm"
            let startTime = dateFormatter.string(from: pickedDate)
            let timeInterval = Calendar.current.date(byAdding: .minute, value: 30, to: pickedDate)
            dateFormatter.dateFormat = "hh:mm a"
            let endTime = dateFormatter.string(from: timeInterval!)
            if components.hour! >= 23 && components.minute! >= 59 {
                setTime = "Tommorow".localize + " \(startTime)-\(endTime)"
            }
            else {
                setTime = "Today".localize + " \(startTime)-\(endTime)"
            }
        }
        return setTime
    }
    
}
extension Date {
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
