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
    @Published var dailyGoal: Double = 2000 // default in ml
    @Published var history: [WaterIntake] = []
    
    var progress: Double {
        dailyGoal > 0 ? currentIntake / dailyGoal : 0
    }
    
    func addWater(amount: Double) {
        currentIntake += amount
        history.append(WaterIntake(amount: amount, date: Date()))
    }
    
    func removeWater(amount: Double) {
        currentIntake = max(0, currentIntake - amount)
        history.append(WaterIntake(amount: -amount, date: Date()))
    }
    
    func resetDay() {
        currentIntake = 0
        history.removeAll()
    }
}
