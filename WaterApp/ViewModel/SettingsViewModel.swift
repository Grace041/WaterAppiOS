//
//  SettingsViewModel.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 3/9/2025.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var profile = UserProfile()
    
    private let profileKey = "userProfile"
    
    init() {
        loadProfile()
    }
    
    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    func loadProfile() {
        if let savedData = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
            profile = decoded
        }
    }
    
    // Sync with WaterViewModel
    func syncWithWaterViewModel(_ waterVM: WaterViewModel) {
        waterVM.updateDailyGoal(profile.dailyGoal)
        waterVM.updateNotificationSettings(
            enabled: profile.notificationsEnabled,
            frequency: profile.notificationFrequency
        )
    }
}

struct UserProfile: Codable {
    var name: String = ""
    var age: Int = 0
    var notificationsEnabled: Bool = true
    var notificationFrequency: Int = 30
    var dailyGoal: Double = 2000
    var theme: String = "System"
}
