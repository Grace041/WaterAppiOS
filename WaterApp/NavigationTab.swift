//
//  NavigationTab.swift
//  WaterApp
//
//  Created by Grace on 7/9/2025.
//

import SwiftUI

enum Tab {
    case home, settings
}

struct NavigationTab: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
//            InsightsView()
//                .tabItem {
//                    Label("Insights", systemImage: "chart.bar.fill")
//                }
//                .tag(Tab.insights)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
    }
}
