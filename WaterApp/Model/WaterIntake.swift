//
//  WaterIntake.swift
//  WaterApp
//
//  Created by Grace on 4/9/2025.
//

import Foundation

struct WaterIntake: Identifiable, Codable {
    let id = UUID()
    let amount: Double // in ml
    let date: Date
}
