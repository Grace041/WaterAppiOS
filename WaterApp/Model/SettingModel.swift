//
//  SettingModel.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 4/9/2025.
//

import Foundation

struct SettingModel: Codable {
    var name: String
    var age: Int
    var dailyGoal: Double // in ml
    var notificationsEnabled: Bool
    var notificationFrequency: Int // in minutes
    var theme: String
}

