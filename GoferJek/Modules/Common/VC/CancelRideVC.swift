/**
* CancelRideVC.swift
*
* @package UberDriver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/


import UIKit
import Foundation
import Alamofire

class CancelRideVC: BaseViewController,
                    UITableViewDelegate,
                    UITextViewDelegate {
   
    //-----------------------------------------
    //MARK:- Outlets
    //-----------------------------------------
    
    @IBOutlet var cancelRideView: CancelRideView!
    
    //-----------------------------------------
    //MARK:- Local Variables
    //-----------------------------------------
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var isToCancelSchedule = false
    var isFromHistory : Bool = false
    var strTripId = ""
    var order_id = ""
    var bussiness_id = ""
    
    //-----------------------------------------
    //MARK:- initWithStory
    //-----------------------------------------
    
    class func initWithStory() -> CancelRideVC{
        let view : CancelRideVC = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    
    //-----------------------------------------
    // MARK: - ViewController Methods
    //-----------------------------------------
   
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.wsToGetCancelReason()
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //-----------------------------------------
    // MARK: - API CALL -> CANCELLING TRIP
    //-----------------------------------------
    
    func wsToGetCancelReason() {
        // Handy Splitup start
        ConnectionHandler.shared.getRequest(for: .cancel_reasons, params: ["business_id":AppWebConstants.businessType.rawValue]).responseJSON { (json) in //param = [:]
            // Handy Splitup End
            if json.status_code == 1 {
                let reason = json.array("cancel_reasons")
                self.cancelRideView.cancelReasons = reason.map({CancelReason($0)})
                self.cancelRideView.tblCancelList.reloadData()
            } else {
                AppDelegate.shared.createToastMessage(json.status_message)
            }
        }.responseFailure { (error) in
//            AppDelegate.shared.createToastMessage(error)
        }
    }
    
    func wsCancelTrip(cancel_reason_id: Int,
                      reason: String,
                      usertype : String) {
        UberSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["cancel_comments"] = reason
        dicts["reason_id"] = cancel_reason_id.description
        // Handy Splitup start
        if AppWebConstants.businessType == .Ride {
            dicts["job_id"] = strTripId
        } else if AppWebConstants.businessType == .DeliveryAll {
            dicts["order_id"] = strTripId
            dicts["business_id"] = "3"
        } else{
            // Handy Splitup End
            if isToCancelSchedule{
                dicts["id"] = strTripId
            } else {
                dicts["job_id"] = strTripId
            }
            // Handy Splitup Start
        }
        // Handy Splitup End
        dicts["user_type"] = usertype
        if self.isToCancelSchedule{
            self.cancelScheduleRide(dict: dicts)
        }else{
            self.cancelRide(dicts: dicts)
        }
    }
    
    func cancelScheduleRide(dict : [AnyHashable:Any]) {
        var params = Parameters()
        dict.forEach { ( hashKey,value) in
            params[hashKey as? String ?? String()] = value
        }
        UberSupport.init().showProgressInWindow(showAnimation: true)
        AF.request(APIUrl + APIEnums.cancelScheduleJob.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil).responseJSON { (jsonResponse) in
            UberSupport.init().removeProgressInWindow()
            UberSupport.init().removeProgress(viewCtrl: self)
            print(jsonResponse.request?.url as Any)
            switch jsonResponse.result{
            case .success(let data):
                if let json = data as? JSON {
                    if json.status_code == 1{
                        self.presentAlertWithTitle(title: appName,
                                                   message: json.status_message,
                                                   options: LangCommon.ok) { (_) in
                            
                            self.gotoMainMapView()
                            self.appDelegate.createToastMessage(json.status_message)
                        }
                    }else{
                        self.appDelegate.createToastMessage(json.status_message,
                                                            bgColor: .black,
                                                            textColor: .white)
                    }
                } else {
                    self.appDelegate.createToastMessage(CommonError.server.localizedDescription,
                                                        bgColor: .black,
                                                        textColor: .white)
                }
            case .failure(let error):
                debug(print: error)
            }
        }
        UberSupport().removeProgressInWindow(viewCtrl: self)
    }
    func cancelRide(dicts : [AnyHashable: Any]){
        guard let parameter = dicts as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(
                for:  .cancelJob,
                params: parameter)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    self.gotoMainMapView()
                    self.cancelRideView.initSuccessMessage()
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                    self.cancelRideView.btnSave.isUserInteractionEnabled = true
                }
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
//                AppDelegate.shared.createToastMessage(error)
                self.cancelRideView.btnSave.isUserInteractionEnabled = true
            })
       
    }
    //-----------------------------------------
    // AFTER CANCELLING TRIP WE SHOULD NAVIGATE TO HOME PAGE
    //-----------------------------------------
    func gotoMainMapView() {
        /*
         * 2.3
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.onSetRootViewController(viewCtrl: nil)
         */
        if self.isFromHistory {
            NotificationEnum.completedTripHistory.postNotification()
            NotificationEnum.pendingTripHistory.postNotification()
            self.navigationController?.popViewController(animated: true)
        } else {
            self.setRootVC()
//            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: .RefreshIncompleteTrips, object: nil)
            NotificationEnum.completedTripHistory.postNotification()
        }
    }
}


extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
