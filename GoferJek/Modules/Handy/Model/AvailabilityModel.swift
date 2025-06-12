//
//  AvailableDayModel.swift
//  GoferHandy
//
//  Created by trioangle on 11/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
typealias WeekDataSource = [DayEnum : [DayElement]]
// MARK: - AvailabilityModel
class AvailabilityModel: Codable {
    let statusCode: Int
    let statusMessage: String
    let availableTimes: AvailableTimes

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case availableTimes = "available_times"
    }
    required init(from decoder : Decoder) throws{
           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.availableTimes = try container.decode(AvailableTimes.self, forKey: .availableTimes)
         self.statusCode = container.safeDecodeValue(forKey: .statusCode)
         self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
       }
  
}

// MARK: - AvailableTimes
class AvailableTimes: Codable {
    let monday, tuesday, wednesday, thursday: [DayElement]
    let friday, saturday, sunday: [DayElement]

    required init(from decoder : Decoder)throws{
          let container = try decoder.container(keyedBy: CodingKeys.self)
    let monday = try? container.decode([DayElement].self, forKey: .monday)
    self.monday = monday ?? [DayElement]()
    let tuesday = try? container.decode([DayElement].self, forKey: .tuesday)
    self.tuesday = tuesday ?? [DayElement]()
    let wednesday = try? container.decode([DayElement].self, forKey: .wednesday)
    self.wednesday = wednesday ?? [DayElement]()
    let thursday = try? container.decode([DayElement].self, forKey: .thursday)
    self.thursday = thursday ?? [DayElement]()
    let friday = try? container.decode([DayElement].self, forKey: .friday)
    self.friday = friday ?? [DayElement]()
    let saturday = try? container.decode([DayElement].self, forKey: .saturday)
    self.saturday = saturday ?? [DayElement]()
    let sunday = try? container.decode([DayElement].self, forKey: .sunday)
    self.sunday = sunday ?? [DayElement]()
    }

    lazy var dataSource : WeekDataSource = {
      return [
        .sunday : self.sunday,
        .monday : self.monday,
        .tuesday : self.tuesday,
        .wednesday : self.wednesday,
        .thursday : self.thursday,
        .friday : self.friday,
        .saturday : self.saturday
        ]
    }()
}

// MARK: - DayElement
class DayElement: Codable {
    let time, value: String
    let day: DayEnum
    var status: Bool


    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
      self.time = container.safeDecodeValue(forKey: .time)
      self.value = container.safeDecodeValue(forKey: .value)
    self.day = try container.decode(DayEnum.self, forKey: .day)
    self.status = container.safeDecodeValue(forKey: .status)

    }
}

enum DayEnum: String, Codable {
    case friday = "friday"
    case monday = "monday"
    case saturday = "saturday"
    case sunday = "sunday"
    case thursday = "thursday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    
    var intValue : Int{
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
//    init(from dateWeekDay : Date.Day){
//        self = DayEnum(fromInt: 7 - dateWeekDay.rawValue)
//    }
    init(fromInt intValue: Int){
        switch intValue {
        case 1: self = .sunday
        case 2: self = .monday
        case 3: self = .tuesday
        case 4: self = .wednesday
        case 5: self = .thursday
        case 6: self = .friday
        case 7: self = .saturday
        default: self = .sunday
        }
    }
}
extension DayEnum : Equatable,Hashable{
    
}
