//
//  EditQuickButtonsView.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 7/9/2025.
//

import SwiftUI

struct EditQuickButtonsView: View {
    @Binding var quickAddAmounts: [Double]
    @Binding var quickRemoveAmounts: [Double]
    @Binding var isShowing: Bool
    @State private var newAddAmounts: [String] = ["", "", ""]
    @State private var newRemoveAmounts: [String] = [""]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Buttons")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 10)
            
            // Add Buttons Section
            VStack(alignment: .leading, spacing: 15) {
                Text("Add Buttons")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                ForEach(0..<3, id: \.self) { index in
                    HStack {
                        Text("Add \(index + 1):")
                            .frame(width: 80, alignment: .leading)
                            .font(.body)
                        
                        TextField("ml", text: $newAddAmounts[index])
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .frame(width: 100)
                            .font(.body)
                    }
                }
            }
            .padding(.horizontal)
            
            // Remove Buttons Section
            VStack(alignment: .leading, spacing: 15) {
                Text("Remove Buttons")
                    .font(.headline)
                    .foregroundColor(.red)
                
                ForEach(0..<1, id: \.self) { index in
                    HStack {
                        Text("Remove \(index + 1):")
                            .frame(width: 80, alignment: .leading)
                            .font(.body)
                        
                        TextField("ml", text: $newRemoveAmounts[index])
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .frame(width: 100)
                            .font(.body)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Save/Cancel Buttons - Always visible at the bottom
            HStack(spacing: 20) {
                Button("Cancel") {
                    isShowing = false
                }
                .font(.headline)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(12)
                
                Button("Save") {
                    saveNewAmounts()
                    isShowing = false
                }
                .font(.headline)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
        .padding()
        .presentationDetents([.height(400)]) // Fixed height to ensure buttons are visible
        .presentationDragIndicator(.visible)
        .onAppear {
            // Initialize text fields with current values
            for i in 0..<min(3, quickAddAmounts.count) {
                newAddAmounts[i] = "\(Int(quickAddAmounts[i]))"
            }
            for i in 0..<min(1, quickRemoveAmounts.count) {
                newRemoveAmounts[i] = "\(Int(quickRemoveAmounts[i]))"
            }
        }
    }
    
    func saveNewAmounts() {
        var updatedAddAmounts: [Double] = []
        var updatedRemoveAmounts: [Double] = []
        
        // Process add amounts
        for amountText in newAddAmounts {
            if let amount = Double(amountText), amount > 0 {
                updatedAddAmounts.append(amount)
            } else {
                // If invalid, use default values
                updatedAddAmounts.append([250, 350, 500][updatedAddAmounts.count])
            }
        }
        
        // Process remove amounts
        for amountText in newRemoveAmounts {
            if let amount = Double(amountText), amount > 0 {
                updatedRemoveAmounts.append(amount)
            } else {
                // If invalid, use default value
                updatedRemoveAmounts.append(250)
            }
        }
        
        quickAddAmounts = updatedAddAmounts
        quickRemoveAmounts = updatedRemoveAmounts
        
        UserDefaults.standard.set(updatedAddAmounts, forKey: "quickAddAmounts")
        UserDefaults.standard.set(updatedRemoveAmounts, forKey: "quickRemoveAmounts")
    }
}
