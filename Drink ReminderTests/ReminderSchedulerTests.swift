//
//  ReminderSchedulerTests.swift
//  Drink ReminderTests
//
//  Created by Codex on 2026/3/9.
//

import XCTest
@testable import Drink_Reminder

final class ReminderSchedulerTests: XCTestCase {
    private var calendar: Calendar!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }

    func testCalculateNextReminderWithinWindowWithoutLastDrinkUsesNowPlusInterval() {
        let settings = makeSettings()
        let now = makeDate(year: 2026, month: 3, day: 9, hour: 10, minute: 15)
        let state = ReminderState(lastProcessedDay: TimeUtils.startOfDay(for: now, calendar: calendar))

        let nextReminder = ReminderScheduler.calculateNextReminder(
            now: now,
            state: state,
            settings: settings,
            calendar: calendar
        )

        XCTAssertEqual(nextReminder, makeDate(year: 2026, month: 3, day: 9, hour: 11, minute: 15))
    }

    func testCalculateNextReminderWithLastDrinkUsesDrinkTimePlusInterval() {
        let settings = makeSettings()
        let now = makeDate(year: 2026, month: 3, day: 9, hour: 10, minute: 15)
        let state = ReminderState(
            lastDrinkTime: makeDate(year: 2026, month: 3, day: 9, hour: 9, minute: 45),
            lastProcessedDay: TimeUtils.startOfDay(for: now, calendar: calendar)
        )

        let nextReminder = ReminderScheduler.calculateNextReminder(
            now: now,
            state: state,
            settings: settings,
            calendar: calendar
        )

        XCTAssertEqual(nextReminder, makeDate(year: 2026, month: 3, day: 9, hour: 10, minute: 45))
    }

    func testCalculateNextReminderOutsideWindowUsesNextStartTime() {
        let settings = makeSettings()
        let now = makeDate(year: 2026, month: 3, day: 9, hour: 21, minute: 0)
        let state = ReminderState(lastProcessedDay: TimeUtils.startOfDay(for: now, calendar: calendar))

        let nextReminder = ReminderScheduler.calculateNextReminder(
            now: now,
            state: state,
            settings: settings,
            calendar: calendar
        )

        XCTAssertEqual(nextReminder, makeDate(year: 2026, month: 3, day: 10, hour: 9, minute: 0))
    }

    func testSnoozedReminderWinsDuringRecalculation() {
        let settings = makeSettings()
        let now = makeDate(year: 2026, month: 3, day: 9, hour: 14, minute: 0)
        let snoozedUntil = makeDate(year: 2026, month: 3, day: 9, hour: 14, minute: 10)
        let state = ReminderState(
            nextReminderTime: snoozedUntil,
            snoozedUntil: snoozedUntil,
            lastProcessedDay: TimeUtils.startOfDay(for: now, calendar: calendar)
        )

        let nextReminder = ReminderScheduler.calculateNextReminder(
            now: now,
            state: state,
            settings: settings,
            calendar: calendar
        )

        XCTAssertEqual(nextReminder, snoozedUntil)
    }

    func testNextReminderAfterTriggerResetsFromCurrentTime() {
        let settings = makeSettings()
        let now = makeDate(year: 2026, month: 3, day: 9, hour: 16, minute: 5)

        let nextReminder = ReminderScheduler.nextReminderAfterTrigger(
            now: now,
            settings: settings,
            calendar: calendar
        )

        XCTAssertEqual(nextReminder, makeDate(year: 2026, month: 3, day: 9, hour: 17, minute: 5))
    }

    func testPausedStateReturnsNilReminder() {
        let settings = makeSettings()
        let now = makeDate(year: 2026, month: 3, day: 9, hour: 12, minute: 0)
        let state = ReminderState(
            isPausedToday: true,
            lastProcessedDay: TimeUtils.startOfDay(for: now, calendar: calendar)
        )

        let nextReminder = ReminderScheduler.calculateNextReminder(
            now: now,
            state: state,
            settings: settings,
            calendar: calendar
        )

        XCTAssertNil(nextReminder)
    }

    func testReminderAfterWindowEndRollsToNextStart() {
        let settings = makeSettings()
        let now = makeDate(year: 2026, month: 3, day: 9, hour: 19, minute: 50)
        let state = ReminderState(lastProcessedDay: TimeUtils.startOfDay(for: now, calendar: calendar))

        let nextReminder = ReminderScheduler.calculateNextReminder(
            now: now,
            state: state,
            settings: settings,
            calendar: calendar
        )

        XCTAssertEqual(nextReminder, makeDate(year: 2026, month: 3, day: 10, hour: 9, minute: 0))
    }

    private func makeSettings() -> AppSettings {
        AppSettings(
            reminderIntervalMinutes: 60,
            startHour: 9,
            startMinute: 0,
            endHour: 20,
            endMinute: 0,
            enableNotification: true
        )
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
