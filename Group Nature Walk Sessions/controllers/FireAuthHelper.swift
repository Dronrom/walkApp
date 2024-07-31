import Foundation
import FirebaseAuth
import Combine

class FireAuthHelper: ObservableObject {
    
    @Published var user: User?
    
    private static var shared: FireAuthHelper?
    
    static func getInstance() -> FireAuthHelper {
        if shared == nil {
            shared = FireAuthHelper()
            shared?.listenToAuthState()
        }
        return shared!
    }
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            self.user = user
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let result = authResult else {
                completion(false, error?.localizedDescription)
                return
            }
            self.user = result.user
            UserDefaults.standard.set(self.user?.email, forKey: "KEY_EMAIL")
            completion(true, nil)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            UserDefaults.standard.removeObject(forKey: "KEY_EMAIL")
            print(#function, "Successfully logged out user")
        } catch let error {
            print(#function, "Unable to sign out user: \(error)")
        }
    }
    
    var isUserLoggedIn: Bool {
        return user != nil
    }
}
