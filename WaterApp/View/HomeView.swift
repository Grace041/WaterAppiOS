//
//  HomeView.swift
//  WaterApp
//
//  Created by Grace on 22/8/2025.
//

import SwiftUI

struct HomeView: View {
//    @StateObject private var waterVM = WaterViewModel() // connect ViewModel
//    @StateObject private var settingsVM = SettingsViewModel()
    
    @EnvironmentObject var appVM : AppViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Header
            VStack {
                Text("Water")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(Date.now, style: .date)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Progress Circle
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.2)
                    .foregroundColor(Color.blue)
                
                Circle()
                    .trim(from: 0.0, to: min(appVM.waterVM.progress, 1.0))
                    .stroke(
                        AngularGradient(gradient: Gradient(colors: [.blue, .cyan]),
                                        center: .center),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: appVM.waterVM.progress)
                
                VStack {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    Text("\(Int(appVM.waterVM.currentIntake)) ml / \(Int(appVM.waterVM.dailyGoal)) ml")
                        .font(.headline)
                }
            }
            .frame(width: 220, height: 220)
            
            Text("Next gentle reminder in \(appVM.settingsVM.profile.notificationFrequency) hour")
                .foregroundColor(.gray)
                .font(.subheadline)
            
            // Quick Add + Remove
            HStack(spacing: 20) {
                QuickAddButton(amount: 250, action: { appVM.waterVM.addWater(amount: 250) })
                QuickAddButton(amount: 350, action: { appVM.waterVM.addWater(amount: 350) })
                QuickAddButton(amount: 500, action: { appVM.waterVM.addWater(amount: 500) })
                Button(action: {
                    // TODO: Custom input sheet
                }) {
                    Text("+ Custom")
                        .font(.subheadline)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            
            HStack {
                Button(action: {
                    appVM.waterVM.removeWater(amount: 250)
                }) {
                    Text("Remove 250ml")
                        .font(.subheadline)
                        .padding()
                        .frame(width: 150)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(10)
                }
                Button(action: {
                    // TODO: Custom input sheet
                }) {
                    Text("- Custom")
                        .font(.subheadline)
                        .padding()
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            
            Spacer()
            
            // Bottom Navigation
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
//                Spacer()
//                VStack {
//                    Image(systemName: "chart.bar.fill")
//                    Text("Insights")
//                }
                Spacer()
                NavigationLink(destination: SettingsView()) {
                    VStack {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
        }
        .padding()
    }
}

struct QuickAddButton: View {
    let amount: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(Int(amount))ml")
                .font(.subheadline)
                .padding()
                .frame(width: 70)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppViewModel())
    }
}
