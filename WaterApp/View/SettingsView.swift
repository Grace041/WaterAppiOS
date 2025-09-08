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
                            .font(.system(size: 70))
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
                    .padding(.vertical, 6)
                    
                    Section(header: Text("Preferences")) {
                        Toggle(isOn: $settingsVM.profile.notificationsEnabled) {
                            HStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.yellow)
                                    .frame(width: 20)
                                Text("Enable Notifications")
                            }
                        }
                        .onChange(of: settingsVM.profile.notificationsEnabled) {
                            waterVM.updateNotificationSettings(
                                enabled: settingsVM.profile.notificationsEnabled,
                                frequency: settingsVM.profile.notificationFrequency
                            )
                            settingsVM.saveProfile()
                        }
                        
                        if settingsVM.profile.notificationsEnabled {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.black)
                                    .frame(width: 20)
                                Text("Notification Frequency")
                                Spacer()
                                Picker("", selection: $settingsVM.profile.notificationFrequency) {
                                    ForEach(frequencyOptions, id: \.self) { freq in
                                        Text("\(freq) hour")
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            .onChange(of: settingsVM.profile.notificationFrequency) {
                                waterVM.updateNotificationSettings(
                                    enabled: settingsVM.profile.notificationsEnabled,
                                    frequency: settingsVM.profile.notificationFrequency
                                )
                                settingsVM.saveProfile()
                            }
                        }
                        
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                                .frame(width: 20)
                            Stepper(value: $settingsVM.profile.dailyGoal, in: 100...20000, step: 100) {
                                Text("Daily Goal: \(Int(settingsVM.profile.dailyGoal)) ml")
                            }
                        }
                        .onChange(of: settingsVM.profile.dailyGoal) {
                            settingsVM.saveProfile()
                            settingsVM.syncWithWaterViewModel(waterVM)
                        }
                    }
                    
                    Section(header: Text("Account")) {
                        Button(action: {
                            // Log out
                        }) {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                        }
                    }
                }
                .navigationTitle("Settings")
            }
            .onAppear {
                settingsVM.profile.dailyGoal = waterVM.dailyGoal
                settingsVM.profile.notificationsEnabled = waterVM.notificationsEnabled
                settingsVM.profile.notificationFrequency = waterVM.notificationFrequency
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
