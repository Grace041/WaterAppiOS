//
//  HomeView.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 22/8/2025.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appVM : AppViewModel
    @State private var showCustomInput = false
    @State private var customAmount: String = ""
    @State private var isAdding: Bool = true
    
    var progress: Double {
        appVM.waterVM.progress
    }
    
    var body: some View {
        NavigationView {
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
                        .trim(from: 0.0, to: min(progress, 1.0))
                        .stroke(
                            AngularGradient(gradient: Gradient(colors: [.blue, .cyan]),
                                            center: .center),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut, value:progress)
                    
                    VStack {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        Text(String(format: "%.0fml / %.0fml", appVM.waterVM.currentIntake, appVM.waterVM.dailyGoal))
                            .font(.headline)
                    }
                }
                .frame(width: 220, height: 220)
                
                if appVM.settingsVM.profile.notificationsEnabled {
                    Text("Next gentle reminder in \(appVM.settingsVM.profile.notificationFrequency / 60) hours")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                
                // Quick Add + Remove
                VStack(spacing: 15) {
                    HStack(spacing: 20) {
                        QuickAddButton(amount: 250, action: { appVM.waterVM.addWater(amount: 250) })
                        QuickAddButton(amount: 350, action: { appVM.waterVM.addWater(amount: 350) })
                        QuickAddButton(amount: 500, action: { appVM.waterVM.addWater(amount: 500) })
                        Button(action: {
                            isAdding = true
                            showCustomInput = true
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
                            isAdding = false
                            showCustomInput = true
                        }) {
                            Text("- Custom")
                                .font(.subheadline)
                                .padding()
                                .background(Color.red.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                
                Spacer()
                
//                HStack {
//                    Spacer()
//                    NavigationButton(title: "Home", icon: "house.fill", destination: HomeView().environmentObject(appVM))
//                    Spacer()
//                    NavigationButton(title: "Settings", icon: "gearshape.fill", destination: SettingsView().environmentObject(appVM))
//                    Spacer()
//                }
//                .padding()
//                .background(Color(UIColor.systemGray6))
//                .cornerRadius(20)
            }
            
            .padding()
            .sheet(isPresented: $showCustomInput) {
                CustomInputView(isAdding: $isAdding, customAmount: $customAmount, showCustomInput: $showCustomInput)
                    .environmentObject(appVM)
            }
            .navigationBarHidden(true)
        }
        .navigationBarBackButtonHidden()
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

struct CustomInputView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Binding var isAdding: Bool
    @Binding var customAmount: String
    @Binding var showCustomInput: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isAdding ? "Add Custom Amount" : "Remove Custom Amount")
                .font(.headline)
                    
            TextField("ml", text: $customAmount)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(width: 150)
                    
            Button(isAdding ? "Add" : "Remove") {
                if let amount = Double(customAmount), amount > 0 {
                    if isAdding {
                        appVM.waterVM.addWater(amount: amount)
                    } else {
                        appVM.waterVM.removeWater(amount: amount)
                    }
                }
                showCustomInput = false
                customAmount = ""
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isAdding ? Color.blue : Color.red)
            .foregroundColor(.white)
            .cornerRadius(12)
                    
            Button("Cancel") {
                showCustomInput = false
                customAmount = ""
            }
            .foregroundColor(.gray)
        }
        .padding()
        .presentationDetents([.height(250)])
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppViewModel())
    }
}
