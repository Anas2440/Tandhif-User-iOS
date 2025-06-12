//
//  TripEnums.swift
//  Gofer
//
//  Created by trioangle on 09/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

enum RouteVCViewOptions{
    case list,map
}

enum MoreOptions:String,CaseIterable{
    case Call
    case Message
    case LiveTrack = "Live Track"
    case JobProgress = "Job Progress"
    case ThirdPartyNavigation = "Navigate"
    case SOS
    case RequestedService = "Requested Service"
    case ViewRecipients = "View Recipients"
    case Cancel_Booking = "Cancel Booking"
   
    var localizedString : String {
      switch self {
      
      case .Call:
        return LangCommon.call.lowercased().capitalized
      case .Message:
        return LangCommon.message
      case .LiveTrack:
        return LangHandy.liveTrack
      case .JobProgress:
        return LangHandy.jobProgress
      case .ThirdPartyNavigation:
        return LangHandy.navigate
      case .SOS:
        return "SOS"
      case .RequestedService:
        return LangHandy.requestedService
      case .Cancel_Booking:
        return LangHandy.cancelBooking
      case .ViewRecipients:
        return ""
//      @unknown default:
//        return ""
      }
    }
}


enum TripStatus : String,Codable{
    case cancelled = "Cancelled"
    case completed = "Completed"
    case rating = "Rating"
    case payment = "Payment"
    case request = "Request"
    case beginTrip = "Begin trip"
    case endTrip =  "End trip"
    case scheduled = "Scheduled"
    case pending  =  "Pending"
    
    case manuallyBooked = "manual_booking_trip_assigned"
    case manuallyBookedReminder = "manual_booking_trip_reminder"
    case manualBookiingCancelled = "manual_booking_trip_canceled_info"
    case manualBookingInfo = "manual_booking_trip_booked_info"
    
    var isTripStarted :Bool{
          return [TripStatus.beginTrip,.endTrip].contains(self)
      }
    
    var localizedValue: String {
        switch self {
        case .cancelled:
            return LangCommon.cancelledStatus
        case .completed:
            return LangCommon.completedStatus
        case .rating:
            return LangCommon.ratingStatus
        case .payment:
            return LangCommon.paymentStatus
        case .request:
            return LangCommon.requestStatus
        case .beginTrip:
            return LangCommon.beginTripStatus
        case .endTrip:
            return LangCommon.endTripStatus
        case .scheduled:
            return LangCommon.scheduledStatus
        case .pending:
            return LangCommon.pendingStatus
        case .manuallyBooked:
            return LangCommon.manuallyBookedAlert
        case .manuallyBookedReminder:
            return LangCommon.manuallyBookedReminderAlert
        case .manualBookiingCancelled:
            return LangCommon.manualBookiingCancelledAlert
        case .manualBookingInfo:
            return LangCommon.manuallyBookedAlert
        }
    }
}
enum BookingEnum : String, Codable{
    case schedule = "Schedule Booking"
    case auto = "Trip"
    case manualBooking = "Manual Booking"//ignore case
    
    var localizedValue: String {
        switch self {
        case .schedule:
            return LangCommon.scheduleBooking
        case .manualBooking:
            return LangCommon.manualBooking
        case .auto:
            return ""
        }
    }
}

extension TripStatus {
    var getAlertTitle : String{
        switch self {
        case .request:
            return ""
        default:
            return ""
        }
    }
//    var localizedValue : String{
//        let language = Shared.instance.language!
//        switch self {
//            case .pending :  return LangCommon.pendingStatus
//            case .cancelled :  return LangCommon.cancelledStatus
//            case .completed :  return LangCommon.completedStatus
//            case .rating :  return LangCommon.ratingStatus
//            case .payment :  return LangCommon.paymentStatus
//            case .request :  return LangCommon.requestStatus
//            case .beginTrip :  return language.gofer.beginTripStatus
//            case .endTrip :  return language.gofer.endTripStatus
//            case .scheduled :  return LangCommon.scheduledStatus
//            default : return self.rawValue
//        }
//    }
}
