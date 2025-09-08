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
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(notificationFrequency, forKey: "notificationFrequency")
        UserDefaults.standard.set(currentIntake, forKey: "currentWaterIntake")
        UserDefaults.standard.set(dailyGoal, forKey: "dailyWaterGoal")
        UserDefaults.standard.set(Date(), forKey: "lastResetDate")
    }
    
    private func loadData() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        notificationFrequency = UserDefaults.standard.integer(forKey: "notificationFrequency")
        currentIntake = UserDefaults.standard.double(forKey: "currentWaterIntake")
        dailyGoal = UserDefaults.standard.double(forKey: "dailyWaterGoal")
        
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

