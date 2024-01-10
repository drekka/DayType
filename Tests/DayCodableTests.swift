//
//  DayCodableTests.swift
//
//
//  Created by Derek Clarkson on 9/12/2023.
//

import DayType
import Nimble
import XCTest

class DayCodableTests: XCTestCase {

    struct DummyType: Codable {
        let abc: Day
    }

    func testBaseDecoding() throws {

        let json = """
        {
            "abc": 19455
        }
        """

        let decoder = JSONDecoder()
        let day = try decoder.decode(DummyType.self, from: json.data(using: .utf8)!)
        expect(day.abc.daysSince1970) == 19455
    }

    func testEncoding() throws {
        let obj = DummyType(abc: Day(daysSince1970: 19455))
        let encoder = JSONEncoder()
        let encoded = try String(data: encoder.encode(obj), encoding: .utf8)
        expect(encoded).to(contain("\"abc\":19455"))
    }
}
