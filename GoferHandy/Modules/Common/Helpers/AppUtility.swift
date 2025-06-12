//
//  AppUtility.swift
//  GoferHandy
//
//  Created by trioangle on 04/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

class AppUtilities {
    
    //
    //MARK: - Common Utility functions
    //
    func updateMainQueue (_ updates : @escaping() -> Void) {        //main queue updates
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
         DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
              closure()
         }
    }
    //Instantiate Controllers
    func instantiateVC(storyboardName: String , storyboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: String(describing: storyboardName), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: storyboardId))
    }
    
    // Load NIB
    func loadNibwithName(name:String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    
   // MARK:- MBProgress
    
//    func showProgress (currentView:UIView) -> Void{         //Show progress
//        updateMainQueue {
//            let mbProgress = MBProgressHUD.showAdded(to: currentView, animated: true)
//            mbProgress.mode = MBProgressHUDMode.indeterminate
//            mbProgress.label.text = "Loading"
//            mbProgress.bezelView.color = UIColor.white
//        }
//    }
//    func hideProgress (currentView:UIView) -> Void{         //Hide progress
//        updateMainQueue {
//            MBProgressHUD.hide(for: currentView, animated: true)
//        }
//    }
    
    
    //Check network connection
//        func checkNetwork () -> Bool{
//            do {
//                let reachability: Reachability =  Reachability()
//                let networkStatus =  String (describing: reachability.currentReachabilityStatus)
//                if (networkStatus == "No Connection"){
//                    customCommonAlertView(titleString: "No Connection", messageString: "Connection failed, Please try again later")
//                    return false
//                }
//                return true
//            }
//        }
    //get Json Data
    func getJsonData(data:Data?) {
        guard data != nil else { return }          //check data is nil or not
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            print("Response :\(String(describing: json))")
        } catch {
            print(error)
        }
    }
    
    func customCommonAlertView (titleString:String,
                                messageString:String) -> Void {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: titleString,
                               alertDescription: messageString,
                               okAction: LangCommon.ok)
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
       
}
