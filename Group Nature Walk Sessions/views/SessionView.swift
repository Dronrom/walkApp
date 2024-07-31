//
//  SessionView.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-06-09.
//

import SwiftUI

struct SessionView: View {

    @State private var selectedIndex: Int = -1
    //@EnvironmentObject var dataSource: NatureWalksDataSource
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    var body: some View {
        NavigationView {
            List{
                ForEach(self.fireDBHelper.walkList.enumerated().map({$0}), id: \.element.self){index, currentWalk in
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
                        //                .onTapGesture {
                        //                    self.selectedIndex = index
                        //                    print(#function, "selected book index : \(self.selectedIndex) \(self.fireDBHelper.bookList[selectedIndex].title)")
                        //                }
                    }//navLink
                }//ForEach
                
            }//List ends
        } .navigationTitle("Nature Walk Sessions")
            .onAppear(){
                //get all books from DB
                self.fireDBHelper.getAllWalks()
            }
    }
}
    
