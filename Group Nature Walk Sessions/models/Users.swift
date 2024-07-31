//
//  User.swift
//  Group Nature Walk Sessions
//
//  Created by Jorge Galarraga  on 2024-06-12.
//

import Foundation

class Users: Identifiable{
    var id = UUID()
    var email: String
    var password: String
    
    init(id: UUID = UUID(), email: String, password: String) {
        self.email = email
        self.password = password
    }
}
