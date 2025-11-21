//
//  TodoListView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [.purple, .blue, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            // Floating abstract shapes
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 150, height: 150)
                .blur(radius: 50)
                .offset(x: -100, y: -120)
            
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 100, height: 100)
                .blur(radius: 40)
                .offset(x: 120, y: -60)
            
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white.opacity(0.05))
                .frame(width: 250, height: 150)
                .rotationEffect(.degrees(25))
                .offset(x: 80, y: 100)
            
            VStack(spacing: 30) {
                // Header
                Text("Home")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                
                // Welcome card
                VStack(spacing: 16) {
                    Text("Welcome to our AI App")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 2)
                    
                    Text("Get started by exploring your tasks and AI features.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(.ultraThinMaterial) // frosted card look
                .cornerRadius(25)
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Spacer()
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    HomeView()
}
