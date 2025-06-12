//
//  JobEnums.swift
//  GoferHandy
//
//  Created by trioangle on 18/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
enum HandyJobStatus : String,Codable,CaseIterable{

    case manuallyBooked = "manual_booking_job_assigned"
    case manuallyBookedReminder = "manual_booking_job_reminder"
    case manualBookiingCancelled = "manual_booking_job_canceled_info"
    case manualBookingInfo = "manual_booking_job_booked_info"
    
    case pending = "Pending"
    case scheduled = "Scheduled"
    case request = "Request"
    case beginJob = "Begin job"
    case endJob =  "End job"
    case payment = "Payment"
    case cancelled = "Cancelled"
    case completed = "Completed"
    case rating = "Rating"
    
    
    var isTripStarted :Bool{
        return !(self < .endJob)
    }
    
    var isTripCompleted : Bool {
        return (self == .completed ||
                self == .cancelled ||
                self == .rating)
    }
    
    var isDeliveryTripStarted :Bool{
          return false
      }
    var localizedString: String {
      switch self {
      case .pending:
        return LangCommon.pendingStatus.capitalized
      case .scheduled:
        return LangCommon.scheduledStatus.capitalized
      case .request:
        return LangCommon.requestStatus.capitalized
      case .manuallyBooked:
        return ""
      case .manuallyBookedReminder:
        return ""
      case .manualBookiingCancelled:
        return ""
      case .manualBookingInfo:
        return ""
      case .beginJob:
        return LangCommon.beginJob.capitalized
      case .endJob:
        return LangCommon.endJob.capitalized
      case .payment:
        return LangCommon.paymentStatus.capitalized
      case .cancelled:
        return LangCommon.cancelledStatus.capitalized
      case .completed:
        return LangCommon.completedStatus.capitalized
      case .rating:
        return LangCommon.ratingStatus.capitalized
      }
    }
    var alertSuffix : String {
        switch self {
        case .manuallyBooked: return LangCommon.manuallyBookedAlert
        case .manuallyBookedReminder: return LangCommon.manuallyBookedReminderAlert
        case .manualBookiingCancelled: return LangCommon.manualBookiingCancelledAlert
        case .manualBookingInfo: return LangCommon.manuallyBookedAlert
        case .scheduled: return LangCommon.scheduledStatus
        case .request: return LangCommon.requestStatus
        case .beginJob: return LangCommon.beginJobAlert
        case .endJob: return LangCommon.endJobAlert
        case .pending: return LangCommon.pendingStatus
        case .cancelled: return LangCommon.cancelledStatus
        case .completed: return LangCommon.completedStatus
        case .rating: return LangCommon.ratingAlert
        case .payment: return LangCommon.paymentAlert
        }
    }
}
extension HandyJobStatus : Comparable{
    static func < (lhs: HandyJobStatus, rhs: HandyJobStatus) -> Bool {
        let items = Self.allCases
        let lhsItemPos = items.find(includedElement: {$0 == lhs}) ?? 0
        let rhsItemPos = items.find(includedElement: {$0 == rhs}) ?? 0
        return lhsItemPos < rhsItemPos
        
    }
    
    
}
