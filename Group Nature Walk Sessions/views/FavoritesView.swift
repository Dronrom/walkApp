import SwiftUI

struct FavoritesView: View {
    @State private var selectedIndex: Int = -1
    @EnvironmentObject var fireDBHelper: FireDBHelper

    var body: some View {
        NavigationView {
            List {
                ForEach(self.fireDBHelper.favoritesList.enumerated().map({$0}), id: \.element.self){index, currentWalk in
                    NavigationLink(destination: SessionDetailsView(selectedWalkIndex: index).environmentObject(self.fireDBHelper)){
                        HStack {
                            Image(currentWalk.photos[0]) // Assuming the first photo in the array is the primary photo
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(currentWalk.name)
                                    .font(.headline)
                                Text("Price per person: $\(String(format: "%.2f", currentWalk.pricePerPerson))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteWalk)
            }
            .navigationTitle("Favorite Walks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: deleteAllFavorites) {
                        Text("Delete All")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            fireDBHelper.getFavorites()
        }
    }

    private func deleteWalk(at offsets: IndexSet) {
        for index in offsets {
            let walk = fireDBHelper.favoritesList[index]
            fireDBHelper.toggleFavorite(walk: walk, isFavorite: false)
        }
    }

    private func deleteAllFavorites() {
        for walk in fireDBHelper.favoritesList {
            fireDBHelper.toggleFavorite(walk: walk, isFavorite: false)
        }
    }
}

// #Preview {
//     FavoritesView().environmentObject(FireDBHelper.getInstance())
// }
