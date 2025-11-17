//
//  TodoListViewViewModel.swift
//  TodoListApp
//
//  Created by Mitchell MacDonald on 2025-10-17.
//

import Foundation
import Foundation
import Combine
class HomeViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errMsg = ""
    @Published var showingNewItemView = false
    init() {
    }
    
    
}
