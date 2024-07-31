import Foundation
import FirebaseFirestore

class FireDBHelper: ObservableObject {
    
    @Published var sessionList = [Walk]()
    
    @Published var walkList = [Walk]()
    @Published var purchasesList = [Purchase]()
    @Published var favoritesList = [Walk]()
    private let db: Firestore
    
    private static var shared: FireDBHelper?
    
    private let COLLECTION_NAME: String = "User_Walks"
    private let COLLECTION_FAVORITES: String = "Favorites"
    private let COLLECTION_PURCHASES: String = "Purchases"
    private let COLLECTION_SESSIONS: String = "walks"
    private let FIELD_NAME: String = "name"
    private let FIELD_DESCRIPTION: String = "description"
    private let FIELD_STAR_RATING: String = "starRating"
    private let FIELD_GUIDE_NAME: String = "guideName"
    private let FIELD_PHOTOS: String = "photos"
    private let FIELD_PRICE_PER_PERSON: String = "pricePerPerson"
    private let FIELD_PHONE_NUMBER: String = "phoneNumber"
    
    init(db: Firestore) {
        self.db = db
    }
    
    static func getInstance() -> FireDBHelper {
        if shared == nil {
            shared = FireDBHelper(db: Firestore.firestore())
        }
        return shared!
    }
    
    func setUser(_ email: String) {
        // Implement your logic to handle setting user email
        UserDefaults.standard.set(email, forKey: "KEY_EMAIL")
    }
    
    func getAllWalks() {
            // Fetch data from the global collection without user-specific document
            self.db.collection("walks").addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                self.walkList.removeAll()
                for document in querySnapshot!.documents {
                    do {
                        var walk = try document.data(as: Walk.self)
                        walk.id = document.documentID
                        self.walkList.append(walk)
                    } catch let error {
                        print("Error decoding walk: \(error)")
                    }
                }
            }
        }
    
    
    func getFavorites() {
           guard let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") else {
               print("No logged in user")
               return
           }

           self.db.collection(COLLECTION_NAME)
               .document(loggedInUserEmail)
               .collection(COLLECTION_FAVORITES)
               .addSnapshotListener { (querySnapshot, error) in
                   if let error = error {
                       print("Error getting favorites: \(error)")
                       return
                   }
                   self.favoritesList.removeAll()
                   for document in querySnapshot!.documents {
                       do {
                           var walk = try document.data(as: Walk.self)
                           walk.id = document.documentID
                           self.favoritesList.append(walk)
                       } catch let error {
                           print("Error decoding favorite walk: \(error)")
                       }
                   }
               }
       }

       func toggleFavorite(walk: Walk, isFavorite: Bool) {
           guard let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") else {
               print("No logged in user")
               return
           }

           let favoritesRef = db.collection(COLLECTION_NAME)
               .document(loggedInUserEmail)
               .collection(COLLECTION_FAVORITES)
               .document(walk.id!)

           if isFavorite {
               favoritesRef.setData([
                   "id": walk.id!,
                   "name": walk.name,
                   "description": walk.description,
                   "starRating": walk.starRating,
                   "guideName": walk.guideName,
                   "address": walk.address,
                   "date": walk.date,
                   "time": walk.time,
                   "photos": walk.photos,
                   "pricePerPerson": walk.pricePerPerson,
                   "phoneNumber": walk.phoneNumber
               ])
           } else {
               favoritesRef.delete()
           }
       }
    
    func addPurchase(walk: Walk, quantity: Int, totalAmount: Double){
        guard let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") else {
            print("No logged in user")
            return
        }
        
        let purchaseData: [String: Any] = [
            "sessionID": walk.id!,
            "sessionName": walk.name,
            "quantity": quantity,
            "totalAmount": totalAmount,
            "purchaseDate": Timestamp(),
            "description": walk.description,
            "starRating": walk.starRating,
            "guideName": walk.guideName,
            "address": walk.address,
            "date": walk.date,
            "time": walk.time,
            "photos": walk.photos,
            "pricePerPerson": walk.pricePerPerson,
            "phoneNumber": walk.phoneNumber
        ]
        
            self.db.collection(COLLECTION_NAME)
                .document(loggedInUserEmail)
                .collection(COLLECTION_PURCHASES)
                .addDocument(data: purchaseData) { error in
                    if let error = error {
                        print("Error adding purchase: \(error)")
                               } else {
                                   print("Purchase added successfully")
                               }
                    }
    }
    
    func getAllPurchases() {
           guard let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") else {
               print("No logged in user")
               return
           }
           
           if loggedInUserEmail.isEmpty {
               print(#function, "No logged in user")
           } else {
               self.db.collection(COLLECTION_NAME)
                   .document(loggedInUserEmail)
                   .collection(COLLECTION_PURCHASES)
                   .addSnapshotListener { (querySnapshot, error) in
                       if let error = error {
                           print(#function, "No result received from firestore: \(error)")
                           return
                       }
                       
                       self.purchasesList.removeAll()
                       for document in querySnapshot!.documents {
                           do {
                               let purchase = try document.data(as: Purchase.self)
                               self.purchasesList.append(purchase)
                           } catch let error {
                               print("Error decoding purchase: \(error)")
                           }
                       }
                   }
           }
       }
    
    
}
