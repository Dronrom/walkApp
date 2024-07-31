//
//  Walk.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-06-09.
//

import Foundation
import FirebaseFirestoreSwift

struct Walk: Hashable, Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String
    var starRating: Int
    var guideName: String
    var photos: [String]
    var pricePerPerson: Double
    var phoneNumber: String
    var date: Date
    var time: String
    var address: String
    
    init(name: String, description: String, starRating: Int, guideName: String, photos: [String], pricePerPerson: Double, phoneNumber: String, date: Date, time: String, address: String) {
        self.name = name
        self.description = description
        self.starRating = starRating
        self.guideName = guideName
        self.photos = photos
        self.pricePerPerson = pricePerPerson
        self.phoneNumber = phoneNumber
        self.date = date
        self.time = time
        self.address = address
    }
}
