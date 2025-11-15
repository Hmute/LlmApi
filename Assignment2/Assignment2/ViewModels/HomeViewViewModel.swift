//
//  TodoListViewViewModel.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import Foundation
import FirebaseFirestore
import Foundation
import Combine
import FirebaseAuth
class HomeViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errMsg = ""
    @Published var showingNewItemView = false
    private let _userId: String
    init(userId: String) {
        _userId = userId
    }
    
    
}
