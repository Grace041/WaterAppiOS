//
//  HomeView.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 22/8/2025.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showCustomInput = false
    @State private var customAmount: String = ""
    @State private var isAdding: Bool = true
    @State private var showEditQuickAdd = false
    @State private var quickAddAmounts: [Double] = [250, 350, 500]
    @State private var quickRemoveAmounts: [Double] = [250]
    
    @EnvironmentObject private var waterVM: WaterViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                VStack {
                    Text("Water")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(Date.now, style: .date)
                        .foregroundColor(.gray)
                }
                Spacer()
                
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
                } else {
                    Text("Notifications disabled")
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.subheadline)
                        .italic()
                }
                
                VStack(spacing: 15) {
                    HStack(spacing: 20) {
                        ForEach(quickAddAmounts, id: \.self) { amount in
                            QuickAddButton(amount: amount, action: { waterVM.addWater(amount: amount) })
                        }
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
                        ForEach(quickRemoveAmounts, id: \.self) { amount in
                            QuickRemoveButton(amount: amount, action: { waterVM.removeWater(amount: amount) })
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
                    Button(action: {
                        showEditQuickAdd = true
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 14))
                            Text("Edit Buttons")
                                .font(.subheadline)
                        }
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding(.top, 10)
                }
                Spacer()
            }
            
            .padding()
            .sheet(isPresented: $showCustomInput) {
                CustomInputView(
                    isAdding: $isAdding,
                    customAmount: $customAmount,
                    showCustomInput: $showCustomInput
                )
                .environmentObject(waterVM)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showEditQuickAdd) {
                EditQuickButtonsView(
                    quickAddAmounts: $quickAddAmounts,
                    quickRemoveAmounts: $quickRemoveAmounts,
                    isShowing: $showEditQuickAdd
                )
                .presentationDetents([.height(550)])
                .presentationDragIndicator(.visible)
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
            Text("+\(Int(amount))ml")
                .font(.subheadline)
                .padding()
                .frame(width: 70)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
        }
    }
}

struct QuickRemoveButton: View {
    let amount: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("-\(Int(amount))ml")
                .font(.subheadline)
                .padding()
                .frame(width: 70)
                .background(Color.red.opacity(0.2))
                .cornerRadius(10)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(WaterViewModel())
    }
}
