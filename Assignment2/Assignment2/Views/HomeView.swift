//
//  TodoListView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI
import FirebaseFirestore
struct HomeView: View {
    @StateObject var viewModel: HomeViewViewModel
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: HomeViewViewModel(userId: userId)
        )
    }
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Spacer()
             Text("Welcome to our AI App")
                .font(.title2)
                .multilineTextAlignment(.center)

            Spacer()
        }
    }

   
    #Preview {
        HomeView(userId: "3MXygibdHEPn5I0QSBsyzltbL1Q2")
    }
}
