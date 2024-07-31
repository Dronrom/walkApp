//
//  Purchase.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-07-10.
//

import Foundation
import FirebaseFirestoreSwift

struct Purchase: Identifiable, Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var sessionID: String
    var sessionName: String
    var quantity: Int
    var totalAmount: Double
    var purchaseDate: Date
    var date: Date
    var time: String
    
    init( sessionID: String, sessionName: String, quantity: Int, totalAmount: Double, purchaseDate: Date, time: String, date: Date) {
        self.sessionID = sessionID
        self.sessionName = sessionName
        self.quantity = quantity
        self.totalAmount = totalAmount
        self.purchaseDate = purchaseDate
        self.time = time
        self.date = date
    }
    
}
