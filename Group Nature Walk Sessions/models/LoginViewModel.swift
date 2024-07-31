//
//  LoginViewModel.swift
//  Walk_Project_Group_3
//
//  Created by Jorge Galarraga  on 2024-06-09.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    
    private var fireAuthHelper = FireAuthHelper.getInstance()
    
    init() {
        if let savedEmail = UserDefaults.standard.string(forKey: "savedEmail"),
           let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") {
            self.email = savedEmail
            self.password = savedPassword
            self.rememberMe = true
        }
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        fireAuthHelper.signIn(email: email, password: password) { [weak self] success, error in
            guard let self = self else { return }
            if success {
                if self.rememberMe {
                    UserDefaults.standard.set(self.email, forKey: "savedEmail")
                    UserDefaults.standard.set(self.password, forKey: "savedPassword")
                } else {
                    UserDefaults.standard.removeObject(forKey: "savedEmail")
                    UserDefaults.standard.removeObject(forKey: "savedPassword")
                }
                
                self.isLoggedIn = true
                completion(true)
            } else {
                self.errorMessage = error
                self.isLoggedIn = false
                completion(false)
            }
        }
    }
    
    func logout() {
        fireAuthHelper.signOut()
        if rememberMe {
            UserDefaults.standard.set(self.email, forKey: "savedEmail")
            UserDefaults.standard.set(self.password, forKey: "savedPassword")
        } else {
            email = ""
            password = ""
            UserDefaults.standard.removeObject(forKey: "savedEmail")
            UserDefaults.standard.removeObject(forKey: "savedPassword")
        }
        isLoggedIn = false
    }
}
