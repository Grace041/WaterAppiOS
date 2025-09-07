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
    
//    init() {
//        loadAllData()
//    }
//    
//    func loadAllData() {
//        waterVM.loadData()
//        settingsVM.loadData()
//    }
//    
//    func saveAllData() {
//        waterVM.saveData()
//        settingsVM.saveData()
//    }
//    
//    func resetAllData() {
//        waterVM = WaterViewModel()
//        settingsVM = SettingsViewModel()
//        saveAllData()
//    }
}
