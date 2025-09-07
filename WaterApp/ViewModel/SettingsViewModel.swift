//
//  SettingsViewModel.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 3/9/2025.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var profile = SettingModel(
        name: "",
        age: 0,
        dailyGoal: 2000,
        notificationsEnabled: true,
        notificationFrequency: 60, // 1 hour in minutes
        theme: "System"
    )
    
    func updateGoal(to newGoal: Double) {
        profile.dailyGoal = newGoal
        saveData()
    }
    
    func toggleNotifications(_ enabled: Bool) {
        profile.notificationsEnabled = enabled
        saveData()
    }
    
    func updateFrequency(_ minutes: Int) {
        profile.notificationFrequency = minutes
        saveData()
    }
    
    func updateTheme(_ theme: String) {
        profile.theme = theme
        saveData()
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: "userProfile")
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let decoded = try? JSONDecoder().decode(SettingModel.self, from: data) {
            profile = decoded
        }
    }
}
