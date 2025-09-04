//
//  SettingsView.swift
//  WaterApp
//
//  Created by Grace on 22/8/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsVM = SettingsViewModel()
    
    let themes = ["Light", "Dark", "System"]
    let frequencyOptions = [5, 10, 15, 30, 60]
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Profile")) {
                        TextField("Name", text: $settingsVM.profile.name)
                        TextField("Age", value: $settingsVM.profile.age, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }

                    Section(header: Text("Preferences")) {
                        Toggle(isOn: $settingsVM.profile.notificationsEnabled) {
                            Label("Enable Notifications", systemImage: "bell")
                        }
                        
                        Picker("Notification Frequency", selection: $settingsVM.profile.notificationFrequency) {
                            ForEach(frequencyOptions, id: \.self) { freq in
                                Text("\(freq) min")
                            }
                        }
                        
                        Stepper(value: $settingsVM.profile.dailyGoal, in: 100...20000, step: 100) {
                            Label("Daily Water Goal: \(Int(settingsVM.profile.dailyGoal)) ml", systemImage: "drop.fill")
                        }
                        
                        Picker(selection: $settingsVM.profile.theme, label: Label("Theme", systemImage: "paintpalette")) {
                            ForEach(themes, id: \.self) { theme in
                                Text(theme)
                            }
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
            }

            // Bottom Navigation
            HStack {
                Spacer()
                NavigationLink(destination: HomeView()) {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
