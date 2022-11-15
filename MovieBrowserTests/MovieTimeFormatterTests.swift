//
//  MovieTimeFormatterTests.swift
//  MovieBrowserTests
//
//  Created by Sandro Shanshiashvili on 15.11.22.
//

import XCTest
@testable import MovieBrowser

final class MovieTimeFormatterTests: XCTestCase {
    
    private var timeFormatter: MovieTimeFormatter!

    override func setUpWithError() throws {
        timeFormatter = MovieTimeFormatter()
    }

    override func tearDownWithError() throws {
        timeFormatter = nil
    }
    
    func testConvertMinutesToHours() throws {
        XCTAssertEqual(timeFormatter.minutesToHours(minutes: 100), "1h 40m")
        XCTAssertEqual(timeFormatter.minutesToHours(minutes: 90), "1h 30m")
        XCTAssertEqual(timeFormatter.minutesToHours(minutes: 60), "1h")
    }
    
    func testConvertMinusNumberToHours() throws {
        XCTAssertEqual(timeFormatter.minutesToHours(minutes: -50), "No Info")
    }
    
    func testConvertZeroMinuteToHours() throws {
        XCTAssertEqual(timeFormatter.minutesToHours(minutes: 0), "0m")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
