//
//  AppSettings.swift
//  Drink Reminder
//
//  Created by Codex on 2026/3/9.
//

import Foundation

struct AppSettings: Codable, Equatable {
    var reminderIntervalMinutes: Int
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int
    var enableNotification: Bool

    nonisolated init(
        reminderIntervalMinutes: Int,
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int,
        enableNotification: Bool
    ) {
        self.reminderIntervalMinutes = reminderIntervalMinutes
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.enableNotification = enableNotification
    }

    nonisolated static let `default` = AppSettings(
        reminderIntervalMinutes: 60,
        startHour: 9,
        startMinute: 0,
        endHour: 20,
        endMinute: 0,
        enableNotification: true
    )
}
