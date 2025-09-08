//
//  CustomInputView.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 8/9/2025.
//

import SwiftUI

struct CustomInputView: View {
    @Binding var isAdding: Bool
    @Binding var customAmount: String
    @Binding var showCustomInput: Bool
    @EnvironmentObject var waterVM: WaterViewModel
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 25) {
            Text(isAdding ? "Add Custom Amount" : "Remove Custom Amount")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 25)
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .transition(.opacity)
            }
            
            TextField(isAdding ? "Enter amount in ml" : "Enter amount to remove", text: $customAmount)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .frame(width: 250)
                .font(.body)
                .onChange(of: customAmount) {
                    validateInput()
                }
            
            VStack(spacing: 15) {
                Button(isAdding ? "Add" : "Remove") {
                    if validateInput() {
                        if let amount = Double(customAmount), amount > 0 {
                            if isAdding {
                                waterVM.addWater(amount: amount)
                            } else {
                                waterVM.removeWater(amount: amount)
                            }
                        }
                        showCustomInput = false
                        customAmount = ""
                        showError = false
                    }
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isAdding ? Color.blue : Color.red)
                .foregroundColor(.white)
                .cornerRadius(15)
                .disabled(customAmount.isEmpty || showError)
                
                Button("Cancel") {
                    showCustomInput = false
                    customAmount = ""
                    showError = false
                }
                .font(.body)
                .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
        .padding(30)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .onAppear {
            customAmount = ""
            showError = false
        }
        .animation(.easeInOut(duration: 0.2), value: showError)
    }
    
    private func validateInput() -> Bool {
        let filtered = customAmount.filter { "0123456789.".contains($0) }
        if filtered != customAmount {
            showError = true
            errorMessage = "Please enter numbers only"
            customAmount = filtered
            return false
        }

        guard !customAmount.isEmpty else {
            return false
        }

        guard let amount = Double(customAmount), amount > 0 else {
            showError = true
            errorMessage = "Please enter a valid positive number"
            return false
        }

        if isAdding && amount <= 0 {
            showError = true
            errorMessage = "Please enter a positive amount to add"
            return false
        }
        
        return true
    }
}
