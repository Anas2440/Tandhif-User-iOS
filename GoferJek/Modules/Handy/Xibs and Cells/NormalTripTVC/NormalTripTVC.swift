//
//  NormalTripTVC.swift
//  GoferDriver
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit

class NormalTripTVC: UITableViewCell {
    
    @IBOutlet weak var holderView : UIView!
    @IBOutlet weak var statusLbl : UILabel!
    @IBOutlet weak var tripIDLbl : UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var vehicleNameLbl: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var ratingBtn : UIButton!
    
    @IBOutlet weak var pickUpLbl : UILabel!
    @IBOutlet weak var dropLbl  : UILabel!
    @IBOutlet weak var addressLeadingConstraint : NSLayoutConstraint!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.ratingBtn.isClippedCorner = true
        self.ratingBtn.isHidden = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ratingBtn.isHidden = true
        self.mapImageView.image = UIImage(named: "map_static")
    }
    class func getNib() -> UINib{
        return UINib(nibName: "NormalTripTVC", bundle: nil)
    }
    /*func populateCell(_ trip : RiderDataModel){
     
     self.tripIDLbl.text = "Trip ID : " + trip.id.description
     self.lblCost.text = trip.currency_symbol + trip.totalFare.description
     self.statusLbl.text = trip.status.self.rawValue
     self.vehicleNameLbl.text = trip.carName
     
     self.mapImageView.sd_setImage(with:trip.getWorkingMapURL())
     DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
     self.connectFromToView()
     self.holderView.elevate(0.25)
     }
     }
     private func connectFromToView(){
     }*/
    func attachRatingButton(_ attach : Bool){
        self.ratingBtn.setTitle(LangCommon.rateYourRide.uppercased(), for: .normal)
        self.ratingBtn.isHidden = true//!attach
        
        
    }
    func statusLocalization(_ status :TripStatus){
    switch status{
     case .completed:
        self.statusLbl.text = LangCommon.completedStatus
     case .payment:
        self.statusLbl.text = LangCommon.paymentStatus
     case .beginTrip:
        self.statusLbl.text = LangCommon.beginTripStatus
     case .endTrip:
        self.statusLbl.text = LangCommon.endTripStatus
     case .cancelled:
        self.statusLbl.text = LangCommon.cancelledStatus
     case .request:
        self.statusLbl.text = LangCommon.requestStatus
     case .scheduled:
        self.statusLbl.text = LangCommon.scheduledStatus
    case .pending:
        self.statusLbl.text =  LangCommon.pendingStatus
    default:
        print()
    }
    }
    func populateCell(_ trip : UserProfileDataModel){
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
//            self.attachRatingButton(trip.status == .rating)
//        }
//        let strCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
//        if iApp.instance.isRTL{
//            lblCost.textAlignment = NSTextAlignment.left
//            statusLbl.textAlignment = NSTextAlignment.left
//            self.mapImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
//        }else{
//            lblCost.textAlignment = NSTextAlignment.right
//            statusLbl.textAlignment = NSTextAlignment.right
//            self.mapImageView.transform = .identity
//        }
//        self.addressLeadingConstraint.constant = self.contentView.frame.width * 0.2
//
//        self.statusLbl.text = trip.status.localizedValue
//        let msg1 = LangCommon.tripID + ":"
//        self.tripIDLbl.text = "\(msg1)\(trip.id)"
//        print("tripId",trip.id)
//        print("driverpayout ",trip.driverPayout)
//        print("totalfare",trip.totalFare)
//        let driverEarnings = trip.driverEarnings
//        let strCurr = trip.currency_symbol
//        self.lblCost?.text = String(format:"%@ %@",strCurr,driverEarnings)
//        self.vehicleNameLbl.text = trip.carName
//        if trip.mapImage.isEmpty || trip.mapImage.contains("maps/api/staticmap") {
//            
//            self.mapImageView.image = UIImage(named: "active_trip_bg")
//            self.mapImageView.contentMode = .scaleAspectFit
//            self.pickUpLbl.text = trip.pickupLocation
//            self.dropLbl.text = trip.dropLocation
//        }else{
//            self.mapImageView.sd_setImage(with: URL(string: trip.mapImage))
//            self.mapImageView.contentMode = .scaleToFill
//            self.pickUpLbl.text = ""
//            self.dropLbl.text = ""
//        }
////        self.mapImageView.sd_setImage(with:trip.getWorkingMapURL())
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
//            //self.connectFromToView()
//            self.holderView.elevate(0.25)
//        }
        
    }
    
}
