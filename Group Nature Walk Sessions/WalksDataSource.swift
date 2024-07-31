////
////  NatureWalksDataList.swift
////  Group Nature Walk Sessions
////
////  Created by Roman Devda on 2024-06-09.
////
//
//import Foundation
//
//class NatureWalksDataSource: ObservableObject {
//    @Published var walksList: [Walk]
//    @Published var favoriteWalks: [Walk] = []
//
//    private let userDefaults = UserDefaults.standard
//    
//    var currentUser: String = ""
//
//    init() {
//        self.walksList = [
//            Walk(name: NSLocalizedString("Forest Trail", comment: "Name of the forest trail walk"),
//                 description: NSLocalizedString("A peaceful walk through the forest", comment: "Description of the forest trail walk"),
//                 starRating: 4,
//                 guideName: "John Doe",
//                 photos: ["forest1", "forest2"],
//                 pricePerPerson: 20.0,
//                 phoneNumber: "1234567890"),
//            Walk(name: NSLocalizedString("Mountain Hike", comment: "Name of the mountain hike"),
//                 description: NSLocalizedString("An adventurous hike up the mountain", comment: "Description of the mountain hike"),
//                 starRating: 5,
//                 guideName: "Jane Smith",
//                 photos: ["mountain1", "mountain2"],
//                 pricePerPerson: 30.0,
//                 phoneNumber: "9876543210"),
//            Walk(name: NSLocalizedString("Beach Walk", comment: "Name of the beach walk"),
//                 description: NSLocalizedString("A relaxing walk along the beach", comment: "Description of the beach walk"),
//                 starRating: 3,
//                 guideName: "Bob Brown",
//                 photos: ["beach1", "beach2"],
//                 pricePerPerson: 15.0,
//                 phoneNumber: "0123456789"),
//            Walk(name: NSLocalizedString("City Tour", comment: "Name of the city tour"),
//                 description: NSLocalizedString("A guided tour of the city", comment: "Description of the city tour"),
//                 starRating: 4,
//                 guideName: "Alice Green",
//                 photos: ["city1", "city2"],
//                 pricePerPerson: 25.0,
//                 phoneNumber: "5432109876"),
//            Walk(name: NSLocalizedString("Desert Safari", comment: "Name of the desert safari"),
//                 description: NSLocalizedString("An exciting safari in the desert", comment: "Description of the desert safari"),
//                 starRating: 5,
//                 guideName: "Charlie Black",
//                 photos: ["desert1", "desert2"],
//                 pricePerPerson: 35.0,
//                 phoneNumber: "7890123456"),
//            Walk(name: NSLocalizedString("Jungle Trek", comment: "Name of the jungle trek"),
//                 description: NSLocalizedString("A thrilling trek through the jungle", comment: "Description of the jungle trek"),
//                 starRating: 4,
//                 guideName: "David White",
//                 photos: ["jungle1", "jungle2"],
//                 pricePerPerson: 30.0,
//                 phoneNumber: "6543210987"),
//            Walk(name: NSLocalizedString("River Rafting", comment: "Name of the river rafting"),
//                 description: NSLocalizedString("A fun river rafting experience", comment: "Description of the river rafting"),
//                 starRating: 5,
//                 guideName: "Eve Gray",
//                 photos: ["river1", "river2"],
//                 pricePerPerson: 40.0,
//                 phoneNumber: "1987654320"),
//            Walk(name: NSLocalizedString("Snowy Mountains", comment: "Name of the snowy mountains walk"),
//                 description: NSLocalizedString("A chilly walk in the snowy mountains", comment: "Description of the snowy mountains walk"),
//                 starRating: 4,
//                 guideName: "Frank Blue",
//                 photos: ["snow1", "snow2"],
//                 pricePerPerson: 30.0,
//                 phoneNumber: "2345678901"),
//            Walk(name: NSLocalizedString("Rainforest Exploration", comment: "Name of the rainforest exploration"),
//                 description: NSLocalizedString("An exploration of the rainforest", comment: "Description of the rainforest exploration"),
//                 starRating: 5,
//                 guideName: "Grace Yellow",
//                 photos: ["rainforest1", "rainforest2"],
//                 pricePerPerson: 35.0,
//                 phoneNumber: "3210987654"),
//            Walk(name: NSLocalizedString("Cave Adventure", comment: "Name of the cave adventure"),
//                 description: NSLocalizedString("An adventurous exploration of caves", comment: "Description of the cave adventure"),
//                 starRating: 4,
//                 guideName: "Henry Red",
//                 photos: ["cave1", "cave2"],
//                 pricePerPerson: 25.0,
//                 phoneNumber: "8765432109"),
//        ]
//        loadFavorites()
//    }
//    
//    //setting user 
//    func setUser(_ user: String){
//        currentUser = user
//        loadFavorites()
//    }
//    
//    func getUserFavoritesKey() -> String {
//        return "favoriteWalks_\(currentUser)"
//    }
//    
//    func loadFavorites() {
//        guard !currentUser.isEmpty else {
//            favoriteWalks = []
//            return
//        }
//       let favoriteWalkIDs = userDefaults.array(forKey: getUserFavoritesKey()) as? [String] ?? []
//       favoriteWalks = walksList.filter { favoriteWalkIDs.contains($0.id.uuidString) }
//   }
//    
//     func isFavorite(walk: Walk) -> Bool {
//        let favoriteWalkIDs = userDefaults.array(forKey: getUserFavoritesKey()) as? [String] ?? []
//        return favoriteWalkIDs.contains(walk.id.uuidString)
//    }
//    
//   func toggleFavorite(walk: Walk) {
//       guard !currentUser.isEmpty else { return }
//       var favoriteWalkIDs = userDefaults.array(forKey: getUserFavoritesKey()) as? [String] ?? []
//       if let index = favoriteWalkIDs.firstIndex(of: walk.id.uuidString) {
//           favoriteWalkIDs.remove(at: index)
//       } else {
//           favoriteWalkIDs.append(walk.id.uuidString)
//       }
//       userDefaults.set(favoriteWalkIDs, forKey: getUserFavoritesKey())
//       
//       loadFavorites()
//   }
//
//   func deleteAllFavorites() {
//       guard !currentUser.isEmpty else { return }
//       userDefaults.removeObject(forKey: getUserFavoritesKey())
//       loadFavorites()
//   }
//}
//
