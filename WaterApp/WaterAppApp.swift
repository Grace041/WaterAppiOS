//
//  WaterAppApp.swift
//  WaterApp
//
//  Created by Grace on 22/8/2025.
//

import SwiftUI

@main
struct WaterAppApp: App {
    
    @StateObject private var appVM = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appVM)
        }
    }
}
