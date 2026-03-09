import AppKit
import UserNotifications

struct NotificationManager {
    private static let systemNotificationSettingsURL = URL(
        string: "x-apple.systempreferences:com.apple.Notifications-Settings.extension"
    )

    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }

    func authorizationStatus() async -> UNAuthorizationStatus {
        await notificationCenter.notificationSettings().authorizationStatus
    }

    func requestAuthorizationIfNeeded() async -> UNAuthorizationStatus {
        let currentStatus = await authorizationStatus()
        guard currentStatus == .notDetermined else {
            return currentStatus
        }

        _ = try? await notificationCenter.requestAuthorization(options: [.alert, .sound])
        return await authorizationStatus()
    }

    func sendReminder() async {
        let content = UNMutableNotificationContent()
        content.title = "该喝水了"
        content.body = "起来喝几口水吧"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        try? await notificationCenter.add(request)
    }

    func openSystemNotificationSettings() {
        guard let url = Self.systemNotificationSettingsURL else {
            return
        }

        NSWorkspace.shared.open(url)
    }
}
