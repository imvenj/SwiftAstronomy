//
//  SwiftAstronomyTests.swift
//  SwiftAstronomyTests
//
//  Created by venj on 11/18/18.
//  Copyright © 2018 venj. All rights reserved.
//

import XCTest
@testable import SwiftAstronomy

class SwiftAstronomyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLeapYear() {
        // Test invalid year
        let l1 = Calendar.isLeap(0)
        XCTAssertFalse(l1)

        // Test year 1
        let l2 = Calendar.isLeap(1)
        XCTAssertFalse(l2)

        // Test year -4
        let l3 = Calendar.isLeap(-4)
        XCTAssertFalse(l3)

        // Test year -5 is indeed a leap year
        let l4 = Calendar.isLeap(-5)
        XCTAssertTrue(l4)

        // Test year 100
        let l5 = Calendar.isLeap(100)
        XCTAssertFalse(l5)

        // Test year 400
        let l6 = Calendar.isLeap(400)
        XCTAssertTrue(l6)

        // Test year 2018
        let l7 = Calendar.isLeap(2018)
        XCTAssertFalse(l7)

        // Test year 2020
        let l8 = Calendar.isLeap(2020)
        XCTAssertTrue(l8)

        // Test year -101
        let l9 = Calendar.isLeap(-101)
        XCTAssertFalse(l9)

        // Test year -401
        let l10 = Calendar.isLeap(-401)
        XCTAssertTrue(l10)
    }

    func testNormalJulianDay() {
        let j1 = try! Calendar.julianDay(ofYear: 2018, month: 11, day: 18)
        XCTAssertEqual(j1, 2458440.5)

        // First day in AD epoch.
        let j2 = try! Calendar.julianDay(ofYear: 1, month: 1, day: 1)
        XCTAssertEqual(j2, 1721423.5)

        // Last day in BC epoch.
        let j3 = try! Calendar.julianDay(ofYear: -1, month: 12, day: 31)
        XCTAssertEqual(j3, 1721422.5)

        // First Julian day!
        // Because the start time is at noon, so the beginning is -0.5.
        let j4 = try! Calendar.julianDay(ofYear: -4713, month: 1, day: 1)
        XCTAssertEqual(j4, -0.5)
    }

    func testNormalJulianDayFromDate() {
        // 2018-11-18 13:45:06 +0800
        let today = Date(timeIntervalSince1970: 1542519906)
        XCTAssertEqual(floor(try! today.julianDay()), 2458440)
    }

    func testInvalidDate() {
        // There is no year 0
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 0, month: 1, day: 1))
        // There is no Feb 29 for 2018
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 2018, month: 2, day: 29))
        // There is no negtive month
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 2018, month: -2, day: 1))
        // There is no negtive day
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 2018, month: 2, day: -1))
        // There is no float number year
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 2018.1, month: 2, day: 1))
        // There is no float number month
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 2018, month: 2.1, day: 1))
        // There is no month 13
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 2018, month: 13, day: 1))
        // There is no day 32
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 2018, month: 12, day: 32))
        // Year before Julian Epoch not supported
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: -4714, month: 12, day: 31))
        // There is no Oct 5-14, 1582 in history.
        XCTAssertThrowsError(try Calendar.julianDay(ofYear: 1582, month: 10, day: 10))
    }

}
