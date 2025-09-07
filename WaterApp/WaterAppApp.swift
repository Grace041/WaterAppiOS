//
//  WaterAppApp.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 22/8/2025.
//

import SwiftUI

@main
struct WaterAppApp: App {
    
    @StateObject private var appVM = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationTab()
                .environmentObject(appVM)
        }
    }
}
