//
//  HandyBookServiceVC.swift
//  GoferHandy
//
//  Created by trioangle on 27/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyBookServiceVC: BaseViewController {
    @IBOutlet weak var providerDetailView : HandyBookServiceView!
    
      var serviceItem: ServiceItem!
    private var originalServiceItemReference : ServiceItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    
    //MARK:- intiWithStory
    class func initWithStory(_ serviceItem:ServiceItem) -> HandyBookServiceVC{
        let view:HandyBookServiceVC = UIStoryboard.gojekHandyBooking.instantiateViewController()
        view.serviceItem = ServiceItem(copyFrom: serviceItem)
        view.originalServiceItemReference = serviceItem
        
        return view
    }
//MARK:- UDF
    func updateOriginalData(){
        self.originalServiceItemReference.update(from: self.serviceItem)
    }
}
//
//struct AddCartItem  {
//    var itemName:String
//    var itemID :Int
//    var itemCount:Int
//    var itemPrice:Double
//    var currency:String
//    var specialInStruction:String?
//    var serviceTypeData:ServiceItem?
//    
//}
