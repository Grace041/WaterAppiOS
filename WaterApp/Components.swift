//
//  Components.swift
//  WaterApp
//
//  Created by Chi Sum Lau on 7/9/2025.
//

import SwiftUI

struct NavigationButton<Destination: View>: View {
    let title: String
    let icon: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(systemName: icon)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.primary)
        }
    }
}
