//
//  SettingsViewModel.swift
//  WaterApp
//
//  Created by Grace on 3/9/2025.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var profile = SettingModel(
        name: "",
        age: 0,
        dailyGoal: 2000,
        notificationsEnabled: true,
        notificationFrequency: 15,
        theme: "System"
    )
    
    func updateGoal(to newGoal: Double) {
        profile.dailyGoal = newGoal
    }
    
    func toggleNotifications(_ enabled: Bool) {
        profile.notificationsEnabled = enabled
    }
    
    func updateFrequency(_ minutes: Int) {
        profile.notificationFrequency = minutes
    }
    
    func updateTheme(_ theme: String) {
        profile.theme = theme
    }
    
//    func saveProfile() {
//        // TODO: Persist profile to UserDefaults or CoreData
//    }
}
