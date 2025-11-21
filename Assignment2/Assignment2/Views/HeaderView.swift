//
//  HeaderView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI

struct HeaderView: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    var backgroundGradient: LinearGradient? = nil  // ← optional override

    var body: some View {
        ZStack {
            // Use custom gradient if provided, otherwise default purple-blue
            (backgroundGradient ?? LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .ignoresSafeArea()

            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                Text(subtitle)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            .padding(.top, 20)
        }
        .frame(height: 200) // slightly smaller
    }
}

#Preview {
    HeaderView(title: "Todo List", subtitle: "Welcome!")
}
