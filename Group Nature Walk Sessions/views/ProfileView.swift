//
//  ProfileView.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-07-10.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @State private var isEditing: Bool = false
    @State private var name: String = ""
    @State private var contactDetails: String = ""
    @State private var paymentInfo: String = ""

    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                Text("Email: \(fireAuthHelper.user?.email ?? "Unknown")")
                if isEditing {
                    TextField("Name", text: $name)
                    TextField("Contact Details", text: $contactDetails)
                    TextField("Payment Information (optional)", text: $paymentInfo)
                } else {
                    Text("Name: \(name.isEmpty ? "Not set" : name)")
                    Text("Contact Details: \(contactDetails.isEmpty ? "Not set" : contactDetails)")
                    Text("Payment Information: \(paymentInfo.isEmpty ? "Not set" : paymentInfo)")
                }
            }
            
            Section {
                if isEditing {
                    Button("Save") {
                        // Save edited profile information to Firestore or any other storage mechanism
                        saveProfile()
                        isEditing.toggle()
                    }
                } else {
                    Button("Edit") {
                        isEditing.toggle()
                        loadProfile()
                    }
                }
                
                Button("Sign Out") {
                    fireAuthHelper.signOut()
                }
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            // Load initial profile information
            loadProfile()
        }
    }

    private func loadProfile() {
        // Example: Load profile information from Firestore or any other storage mechanism
        // Here, we mock loading from UserDefaults for simplicity
        name = UserDefaults.standard.string(forKey: "KEY_NAME") ?? ""
        contactDetails = UserDefaults.standard.string(forKey: "KEY_CONTACT") ?? ""
        paymentInfo = UserDefaults.standard.string(forKey: "KEY_PAYMENT") ?? ""
    }

    private func saveProfile() {
        // Example: Save profile information to Firestore or any other storage mechanism
        // Here, we mock saving to UserDefaults for simplicity
        UserDefaults.standard.set(name, forKey: "KEY_NAME")
        UserDefaults.standard.set(contactDetails, forKey: "KEY_CONTACT")
        UserDefaults.standard.set(paymentInfo, forKey: "KEY_PAYMENT")
    }
}
