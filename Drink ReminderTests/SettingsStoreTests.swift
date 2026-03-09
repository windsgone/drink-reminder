//
//  SettingsStoreTests.swift
//  Drink ReminderTests
//
//  Created by Codex on 2026/3/9.
//

import XCTest
@testable import Drink_Reminder

final class SettingsStoreTests: XCTestCase {
    func testLoadFallsBackToDefaultSettings() {
        let suiteName = "SettingsStoreTests.default.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)

        let store = SettingsStore(userDefaults: userDefaults, key: "settings")

        XCTAssertEqual(store.load(), .default)
    }

    func testCustomIntervalRoundTripsThroughStore() {
        let suiteName = "SettingsStoreTests.roundtrip.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)

        let store = SettingsStore(userDefaults: userDefaults, key: "settings")
        let settings = AppSettings(
            reminderIntervalMinutes: 75,
            startHour: 8,
            startMinute: 30,
            endHour: 19,
            endMinute: 15,
            enableNotification: false
        )

        store.save(settings)

        XCTAssertEqual(store.load(), settings)
    }

    func testValidationRejectsShortIntervals() {
        let settings = AppSettings(
            reminderIntervalMinutes: 4,
            startHour: 9,
            startMinute: 0,
            endHour: 20,
            endMinute: 0,
            enableNotification: true
        )

        XCTAssertEqual(ReminderScheduler.validate(settings: settings), .invalid(.intervalTooShort))
    }

    func testValidationRejectsEndTimeEarlierThanStartTime() {
        let settings = AppSettings(
            reminderIntervalMinutes: 30,
            startHour: 20,
            startMinute: 0,
            endHour: 19,
            endMinute: 0,
            enableNotification: true
        )

        XCTAssertEqual(
            ReminderScheduler.validate(settings: settings),
            .invalid(.endTimeMustBeAfterStartTime)
        )
    }
}
