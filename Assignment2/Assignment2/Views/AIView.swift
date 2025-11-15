//
//  AIView.swift
//  Assignment2
//

import SwiftUI

struct AIView: View {
    @StateObject var viewModel: AIViewViewModel
    
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: AIViewViewModel(userId: userId)
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Ask AI")
                .font(.largeTitle)
                .bold()
            
            TextField("Type your question here…", text: $viewModel.prompt)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button("Send") {
                viewModel.askAI()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.prompt.isEmpty)
            
            if viewModel.isLoading {
                ProgressView("Thinking…")
                    .padding()
            }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            ScrollView {
                Text(viewModel.response)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AIView(userId: "Ft54PxAAAKM4hYImRQ0FLqk0gIl1")
}
