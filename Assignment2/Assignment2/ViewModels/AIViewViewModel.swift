//
//  AIViewViewModel.swift
//  Assignment2
//
//  Created by Mitchell MacDonald on 2025-11-14.
//

import Foundation
import FirebaseFirestore
import Foundation
import Combine
import FirebaseAuth
class AIViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errMsg = ""
    @Published var showingNewItemView = false
    private let _userId: String
    init(userId: String) {
        _userId = userId
    }
    
    
}
