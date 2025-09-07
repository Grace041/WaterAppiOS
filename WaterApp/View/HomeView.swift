//
//  HomeView.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 22/8/2025.
//

import SwiftUI

struct HomeView: View {
    
//    @EnvironmentObject var appVM : AppViewModel
    @State private var showCustomInput = false
    @State private var customAmount: String = ""
    @State private var isAdding: Bool = true
    
    @EnvironmentObject private var waterVM: WaterViewModel
    //@StateObject private var settingsVM = SettingsViewModel()
    
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
                        .trim(from: 0.0, to: min(waterVM.progress, 1.0))
                        .stroke(
                            AngularGradient(gradient: Gradient(colors: [.blue, .cyan]),
                                            center: .center),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut, value: waterVM.progress)
                    
                    VStack {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        Text("\(Int(waterVM.currentIntake)) ml / \(Int(waterVM.dailyGoal)) ml")
                            .font(.headline)
                    }
                }
                .frame(width: 220, height: 220)
                
                if waterVM.notificationsEnabled {
                    Text("Next gentle reminder is within \(waterVM.notificationFrequency) hours")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                
                // Quick Add + Remove
                VStack(spacing: 15) {
                    HStack(spacing: 20) {
                        QuickAddButton(amount: 250, action: { waterVM.addWater(amount: 250) })
                        QuickAddButton(amount: 350, action: { waterVM.addWater(amount: 350) })
                        QuickAddButton(amount: 500, action: { waterVM.addWater(amount: 500) })
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
                            waterVM.removeWater(amount: 250)
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
//                    VStack {
//                        Image(systemName: "house.fill")
//                            .foregroundColor(.blue)
//                        Text("Home")
//                            .font(.caption)
//                    }
//                    Spacer()
//                    
//                    NavigationLink(destination: SettingsView()) {
//                        VStack {
//                            Image(systemName: "gearshape.fill")
//                                .foregroundColor(.gray)
//                            Text("Settings")
//                                .font(.caption)
//                        }
//                    }
//                    Spacer()
//                }
//                .padding()
//                .background(Color(UIColor.systemGray6))
//                .cornerRadius(20)
            }
            
            .padding()
            .sheet(isPresented: $showCustomInput) {
                CustomInputView(
                    isAdding: $isAdding,
                    customAmount: $customAmount,
                    showCustomInput: $showCustomInput,
                    waterVM: waterVM
                )
            }
//            }
            .navigationBarHidden(true)
//            .onAppear{
//                settingsVM.loadProfile()
//            }
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
    @Binding var isAdding: Bool
    @Binding var customAmount: String
    @Binding var showCustomInput: Bool
    @ObservedObject var waterVM: WaterViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isAdding ? "Add Custom Amount" : "Remove Custom Amount")
                .font(.headline)
                .padding(.top)
            
            TextField("ml", text: $customAmount)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(width: 200)
            
            Button(isAdding ? "Add" : "Remove") {
                if let amount = Double(customAmount), amount > 0 {
                    if isAdding {
                        waterVM.addWater(amount: amount)
                    } else {
                        waterVM.removeWater(amount: amount)
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
            .disabled(customAmount.isEmpty || Double(customAmount) == nil)
            
            Button("Cancel") {
                showCustomInput = false
                customAmount = ""
            }
            .foregroundColor(.gray)
        }
        .padding()
        .presentationDetents([.height(250)])
        .presentationDragIndicator(.visible)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(WaterViewModel())
    }
}
