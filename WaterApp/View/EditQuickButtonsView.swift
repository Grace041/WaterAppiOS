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
    @State private var fieldErrors: [Int: String] = [:]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Quick Buttons")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 10)
  
            VStack(alignment: .leading, spacing: 15) {
                Text("Add Buttons")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                ForEach(0..<3, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        if let error = fieldErrors[index] {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption2)
                                .transition(.opacity)
                        }
                        
                        HStack {
                            Text("Add \(index + 1):")
                                .frame(width: 80, alignment: .leading)
                                .font(.body)
                            
                            TextField("ml", text: $newAddAmounts[index])
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .frame(width: 100)
                                .font(.body)
                                .onChange(of: newAddAmounts[index]) {
                                    validateAddInput(index: index)
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Remove Buttons")
                    .font(.headline)
                    .foregroundColor(.red)
                
                ForEach(0..<1, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        if let error = fieldErrors[10 + index] {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption2)
                                .transition(.opacity)
                        }
                        
                        HStack {
                            Text("Remove \(index + 1):")
                                .frame(width: 80, alignment: .leading)
                                .font(.body)
                            
                            TextField("ml", text: $newRemoveAmounts[index])
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .frame(width: 100)
                                .font(.body)
                                .onChange(of: newRemoveAmounts[index]) {
                                    validateRemoveInput(index: index)
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button("Cancel") {
                    isShowing = false
                    fieldErrors.removeAll()
                }
                .font(.headline)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(12)
                
                Button("Save") {
                    if validateAllInputs() {
                        saveNewAmounts()
                        isShowing = false
                        fieldErrors.removeAll()
                    }
                }
                .font(.headline)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(!fieldErrors.isEmpty)
            }
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
        .padding()
        .presentationDetents([.height(450)])
        .presentationDragIndicator(.visible)
        .onAppear {
            for i in 0..<min(3, quickAddAmounts.count) {
                newAddAmounts[i] = "\(Int(quickAddAmounts[i]))"
            }
            for i in 0..<min(1, quickRemoveAmounts.count) {
                newRemoveAmounts[i] = "\(Int(quickRemoveAmounts[i]))"
            }
            fieldErrors.removeAll()
        }
        .animation(.easeInOut(duration: 0.2), value: fieldErrors)
    }
    
    private func validateAddInput(index: Int) {
        let filtered = newAddAmounts[index].filter { "0123456789".contains($0) }
        if filtered != newAddAmounts[index] {
            fieldErrors[index] = "Numbers only"
            newAddAmounts[index] = filtered
        }
    }
    
    private func validateRemoveInput(index: Int) {
        let fieldIndex = 10 + index
        let filtered = newRemoveAmounts[index].filter { "0123456789".contains($0) }
        if filtered != newRemoveAmounts[index] {
            fieldErrors[fieldIndex] = "Numbers only"
            newRemoveAmounts[index] = filtered
        }
    }
    
    private func validateAllInputs() -> Bool {
        var isValid = true
        
        for (index, amountText) in newAddAmounts.enumerated() {
            if !amountText.isEmpty {
                if let amount = Double(amountText), amount > 0 {
                    
                } else {
                    fieldErrors[index] = "Must be a positive number"
                    isValid = false
                }
            }
        }
        
        for (index, amountText) in newRemoveAmounts.enumerated() {
            let fieldIndex = 10 + index
            if !amountText.isEmpty {
                if let amount = Double(amountText), amount > 0 {
                    
                } else {
                    fieldErrors[fieldIndex] = "Must be a positive number"
                    isValid = false
                }
            }
        }
        
        return isValid
    }
    
    private func saveNewAmounts() {
        var updatedAddAmounts: [Double] = []
        var updatedRemoveAmounts: [Double] = []
        
        for amountText in newAddAmounts {
            if let amount = Double(amountText), amount > 0 {
                updatedAddAmounts.append(amount)
            } else {
                updatedAddAmounts.append([250, 350, 500][updatedAddAmounts.count])
            }
        }
        
        for amountText in newRemoveAmounts {
            if let amount = Double(amountText), amount > 0 {
                updatedRemoveAmounts.append(amount)
            } else {
                updatedRemoveAmounts.append(250)
            }
        }
        
        quickAddAmounts = updatedAddAmounts
        quickRemoveAmounts = updatedRemoveAmounts
        
        UserDefaults.standard.set(updatedAddAmounts, forKey: "quickAddAmounts")
        UserDefaults.standard.set(updatedRemoveAmounts, forKey: "quickRemoveAmounts")
    }
}
