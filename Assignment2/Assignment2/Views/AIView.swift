import SwiftUI

struct AIView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject private var viewModel: AIViewViewModel

    init(userId: String) {
        _viewModel = StateObject(
            wrappedValue: AIViewViewModel(userId: userId, session: nil)
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo, .purple, .pink],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("Ask AI")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.top, 40)

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
                            .shadow(color: .black.opacity(0.2), radius: 8)
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
                .shadow(color: .black.opacity(0.2), radius: 10)

                Spacer()
            }
            .padding(.bottom, 30)
        }
        .onAppear {
            if viewModel.session == nil {
                viewModel.attachSession(session)
            }
        }
    }
}

#Preview {
    AIView(userId: "123")
        .environmentObject(SessionManager())
}
