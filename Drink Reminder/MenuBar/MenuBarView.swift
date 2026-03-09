//
//  MenuBarView.swift
//  Drink Reminder
//
//  Created by Codex on 2026/3/9.
//

import AppKit
import SwiftUI
import UserNotifications

struct MenuBarView: View {
    @Environment(ReminderManager.self) private var reminderManager
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        Text(primaryStatusLine)

        if let secondaryStatusLine {
            Text(secondaryStatusLine)
        }

        if let notificationStatusLine {
            Button(notificationStatusLine) {
                reminderManager.openSystemNotificationSettings()
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
        }

        Divider()

        Button("Drink now") {
            reminderManager.drinkNow()
        }
        .disabled(reminderManager.state.isPausedToday)

        Button("Snooze 30 minutes") {
            reminderManager.snooze30Minutes()
        }
        .disabled(reminderManager.state.isPausedToday)

        Button(reminderActionTitle) {
            reminderAction()
        }

        Divider()

        Button("Settings") {
            openSettings()
            NSApplication.shared.activate(ignoringOtherApps: true)
        }

        Divider()

        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }

    private var primaryStatusLine: String {
        if reminderManager.state.isPausedToday {
            return "Paused today"
        }

        if reminderManager.isOutsideReminderWindow {
            return "Outside reminder window"
        }

        if let nextReminderTime = reminderManager.state.nextReminderTime {
            return "Next reminder: \(TimeUtils.menuDateTimeString(nextReminderTime))"
        }

        return "Next reminder unavailable"
    }

    private var secondaryStatusLine: String? {
        guard !reminderManager.state.isPausedToday else {
            return reminderManager.nextReminderDescription
        }

        guard reminderManager.isOutsideReminderWindow else {
            return nil
        }

        return reminderManager.nextReminderDescription
    }

    private var notificationStatusLine: String? {
        if !reminderManager.settings.enableNotification {
            return "Notifications disabled"
        }

        if reminderManager.notificationAuthorizationStatus == .denied {
            return "Enable notifications in System Settings"
        }

        return nil
    }

    private var reminderActionTitle: String {
        reminderManager.state.isPausedToday ? "Resume reminders" : "Pause today"
    }

    private func reminderAction() {
        if reminderManager.state.isPausedToday {
            reminderManager.resumeReminders()
        } else {
            reminderManager.pauseToday()
        }
    }
}

#Preview {
    MenuBarView()
        .environment(ReminderManager())
}
