//
//  ProfileView.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    var body: some View {
//        NavigationView {
//            VStack {
////                if let user = viewModel.user
//                {
//                    profile(user: user)
//                } else {
//                    Text("Loading Profile ...")
//                }
//            }
//            .navigationTitle("Profile")
//        }
////        .onAppear() {
////            viewModel.fetchUser()
//        }
    }
//    @ViewBuilder
//    func profile(user: User) -> some View {
//        // Avatar
//        Image(systemName: "person.circle")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .foregroundColor(Color.blue)
//            .frame(width: 125, height: 125)
//            .padding()
//        // Info: name, email, member since
//        VStack(alignment: .leading) {
//            HStack {
//                Text("Name: ").bold()
//                Text("\(user.firstName) \(user.lastName)")
//            }
//            .padding()
//            HStack {
//                Text("Email: ").bold()
//                Text(user.email)
//            }
//            .padding()
//            HStack {
//                Text("Member since: ").bold()
//                Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
//            }
//            .padding()
//        }
//        .padding()
//        // Log out
//        Button("Logout") {
//            viewModel.logout()
//        }
//        .tint(.red)
//        .padding()
//        Spacer()
//    }
}

#Preview {
    ProfileView()
}
