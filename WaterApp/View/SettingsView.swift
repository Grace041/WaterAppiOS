//
//  SettingsView.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 22/8/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsVM = SettingsViewModel()
    @EnvironmentObject private var waterVM: WaterViewModel
    
    let frequencyOptions = [1, 2, 3, 4, 5]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                                            
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Grace")
                                .font(.title2)
                                .fontWeight(.semibold)
                                                
                            Text("ID: 12345678")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    .padding(.leading, 8)
                                            
                    Spacer()
                    }
                                        .padding(.vertical, 12)
                    Section(header: Text("Preferences")) {
                        Toggle(isOn: $settingsVM.profile.notificationsEnabled) {
                            Label("Enable Notifications", systemImage: "bell")
                        }
                        .onChange(of: settingsVM.profile.notificationsEnabled) { _ in
                            settingsVM.saveProfile()
                        }
                        
                        if settingsVM.profile.notificationsEnabled {
                            Picker("Notification Frequency", selection: $settingsVM.profile.notificationFrequency) {
                                ForEach(frequencyOptions, id: \.self) { freq in
                                    Text("\(freq) hours")
                                }
                            }
                            .onChange(of: settingsVM.profile.notificationFrequency) { _ in
                                settingsVM.saveProfile()
                            }
                        }
                        
                        Stepper(value: $settingsVM.profile.dailyGoal, in: 100...20000, step: 100) {
                            Label("Daily Water Goal: \(Int(settingsVM.profile.dailyGoal)) ml", systemImage: "drop.fill")
                        }
                        .onChange(of: settingsVM.profile.dailyGoal) { newValue in
                            settingsVM.saveProfile()
                            settingsVM.syncWithWaterViewModel(waterVM)
                        }
                    }
                    
                    Section(header: Text("Account")) {
                        Button(action: {
                            // TODO: Log out
                        }) {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                        }
                    }
                }
                .navigationTitle("Settings")
                
                HStack {
                    Spacer()
                    NavigationLink(destination: HomeView()) {
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.blue)
                            Text("Home")
                                .font(.caption)
                        }
                    }
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.gray)
                            Text("Settings")
                                .font(.caption)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(20)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(WaterViewModel())
    }
}
