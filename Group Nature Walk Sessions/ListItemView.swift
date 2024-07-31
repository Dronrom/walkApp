//
//  ListItemView.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-06-09.
//

import SwiftUI

struct ListItemView: View {
    var walk: Walk
    
    @EnvironmentObject var dataSource: NatureWalksDataSource
    
    var body: some View {
        NavigationView {
            List(dataSource.walksList) { walk in
                NavigationLink(destination: SessionDetailsView(selectedWalk: walk).environmentObject(self.dataSource)) {
                    HStack {
                        Image(walk.photos[0]) // Assuming the first photo in the array is the primary photo
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)

                        VStack(alignment: .leading) {
                            Text(walk.name)
                                .font(.headline)
                            Text("Price per person: $\(walk.pricePerPerson)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Nature Walk Sessions")
        }
    }
}


