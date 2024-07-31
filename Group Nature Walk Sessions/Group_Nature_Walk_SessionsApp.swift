//
//  Group_Nature_Walk_SessionsApp.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-06-09.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@main
struct Group_Nature_Walk_SessionsApp: App {

    init() {
        //initialize firebase services
        FirebaseApp.configure()
    }
    
      var body: some Scene {
        WindowGroup {
            //LoginView()
          ContentView()
        }
      }
}
