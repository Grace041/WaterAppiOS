//
//  AppViewModel.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 5/9/2025.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var waterVM = WaterViewModel()
    @Published var settingsVM = SettingsViewModel()
}
