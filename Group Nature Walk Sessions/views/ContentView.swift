import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    @State private var isShowingLogin = false
    @State private var isShowingProfile = false
    @StateObject private var fireDBHelper = FireDBHelper.getInstance()
    @StateObject private var fireAuthHelper = FireAuthHelper.getInstance()
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                FavoritesView()
                    .environmentObject(fireDBHelper)
                    .tabItem {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.brown)
                        Text("Favs")
                    }
                    .tag(0)
                
                SessionView()
                    .environmentObject(fireDBHelper)
                    .tabItem {
                        Image(systemName: "list.clipboard.fill")
                            .foregroundColor(.brown)
                        Text("All Walks Session")
                    }
                    .tag(1)
                PurchaseListView()
                    .environmentObject(fireDBHelper)
                    .tabItem {
                        Image(systemName: "list.clipboard.fill")
                            .foregroundColor(.brown)
                        Text("Purchases List")
                    }
                    .tag(2)
            }
            .navigationTitle("Nature Walks")
            .onAppear(){
                self.fireDBHelper.getAllPurchases()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if fireAuthHelper.isUserLoggedIn {
                        Button(action: {
                            isShowingProfile = true
                        }) {
                            Image(systemName: "person.fill")
                        }
                        
                        Button(action: {
                            fireAuthHelper.signOut()
                            selectedTab = 1 // Reset to default tab
                        }) {
                            Image(systemName: "arrow.backward.square")
                        }
                    } else {
                        Button(action: {
                            isShowingLogin = true
                        }) {
                            Image(systemName: "person.fill")
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingLogin) {
                LoginView(onLoginSuccess: { email in
                    fireDBHelper.setUser(email)
                    fireAuthHelper.listenToAuthState()
                    isShowingLogin = false
                })
                .environmentObject(fireAuthHelper)
            }
            .sheet(isPresented: $isShowingProfile) {
                ProfileView()
                    .environmentObject(fireAuthHelper)
            }
        }
    }
}
