//
//  ManualTripTVC.swift
//  GoferDriver
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit

class ManualTripTVC: UITableViewCell {


    
    @IBOutlet weak var statusLbl : UILabel!
    @IBOutlet weak var scheduledTimeLbl : UILabel!
    @IBOutlet weak var BookingLbl: UILabel!
    @IBOutlet weak var fromPinView : UIView!
    @IBOutlet weak var toPinView : UIView!
    @IBOutlet weak  var pointingView : UIView!
    @IBOutlet weak var fromLocationLbl : UILabel!
    @IBOutlet weak var toLoactionLbl : UILabel!
    @IBOutlet weak var tripIDLbl : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    class func getNib() -> UINib{
        return UINib(nibName: "ManualTripTVC", bundle: nil)
    }
    func populateCell(_ trip : UserProfileDataModel){
//        self.BookingLbl.text =  trip.bookingType.rawValue
//        self.scheduledTimeLbl.text = trip.scheduleDate + " " + trip.sheduleTime
//        self.statusLbl.text =  trip.status.localizedValue
//        self.fromLocationLbl.text = trip.pickupLocation
//        self.toLoactionLbl.text = trip.dropLocation
//        self.tripIDLbl.text = "\(self.lang.common.tripID):" + trip.id.description
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.connectFromToView()
            //self.holderView.elevate(0.25)
        }
        if isRTLLanguage {
            self.statusLbl.textAlignment = .right
            self.BookingLbl.textAlignment = .right
            self.scheduledTimeLbl.textAlignment = .right
            self.fromLocationLbl.textAlignment = .right
            self.toLoactionLbl.textAlignment = .right
        }
    }
    func statusLocalization(_ status :TripStatus){
        switch status{
         case .completed:
            self.statusLbl.text = LangCommon.completedStatus
         case .payment:
            self.statusLbl.text = LangCommon.paymentStatus
         case .beginTrip:
            self.statusLbl.text = LangCommon.beginJob
         case .endTrip:
            self.statusLbl.text = LangCommon.endJob
         case .cancelled:
            self.statusLbl.text = LangCommon.cancelledStatus
         case .request:
            self.statusLbl.text = LangCommon.requestStatus
         case .scheduled:
            self.statusLbl.text = LangCommon.scheduledStatus
        case .pending:
            self.statusLbl.text = LangCommon.pendingStatus
        default:
            print()
        }
    
    }
    private func connectFromToView(){
        self.fromPinView.backgroundColor = .PrimaryColor
        self.toPinView.backgroundColor = .PrimaryColor
        self.pointingView.backgroundColor = .TertiaryColor
        self.fromPinView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.toPinView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
}
