//
//  PurchaseListView.swift
//  Group Nature Walk Sessions
//
//  Created by Roman Devda on 2024-07-10.
//

import SwiftUI

struct PurchaseListView: View {
    @State private var selectedIndex: Int = -1
    @EnvironmentObject var fireDBHelper: FireDBHelper

    var body: some View {
        NavigationView {
            List {
                ForEach(self.fireDBHelper.purchasesList.enumerated().map({ $0 }), id: \.element.self) { index, currentPurchase in
                    NavigationLink(destination: SessionDetailsView(selectedWalkIndex: index).environmentObject(self.fireDBHelper)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(currentPurchase.sessionName)
                                    .font(.headline)
                                Text("Date: \(formattedDate(from: currentPurchase.date))")
                                Text("Time: \(currentPurchase.time)")
                                Text("Total Amount Paid: $\(String(format: "%.2f", currentPurchase.totalAmount))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onTapGesture {
                            self.selectedIndex = index
                            print(#function, "selected book index : \(self.selectedIndex) \(self.fireDBHelper.purchasesList[selectedIndex].sessionName)")
                        }
                    } // NavigationLink
                } // ForEach
            } // List
            .navigationTitle("Purchased List")
            .onAppear {
                // Get all purchases from DB
                self.fireDBHelper.getAllPurchases()
            }
        }
    }

    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct PurchaseListView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseListView()
    }
}
