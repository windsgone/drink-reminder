//
//  ReminderManagerTests.swift
//  Drink ReminderTests
//
//  Created by Codex on 2026/3/9.
//

import XCTest
@testable import Drink_Reminder

@MainActor
final class ReminderManagerTests: XCTestCase {
    private var calendar: Calendar!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }

    func testResumeRemindersClearsPausedStateAndRecalculatesSchedule() {
        let manager = ReminderManager(calendar: calendar)
        let now = makeDate(year: 2026, month: 3, day: 9, hour: 12, minute: 0)

        manager.pauseToday(now: now)
        XCTAssertTrue(manager.state.isPausedToday)
        XCTAssertNil(manager.state.nextReminderTime)

        manager.resumeReminders(now: now)

        XCTAssertFalse(manager.state.isPausedToday)
        XCTAssertNil(manager.state.snoozedUntil)
        XCTAssertEqual(manager.state.nextReminderTime, makeDate(year: 2026, month: 3, day: 9, hour: 13, minute: 0))
    }

    private func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        return calendar.date(from: components)!
    }
}
