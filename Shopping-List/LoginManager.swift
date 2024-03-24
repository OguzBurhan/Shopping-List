//
//  LoginManager.swift
//  Shopping-List
//
//  Created by Oguz Burhan on 2024-03-23.
//

import Foundation
import Combine
import SwiftUI

class LoginManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func login(email: String, password: String) {
        // login logic

        self.isLoggedIn = true
    }

    func logout() {
        self.isLoggedIn = false
    }
}

