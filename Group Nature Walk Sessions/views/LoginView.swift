//
//  LoginView.swift
//  Walk_Project_Group_3
//
//  Created by Jorge Galarraga  on 2024-06-09.
//

///
//  LoginView.swift
//  Walk_Project_Group_3
//
//  Created by Jorge Galarraga  on 2024-06-09.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var showingAlert = false
    
    var onLoginSuccess: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Email")
            
            TextField("Enter email address", text: $loginViewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.bottom, 20)
            
            Text("Password")
            
            SecureField("Enter password", text: $loginViewModel.password)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.bottom, 20)
            
            Toggle("Remember Me", isOn: $loginViewModel.rememberMe)
                .padding(.bottom, 20)
            
            Button {
                loginViewModel.login { success in
                    if success {
                        onLoginSuccess(loginViewModel.email)
                        print(#function, "Login button clicked")
                    } else {
                        showingAlert = true
                    }
                }
            } label: {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(loginViewModel.errorMessage ?? "Login Successful"), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }
        .padding()
        .onAppear {
            if loginViewModel.rememberMe {
                loginViewModel.email = UserDefaults.standard.string(forKey: "savedEmail") ?? ""
                loginViewModel.password = UserDefaults.standard.string(forKey: "savedPassword") ?? ""
            }
        }
    }
}

#Preview {
    LoginView(onLoginSuccess: { _ in })
}
