//
//  Date+Ext.swift
//  Synthia
//
//  Created by Rafał Wojtuś on 16/02/2023.
//

import Foundation

extension BLEService {
    func bytesToDate(dataArray: Data) -> Date {
        let timeData = [UInt8](dataArray)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMMM, yyyy HH:mm:ss"
        let components = DateComponents(timeZone: .current,
                                        year: Int(timeData[0..<2].uint16),
                                        month: Int(timeData[2]),
                                        day: Int(timeData[3]),
                                        hour: Int(timeData[4]),
                                        minute: Int(timeData[5]),
                                        second: Int(timeData[6]))
        
        let calendar = Calendar.current
        let dateString = dateFormatter.string(from: calendar.date(from: components) ?? Date())
        // swiftlint:disable:next force_unwrapping
        let date = dateFormatter.date(from: dateString)!
        return date
    }
}

extension Numeric {
    init<D: DataProtocol>(_ data: D) {
        var value: Self = .zero
        let size = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0) })
        assert(size == MemoryLayout.size(ofValue: value))
        self = value
    }
}

extension DataProtocol {
    func value<N: Numeric>() -> N { .init(self) }
    var uint16: UInt16 { value() }
}
