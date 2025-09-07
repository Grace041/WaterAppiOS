//
//  SettingsView.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 22/8/2025.
//

import SwiftUI

struct SettingsView: View {
    //@StateObject private var settingsVM = SettingsViewModel()
    @EnvironmentObject var appVM : AppViewModel
    
    let frequencyOptions = [1, 2, 3, 4, 5]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Profile")) {
                        TextField("Name", text: $appVM.settingsVM.profile.name)
                        TextField("Age", value: $appVM.settingsVM.profile.age, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }

                    Section(header: Text("Preferences")) {
                        Toggle(isOn: $appVM.settingsVM.profile.notificationsEnabled) {
                            Label("Enable Notifications", systemImage: "bell")
                        }
                        
                        Picker("Notification Frequency", selection: $appVM.settingsVM.profile.notificationFrequency) {
                            ForEach(frequencyOptions, id: \.self) { freq in
                                Text("\(freq) hour")
                            }
                        }
                        
                        Stepper(value: $appVM.settingsVM.profile.dailyGoal, in: 100...20000, step: 100) {
                            Label("Daily Water Goal: \(Int(appVM.settingsVM.profile.dailyGoal)) ml", systemImage: "drop.fill")
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
                
//                HStack {
//                    Spacer()
//                    NavigationButton(title: "Home", icon: "house.fill", destination: HomeView())
//                    Spacer()
//                    NavigationButton(title: "Settings", icon: "gearshape.fill", destination: SettingsView())
//                    Spacer()
//                }
//                .padding()
//                .background(Color(UIColor.systemGray6))
//                .cornerRadius(20)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppViewModel())
    }
}
