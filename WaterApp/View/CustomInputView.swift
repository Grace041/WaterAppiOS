//
//  CustomInputView.swift
//  WaterApp
//
//  Created by Grace on 8/9/2025.
//

import SwiftUI

struct CustomInputView: View {
    @Binding var isAdding: Bool
    @Binding var customAmount: String
    @Binding var showCustomInput: Bool
    @EnvironmentObject var waterVM: WaterViewModel
    
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
