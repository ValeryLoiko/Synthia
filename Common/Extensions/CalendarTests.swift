//
//  CalendarTest.swift
//  SynthiaTests
//
//  Created by Rafał Wojtuś on 27/02/2023.
//

import XCTest
@testable import Synthia
final class CalendarTest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateOnlyInitialization() throws {
        let calendar = Calendar.utc
        var dateComponents = DateComponents()
        dateComponents.day = 16
        dateComponents.month = 1
        dateComponents.year = 1923
        // swiftlint:disable:next force_unwrapping
        let date = calendar.date(from: dateComponents)!
        let checkDate = DateOnly(from: date)
        let dateOnly = DateOnly(day: 16, month: 1, year: 1923)
        XCTAssertEqual(checkDate, dateOnly)
    }
    
    func testTimeOnlyInitialization() throws {
        let calendar = Calendar.utc
        var dateComponents = DateComponents()
        dateComponents.hour = 09
        dateComponents.minute = 59
        // swiftlint:disable:next force_unwrapping
        let date = calendar.date(from: dateComponents)!
        let checkTime = TimeOnly(from: date)
        let timeOnly = TimeOnly(hour: 09, minute: 59)
        XCTAssertEqual(checkTime, timeOnly)
    }
    
    func testCombineDate() throws {
        let calendar = Calendar.current
        let dateOnly = DateOnly(day: 27, month: 02, year: 2023)
        let timeOnly = TimeOnly(hour: 13, minute: 41)
        var mergedComponents = DateComponents()
        mergedComponents.year = dateOnly.year
        mergedComponents.month = dateOnly.month
        mergedComponents.day = dateOnly.day
        mergedComponents.hour = timeOnly.hour
        mergedComponents.minute = timeOnly.minute
        mergedComponents.timeZone = .current
        var targetComponents = DateComponents()
        targetComponents.year = 2023
        targetComponents.month = 02
        targetComponents.day = 27
        targetComponents.hour = 13
        targetComponents.minute = 41
        targetComponents.timeZone = .current
        // swiftlint:disable:next force_unwrapping
        let mergedDate = calendar.date(from: mergedComponents)!
        let targetDate = calendar.date(from: targetComponents)
        XCTAssertEqual(mergedDate, targetDate)
    }
}
