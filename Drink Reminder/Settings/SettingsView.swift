//
//  SettingsView.swift
//  Drink Reminder
//
//  Created by Codex on 2026/3/9.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Environment(ReminderManager.self) private var reminderManager

    @State private var intervalChoice: IntervalChoice = .minutes60
    @State private var customIntervalText = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var enableNotification = true
    @State private var validationMessage: String?

    private let calendar = Calendar.current

    var body: some View {
        Form {
            Section("Interval") {
                Picker("Reminder Interval", selection: $intervalChoice) {
                    ForEach(IntervalChoice.allCases) { choice in
                        Text(choice.title).tag(choice)
                    }
                }

                if intervalChoice == .custom {
                    TextField("Custom interval (minutes)", text: $customIntervalText)
                        .textFieldStyle(.roundedBorder)
                }
            }

            Section("Reminder Time Range") {
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
            }

            Section("Reminder Mode") {
                Toggle("System Notification", isOn: $enableNotification)

                if enableNotification && reminderManager.notificationAuthorizationStatus == .denied {
                    Button("Enable notifications in System Settings") {
                        reminderManager.openSystemNotificationSettings()
                    }
                    .buttonStyle(.plain)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                }
            }

            if let validationMessage {
                Section {
                    Text(validationMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                HStack {
                    Spacer()

                    Button("Save") {
                        saveSettings()
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
        .task {
            sync(from: reminderManager.settings)
        }
        .onChange(of: reminderManager.settings) { _, newSettings in
            sync(from: newSettings)
        }
    }

    private func saveSettings() {
        guard let intervalMinutes = resolvedIntervalMinutes else {
            validationMessage = "Enter a valid custom interval."
            return
        }

        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)

        let updatedSettings = AppSettings(
            reminderIntervalMinutes: intervalMinutes,
            startHour: startComponents.hour ?? 9,
            startMinute: startComponents.minute ?? 0,
            endHour: endComponents.hour ?? 20,
            endMinute: endComponents.minute ?? 0,
            enableNotification: enableNotification
        )

        switch reminderManager.updateSettings(updatedSettings) {
        case .valid:
            validationMessage = nil
        case .invalid(let error):
            validationMessage = error.errorDescription
        }
    }

    private func sync(from settings: AppSettings) {
        intervalChoice = IntervalChoice.choice(for: settings.reminderIntervalMinutes)
        if intervalChoice == .custom {
            customIntervalText = String(settings.reminderIntervalMinutes)
        } else {
            customIntervalText = ""
        }

        startTime = TimeUtils.time(
            onSameDayAs: Date(),
            hour: settings.startHour,
            minute: settings.startMinute,
            calendar: calendar
        )
        endTime = TimeUtils.time(
            onSameDayAs: Date(),
            hour: settings.endHour,
            minute: settings.endMinute,
            calendar: calendar
        )
        enableNotification = settings.enableNotification
        validationMessage = nil
    }

    private var resolvedIntervalMinutes: Int? {
        switch intervalChoice {
        case .minutes5:
            return 5
        case .minutes10:
            return 10
        case .minutes15:
            return 15
        case .minutes30:
            return 30
        case .minutes45:
            return 45
        case .minutes60:
            return 60
        case .custom:
            return Int(customIntervalText.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}

private enum IntervalChoice: String, CaseIterable, Identifiable {
    case minutes5
    case minutes10
    case minutes15
    case minutes30
    case minutes45
    case minutes60
    case custom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .minutes5:
            return "5 minutes"
        case .minutes10:
            return "10 minutes"
        case .minutes15:
            return "15 minutes"
        case .minutes30:
            return "30 minutes"
        case .minutes45:
            return "45 minutes"
        case .minutes60:
            return "60 minutes"
        case .custom:
            return "Custom"
        }
    }

    static func choice(for intervalMinutes: Int) -> IntervalChoice {
        switch intervalMinutes {
        case 5:
            return .minutes5
        case 10:
            return .minutes10
        case 15:
            return .minutes15
        case 30:
            return .minutes30
        case 45:
            return .minutes45
        case 60:
            return .minutes60
        default:
            return .custom
        }
    }
}

#Preview {
    SettingsView()
        .environment(ReminderManager())
}
