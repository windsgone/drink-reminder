//
//  Drink_ReminderApp.swift
//  Drink Reminder
//
//  Created by Zhongyang Fan on 2026/3/9.
//

import SwiftUI

@main
struct Drink_ReminderApp: App {
    @State private var reminderManager = ReminderManager()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environment(reminderManager)
        } label: {
            Image(systemName: "drop.fill")
                .accessibilityLabel("Drink Reminder")
        }
        .menuBarExtraStyle(.menu)

        Settings {
            SettingsView()
                .environment(reminderManager)
                .frame(minWidth: 380, minHeight: 320)
        }
    }
}
