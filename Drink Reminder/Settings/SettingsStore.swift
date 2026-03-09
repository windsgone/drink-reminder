//
//  SettingsStore.swift
//  Drink Reminder
//
//  Created by Codex on 2026/3/9.
//

import Foundation

struct SettingsStore {
    private let userDefaults: UserDefaults
    private let key: String

    init(userDefaults: UserDefaults = .standard, key: String = "appSettings") {
        self.userDefaults = userDefaults
        self.key = key
    }

    func load() -> AppSettings {
        guard
            let data = userDefaults.data(forKey: key),
            let settings = try? JSONDecoder().decode(AppSettings.self, from: data)
        else {
            return .default
        }

        return settings
    }

    func save(_ settings: AppSettings) {
        guard let data = try? JSONEncoder().encode(settings) else {
            return
        }

        userDefaults.set(data, forKey: key)
    }
}
