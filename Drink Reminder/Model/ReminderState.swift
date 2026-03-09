//
//  ReminderState.swift
//  Drink Reminder
//
//  Created by Codex on 2026/3/9.
//

import Foundation

struct ReminderState {
    var lastDrinkTime: Date?
    var nextReminderTime: Date?
    var isPausedToday: Bool
    var snoozedUntil: Date?
    var lastProcessedDay: Date?

    nonisolated init(
        lastDrinkTime: Date? = nil,
        nextReminderTime: Date? = nil,
        isPausedToday: Bool = false,
        snoozedUntil: Date? = nil,
        lastProcessedDay: Date? = nil
    ) {
        self.lastDrinkTime = lastDrinkTime
        self.nextReminderTime = nextReminderTime
        self.isPausedToday = isPausedToday
        self.snoozedUntil = snoozedUntil
        self.lastProcessedDay = lastProcessedDay
    }
}
