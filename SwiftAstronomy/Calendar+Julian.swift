//
//  Calendar+Julian.swift
//  SwiftAstronomy
//
//  Created by venj on 11/18/18.
//  Copyright © 2018 venj. All rights reserved.
//

import Foundation

enum AstroError: Error {
    case invalidDate
    case invalidJulianDay
    case beforeJulianEpoch
}

extension Calendar {

    static func isLeap(_ year: Int) -> Bool {
        // There is no year 0, but instead of throw a exception,
        // we just return false here.
        if year == 0 { return false }
        let y = year > 0 ? year : abs(year + 1)
        if (y % 4 == 0 && y % 100 != 0)
            || y % 400 == 0 { return true }
        return false
    }

    static func isValid(year: Double, month: Double, day: Double) -> Bool {
        let validDayNumbers = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        // Check invalid year, month.
        if year == 0 || // There is no year 0
            month <= 0 || day <= 0 || // There is no 0 or negtive month and day
            year != floor(year) || month != floor(month) || // There is no float number year and month
            month > 12 // Invalid month
        {
            return false
        }
        // Check invalid day
        if month == 2 {
            let febLimit = isLeap(Int(year)) ? 29 : 28
            if Int(day) > febLimit {
                return false
            }
        }
        else if Int(day) > validDayNumbers[Int(month) - 1] {
            return false
        }
        return true
    }

    static func julianDay(ofYear year: Double, month: Double, day: Double) throws -> Double {
        if !isValid(year: year, month: month, day: day) {
            throw AstroError.invalidDate
        }
        if year < -4713 {
            throw AstroError.beforeJulianEpoch
        }
        var correctedMonth = month
        var correctedYear = (year < 0) ? (year + 1) : year // Correction for BC epoch
        if month < 3 {
            correctedMonth += 12
            correctedYear -= 1
        }
        let daysOfYear = floor(365.25 * correctedYear)
        let daysOfMonth = floor(30.6 * (correctedMonth + 1.0))
        let julianBase = daysOfYear + daysOfMonth + day + 1_720_994.5
        if year < 1582 || year == 1582 && month < 10 || year == 1582 && month == 10 && day <= 4 {
            return julianBase
        }
        else if year == 1582 && month == 10 && ( day > 4 || day <= 14 ) {
            throw AstroError.invalidJulianDay
        }
        else {
            let correction = floor(correctedYear / 400.0) - floor(correctedYear / 100.0) + 2.0
            return julianBase + correction
        }
    }
}

extension Date {
    init?(julianDay jd: Double) {
        if jd < -0.5 {
            return nil
        }
        var w = floor(jd) + 0.5
        var fDay = jd - w
        if fDay < 0 {
            fDay = fDay + 1.0
            w = w - 1.0
        }

        var s = w - 1721116.5
        w = 0
        var year = floor(s / 365.25)
        var y1: Double
        repeat {
            y1 = year
            if jd >= 2299160.5 {
                w = floor(year / 100.0) + floor(year / 400.0) + 2
                year = floor((s - w) / 365.25)
            }
        } while (year != y1)

        s = s - w
        w = s

        s = s - floor(365.25 * year)

        if s == 0 {
            year = year - 1
            s = w - floor( 365.25 * year)
        }

        s = s + 122.0
        var month = floor(s / 30.6) - 1
        var d = s - floor(30.6 * (month + 1))
        if d == 0 {
            month = month - 1
            d = s - floor(30.6 * (month + 1))
        }

        w = d + fDay
        let day = floor(w)
        fDay = w - day

        if month > 12 {
            month = month - 12
            year = year + 1
        }

        let hour = (day - floor(day)) * 24.0
        let minute = (hour - floor(hour)) * 60.0
        let second = (minute - floor(minute)) * 60.0

        let components = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(secondsFromGMT: 0)!, year: Int(year), month: Int(month), day: Int(day), hour: Int(hour), minute: Int(minute), second: Int(second))
        guard let date = components.date else { return nil }
        self = date
    }

    func julianDay() throws -> Double {
        let cal = Calendar(identifier: .gregorian)
        let components = cal.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: self)
        let year = Double(components.year!)
        let month = Double(components.month!)
        var day = Double(components.day!)
        let hour = Double(components.hour!)
        let minute = Double(components.minute!)
        let second = Double(components.second!)
        day = day + hour / 24.0 + minute / 1440.0 + second / 86400.0
        return try Calendar.julianDay(ofYear: year, month: month, day: day)
    }
}
