//
//  AppSettings.swift
//  Drink Reminder
//
//  Created by Codex on 2026/3/9.
//

import Foundation

struct AppSettings: Codable, Equatable {
    var reminderIntervalMinutes: Int
    var standingReminderIntervalMinutes: Int
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int
    var enableNotification: Bool

    nonisolated init(
        reminderIntervalMinutes: Int,
        standingReminderIntervalMinutes: Int = 40,
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int,
        enableNotification: Bool
    ) {
        self.reminderIntervalMinutes = reminderIntervalMinutes
        self.standingReminderIntervalMinutes = standingReminderIntervalMinutes
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.enableNotification = enableNotification
    }

    nonisolated static let `default` = AppSettings(
        reminderIntervalMinutes: 60,
        standingReminderIntervalMinutes: 40,
        startHour: 9,
        startMinute: 0,
        endHour: 20,
        endMinute: 0,
        enableNotification: true
    )

    private enum CodingKeys: String, CodingKey {
        case reminderIntervalMinutes
        case standingReminderIntervalMinutes
        case startHour
        case startMinute
        case endHour
        case endMinute
        case enableNotification
    }

    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        reminderIntervalMinutes = try container.decode(Int.self, forKey: .reminderIntervalMinutes)
        standingReminderIntervalMinutes = try container.decodeIfPresent(
            Int.self,
            forKey: .standingReminderIntervalMinutes
        ) ?? 40
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        enableNotification = try container.decode(Bool.self, forKey: .enableNotification)
    }
}
