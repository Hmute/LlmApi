//
//  TodoListView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI
import FirebaseFirestore
struct AIView: View {
    @StateObject var viewModel: AIViewViewModel
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: AIViewViewModel(userId: userId)
        )
    }
    var body: some View {
        VStack {
            Text("Ask AI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Spacer()
        }
    }
}
#Preview {
    AIView(userId: "Ft54PxAAAKM4hYImRQ0FLqk0gIl1")
}
