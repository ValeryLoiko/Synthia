//
//  NSDate+Ext.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 24/02/2023.
//

import Foundation

struct DateOnly: Equatable {
    let day: Int
    let month: Int
    let year: Int
}

extension DateOnly {
    init(from date: Date) {
        let calendar = Calendar.utc
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        // swiftlint:disable force_unwrapping
        self.year = dateComponents.year!
        self.month = dateComponents.month!
        self.day = dateComponents.day!
        // swiftlint:enable force_unwrapping
    }
}

struct TimeOnly: Equatable {
    let hour: Int
    let minute: Int
}

extension TimeOnly {
    init(from date: Date) {
        let calendar = Calendar.utc
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        // swiftlint:disable force_unwrapping
        self.hour = dateComponents.hour!
        self.minute = dateComponents.minute!
        // swiftlint:enable force_unwrapping
    }
}

extension Date {
    static func utcToLocalDate(utcDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        let localDateString = dateFormatter.string(from: utcDate)
        return localDateString
    }
    
    static func utcToLocalNoYear(utcDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mm"
        dateFormatter.timeZone = TimeZone.current
        let localDateString = dateFormatter.string(from: utcDate)
        return localDateString
    }
    
    static func combineDate(utcDate: DateOnly, utcTime: TimeOnly) -> Date {
        let calendar = Calendar.utc
        var mergedComponents = DateComponents()
        mergedComponents.year = utcDate.year
        mergedComponents.month = utcDate.month
        mergedComponents.day = utcDate.day
        mergedComponents.hour = utcTime.hour
        mergedComponents.minute = utcTime.minute
        let mergedDate = calendar.date(from: mergedComponents) ?? Date()
        return mergedDate
    }
    
    var startOfDay: Date {
          return Calendar.current.startOfDay(for: self)
      }
    
    var endOfDay: Date {
          var components = DateComponents()
          components.day = 1
          components.second = -1
          return Calendar.current.date(byAdding: components, to: startOfDay)!
      }
}

extension Calendar {
    static var utc: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        // swiftlint:disable:next force_unwrapping
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar
    }()
}
