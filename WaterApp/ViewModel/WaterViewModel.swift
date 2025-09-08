//
//  WaterViewModel.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 4/9/2025.
//

import Foundation
import SwiftUI

class WaterViewModel: ObservableObject {
    @Published var currentIntake: Double = 0
    @Published var dailyGoal: Double = 2000
    @Published var notificationsEnabled: Bool = true
    @Published var notificationFrequency: Int = 2
    
    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(currentIntake / dailyGoal, 1.0)
    }
    
    private let intakeKey = "currentWaterIntake"
    private let goalKey = "dailyWaterGoal"
    private let lastResetDateKey = "lastResetDate"
    private let frequencyKey = "notificationFrequency"
    private let notificationsKey = "notificationsEnabled"
    
    init() {
        loadData()
        resetIfNewDay()
    }
    
    func addWater(amount: Double) {
        currentIntake += amount
        saveData()
    }
    
    func removeWater(amount: Double) {
        currentIntake = max(0, currentIntake - amount)
        saveData()
    }
    
    func updateDailyGoal(_ newGoal: Double) {
        dailyGoal = newGoal
        saveData()
    }
   
    func updateNotificationSettings(enabled: Bool, frequency: Int) {
        notificationsEnabled = enabled
        notificationFrequency = frequency
        saveData()
    }
    
    private func saveData() {
        UserDefaults.standard.set(currentIntake, forKey: intakeKey)
        UserDefaults.standard.set(dailyGoal, forKey: goalKey)
        UserDefaults.standard.set(Date(), forKey: lastResetDateKey)
        UserDefaults.standard.set(notificationsEnabled, forKey: notificationsKey)
        UserDefaults.standard.set(notificationFrequency, forKey: frequencyKey)
    }
    
    private func loadData() {
        currentIntake = UserDefaults.standard.double(forKey: intakeKey)
        dailyGoal = UserDefaults.standard.double(forKey: goalKey)
        notificationsEnabled = UserDefaults.standard.bool(forKey: notificationsKey)
        notificationFrequency = UserDefaults.standard.integer(forKey: frequencyKey)
        
        // Set default goal if none exists
        if dailyGoal == 0 {
            dailyGoal = 2000
        }
        if notificationFrequency == 0 {
            notificationFrequency = 1
        }
    }
    
    private func resetIfNewDay() {
        let calendar = Calendar.current
        let now = Date()
        
        if let lastResetDate = UserDefaults.standard.object(forKey: lastResetDateKey) as? Date {
            if !calendar.isDate(now, inSameDayAs: lastResetDate) {
                currentIntake = 0
                saveData()
            }
        } else {
            saveData()
        }
    }
}

