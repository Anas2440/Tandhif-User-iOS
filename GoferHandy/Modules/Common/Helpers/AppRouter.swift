//
//  AppRouter.swift
//  Gofer
//
//  Created by trioangle on 28/05/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Alamofire


class AppRouter  {

    
    //MARK:- local variables
    fileprivate static var currentViewController : UIViewController?
    //MARK:- initalizers
    init(_ currentVC : UIViewController){
        Self.currentViewController = currentVC
    }
    
    
}

extension AppRouter{
    //MARK:- UDF ROUTERS
    

    // Delivery Splitup Start

    //MARK: Redierect to incomplet trips
    func routeInCompleteGoferTrips(_ trip : HandyJobDetailModel){
        switch trip.users.jobStatus {
        case .cancelled,.completed:
            print("ignoring the \(trip.users.jobStatus) status")
            self.routeToDetailTripHistory(forTrip: trip)
        case .rating:
            //redirect to rating page
            self.routeToRating(forTrip: trip)
          
        case .payment:
            //redirect to payment page
            self.routeToPayment(forTrip: trip)
        case .scheduled,.beginJob,.endJob,.request:
            //redirect to driver info map page
            self.routeToTripScreen(forTrip: trip)
        default:
            print("Some unexpected Status mate !")
            
        }
    }
    // Delivery Splitup End

    //MARK: Redierect to incomplet trips for Handy
    func routeInCompleteTrips(_ job : HandyJobDetailModel){
        switch job.users.jobStatus {
    
        case .cancelled,.completed:
            fallthrough
        case .rating:
            fallthrough
          
        case .payment:
            //redirect to payment page
            if let vc = Self.currentViewController?.navigationController?.viewControllers.last ,
               vc.isKind(of: HandyPaymentVC.self) {
                guard (vc as! HandyPaymentVC).jobID != job.users.jobID else { return }
            }
            Self.currentViewController?.navigationController?
            .pushViewController(
                HandyPaymentVC.initWithStory(job: job,
                                             jobID: job.users.jobID,
                                             jobStatus: job.users.jobStatus,promoId: job.users.promoId),
                animated: true)
//            self.routeToPayment(forTrip: trip)
        case .scheduled,.beginJob,.endJob:
            //redirect to driver info map page
            switch job.users.businessID {
            default:
                if let vc = Self.currentViewController?.navigationController?.viewControllers.last ,
                   vc.isKind(of: HandyRouteVC.self) {
                    guard (vc as! HandyRouteVC).jobID != job.users.jobID else { return }
                }
                // Services Splitup Start
                Self.currentViewController?.navigationController?
                .pushViewController(
                    HandyRouteVC.initWithStory(forJob: job),
                    animated: true)
                // Services Splitup End
            }
            //Delivery Splitup End

           
        default:
            print("Some unexpected Status mate !")
            
        }
    }
    func routeGoferInCompleteTrips(_ jobID : Int, _  jobStatus : HandyJobStatus){
        switch jobStatus {
    
        case .cancelled,.completed,.rating,.payment:
            // Handy Splitup Start
             //Delivery Splitup Start
            switch AppWebConstants.businessType {
                // case .Services:
            case .Services,.Delivery,.Ride:
                // Handy Splitup End
                if let vc = Self.currentViewController?.navigationController?.viewControllers.last ,
                   vc.isKind(of: HandyPaymentVC.self) {
                    guard (vc as! HandyPaymentVC).jobID != jobID else { return }
                }
                let vc = HandyPaymentVC.initWithStory(job: nil,
                                                      jobID: jobID,
                                                      jobStatus: jobStatus)
                Self.currentViewController?.navigationController?.pushViewController(vc,
                                                                                     animated: true)
                // Handy Splitup Start
            default:
                print("Not Handled")
            }
            // Handy Splitup End
        
            //Delivery Splitup End

            //redirect to payment page
            
//            Self.currentViewController?.navigationController?
//            .pushViewController(
//                HandyPaymentVC.initWithStory(job: job),
//                animated: true)
//            self.routeToPayment(forTrip: trip)
        case .scheduled,.beginJob,.endJob:
            //redirect to driver info map page
            switch AppWebConstants.businessType {
            case .Services:
                // Handy Splitup End
                if let vc = Self.currentViewController?.navigationController?.viewControllers.last ,
                   vc.isKind(of: HandyRouteVC.self) {
                    guard (vc as! HandyRouteVC).jobID != jobID else { return }
                }
                let vc = HandyRouteVC.initWithStory(forJobID: jobID)
                Self.currentViewController?.navigationController?.pushViewController(vc, animated: true)
                // Handy Splitup Start
            default:
                print("Hello")
            }
             //Delivery Splitup End
        default:
            print("Some unexpected Status mate !")
            
        }
    }
    // Delivery Splitup Start

    func routeToTripScreen(forTrip trip : HandyJobDetailModel){
        
    }
    // Delivery Splitup End

    func routeToPayment(forTrip trip : HandyJobDetailModel){
        if let vc = Self.currentViewController?.navigationController?.viewControllers.last ,
           vc.isKind(of: HandyPaymentVC.self) {
            guard (vc as! HandyPaymentVC).jobID != trip.users.jobID else { return }
        }
        let vc = HandyPaymentVC.initWithStory(job: trip,
                                              jobID: trip.users.jobID,
                                              jobStatus: trip.users.jobStatus,  promoId: trip.users.promoId)
        Self.currentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToRating(forTrip trip : HandyJobDetailModel){/*
        let propertyView = Stories.Main.instance.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
        
        let id = trip.getTripID
        propertyView.strDriverImgUrl = trip.driver_thumb_image
        propertyView.strTripID = String(id)
        propertyView.isFromTripPage = true
        currentViewController.navigationController?.pushViewController(propertyView, animated: true)*/
        if let vc = Self.currentViewController?.navigationController?.viewControllers.last ,
           vc.isKind(of: RateYourRideVC.self) {
            guard (vc as! RateYourRideVC).jobId != trip.users.jobID.description else { return }
        }
        let jobId = "\(trip.users.jobID)"
        let rateDriverVC : RateYourRideVC = .initWithStory(jobId: jobId, userName: trip.users.name, userImage: trip.users.image)
        Self.currentViewController?.navigationController?.pushViewController(rateDriverVC,
                                                                       animated: true)
        
    }
    
    func routeToDetailTripHistory(forTrip trip : HandyJobDetailModel){
        //redirect to trip details page
        guard let vc = Self.currentViewController?.navigationController?.viewControllers.last ,
        !vc.isKind(of: HandyTripHistoryVC.self)  else { return }
        let propertyView : HandyTripHistoryVC = UIStoryboard.gojekCommon.instantiateViewController()
        Self.currentViewController?.navigationController?.pushViewController(propertyView, animated: true)
    }
 
}
