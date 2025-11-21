//
//  AIView.swift
//  Assignment2
//

import SwiftUI

struct AIView: View {
    @StateObject var viewModel: AIViewViewModel
    @EnvironmentObject var session: SessionManager

    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: AIViewViewModel(userId: userId, session: SessionManager())
        )
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [.indigo, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                Text("Ask AI")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.top, 40)

                // AI input card
                VStack(spacing: 15) {
                    TextField("Type your question here…", text: $viewModel.prompt)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)

                    Button(action: {
                        viewModel.askAI()
                    }) {
                        Text("Send")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: viewModel.prompt.isEmpty ? [.gray, .gray] : [.pink, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .disabled(viewModel.prompt.isEmpty)

                    if viewModel.isLoading {
                        ProgressView("Thinking…")
                            .padding()
                    }

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    ScrollView {
                        Text(viewModel.response)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .frame(maxHeight: 300)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(25)
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

                Spacer()
            }
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    AIView(userId: "123")
        .environmentObject(SessionManager())
}
