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
    
    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(currentIntake / dailyGoal, 1.0)
    }
    
    private let intakeKey = "currentWaterIntake"
    private let goalKey = "dailyWaterGoal"
    private let lastResetDateKey = "lastResetDate"
    
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
    
    private func saveData() {
        UserDefaults.standard.set(currentIntake, forKey: intakeKey)
        UserDefaults.standard.set(dailyGoal, forKey: goalKey)
        UserDefaults.standard.set(Date(), forKey: lastResetDateKey)
    }
    
    private func loadData() {
        currentIntake = UserDefaults.standard.double(forKey: intakeKey)
        dailyGoal = UserDefaults.standard.double(forKey: goalKey)
        
        // Set default goal if none exists
        if dailyGoal == 0 {
            dailyGoal = 2000
        }
    }
    
    private func resetIfNewDay() {
        let calendar = Calendar.current
        let now = Date()
        
        if let lastResetDate = UserDefaults.standard.object(forKey: lastResetDateKey) as? Date {
            if !calendar.isDate(now, inSameDayAs: lastResetDate) {
                // It's a new day, reset intake
                currentIntake = 0
                saveData()
            }
        } else {
            // First time using the app
            saveData()
        }
    }
    
    func updateDailyGoal(_ newGoal: Double) {
        dailyGoal = newGoal
        saveData()
    }
}

