//
//  Date+Extension.swift
//  GoferHandy
//
//  Created by trioangle on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

extension Date {
    enum Day : Int{
        case sun = 1,mon,tue,wed,thu,fri, sat 
        var description : String{
            return "\(self)"
        }
    }
    enum Month : Int{
        case jan = 1,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec
        var description : String{
            return "\(self)"
        }
    }
    
    init(day : Int,month : Month,year : Int){
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month.rawValue
        dateComponents.day = day
        
        let date = gregorianCalendar.date(from: dateComponents)!
        self = date
    }
    var handyFormattedString : String{
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: components)!
        
        return startOfMonth.addingTimeInterval(86400)
    }
    
    func endOfMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        
        let endOfMonth = calendar.date(byAdding: comps2 as DateComponents, to: self.startOfMonth())!

        return endOfMonth//.addingTimeInterval(86400)
    }
    func monthsInYear() -> [Date]{
        var dates = [Date]()
        let calendar = Calendar.current
        let monthsOfYearRange = calendar.range(of: .month, in: .year, for: self)
        //print(monthsOfYearRange as Any)
        
        if let monthsOfYearRange = monthsOfYearRange {
            let year = calendar.component(.year, from: self)
            
            for monthOfYear in (monthsOfYearRange.lowerBound..<monthsOfYearRange.upperBound) {
                let components = DateComponents(year: year, month: monthOfYear)
                guard let date = Calendar.current.date(from: components) else { continue }
                dates.append(date)
            }
        }
        return dates
    }
    func getDatesForMonth() -> [Date]{
        let firstDate = self.startOfMonth()
        let lastDate = self.endOfMonth()
        
        if firstDate > lastDate { return [Date]() }
        
        var tempDate = firstDate
        var array = [tempDate]
        
        while tempDate < lastDate {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    static func get30Dates() ->[Date]{
        let firstDate = Date()
        var counter = 0
        
        
        var tempDate = firstDate
        var array = [tempDate]
        
        while counter < 30 {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
            counter += 1
        }
        
        return array
    }
    var day : Int{
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let currentDateInt = (calendar?.component(NSCalendar.Unit.day, from: self))!
        
        return currentDateInt
    }
    var weekDay : Date.Day{
//        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let currentDayInt = Calendar.current.component(.weekday, from: self)
        
        return Day(rawValue: currentDayInt) ?? .sun
    }
    var month : Date.Month{
        _ = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let currentMonthInt = Int(self.handyFormattedString.split(separator: "/").value(atSafe: 1) ?? "1") ?? 1
        //calendar.component(.month, from: self)
       
        return Month(rawValue: currentMonthInt) ?? .jan
        
    }
    
    var year : Int{
        _ = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
//        let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: self))!
        let currentYearInt = Int(self.handyFormattedString.split(separator: "/").value(atSafe: 2) ?? "2020") ?? 2020
        return currentYearInt
        
    }
}



extension String {
    func toInt()->Int{
        
        return (self as NSString).integerValue
    }
    
    
    func toDouble()->Double {
        return (self as NSString).doubleValue
    }
    
    
    func checkWhiteSpace()->Bool {
        
        let range = trimmingCharacters(in: .whitespaces)
        if range.isEmpty {
           return true
        }
        else {
            return false
        }
    }
}
