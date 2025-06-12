//
//  HandyBookedServicesVC.swift
//  GoferHandy
//
//  Created by trioangle on 01/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyBookedServicesVC: BaseViewController {
    @IBOutlet weak var bookedServicesView : HandyBookedServicesView!
    var isFixed : Bool = false
    var faretype : PriceType?
    var servicesArray:Array<RequestedService> = []
    var job : HandyJobDetailModel!
    let vm = AccountViewModel()
    var reqID : String?
     override func viewDidLoad() {
         super.viewDidLoad()
        if let reqID = reqID {
            self.getJobRequestDetails(reqID: reqID)
        } else {
            print("Req. ID is Missing")
        }
         // Do any additional setup after loading the view.
     }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
     
     
     //MARK:- intiWithStory
    class func initWithStory(reqID:String,forJob job : HandyJobDetailModel) -> HandyBookedServicesVC{
         let view : HandyBookedServicesVC =  UIStoryboard.gojekHandyBooking.instantiateViewController()
        view.job = job
        view.reqID = reqID
         return view
     }

    func getJobRequestDetails(reqID:String){
        var json = JSON()
        json["request_id"] = reqID
        
        self.vm.getJobRequestApi(parms: json) { (result) in
            switch result {
            case .success( _):
                print("success")
                self.servicesArray = self.vm.jobRequest?.service ?? []
                self.faretype = self.vm.jobRequest?.priceType
                self.bookedServicesView.reloadTable()
            case .failure( _):
//                AppDelegate.shared.createToastMessage(error.localizedDescription)
                self.bookedServicesView.reloadTable()
            }
        }
        
    }
}
