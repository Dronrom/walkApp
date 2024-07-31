import SwiftUI

struct PurchaseView: View {
    let selectedWalkIndex: Int
    @State private var quantity: Double = 1
    @State private var cardNumber: String = ""
    @State private var cardHolderName: String = ""
    @State private var expirationDate: String = ""
    @State private var cvv: String = ""
    @State private var isCardValid: Bool = false // Track overall card validation
    
    @State private var isLiked = false
    var userDefaults = UserDefaults.standard
    @EnvironmentObject var fireDBHelper: FireDBHelper
    
    // Selected walk
    var selectedWalk: Walk {
        fireDBHelper.walkList[selectedWalkIndex]
    }
    
    // Computed property for total amount including tax
    var totalAmount: Double {
        let sum = selectedWalk.pricePerPerson * quantity
        return sum + (sum * 0.13)
    }
    
    @State private var showAlert = false //control the alert
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Section {
                Text(self.selectedWalk.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                Text(self.selectedWalk.description)
                    .font(.title2)
                    .padding(.top, 10)

                HStack {
                    Text("Star Rating: \(self.selectedWalk.starRating)/5")
                        .font(.title2)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }

                Text("Price per person: $\(String(format: "%.2f", self.selectedWalk.pricePerPerson))")
                    .font(.title2)
                Stepper(value: $quantity, in: 1...20) {
                    Text("Quantity: \(Int(quantity))")
                }
                Text("Tax 13%: $\(totalAmount - selectedWalk.pricePerPerson * quantity, specifier: "%.2f")")
                Text("TOTAL: $\(totalAmount, specifier: "%.2f")")
            }

            Section(header: Text("Payment Information")) {
                TextField("Card Number", text: $cardNumber)
                    .keyboardType(.numberPad)
                TextField("Cardholder Name", text: $cardHolderName)
                HStack {
                    TextField("Expiration Date (MM/YY)", text: $expirationDate)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                }
            }

            HStack {
                Spacer()
                Button {
                    // Validate card details before proceeding
                    if validateCardDetails() {
                        handlePurchase()
                    } else {
                        // Show an alert for invalid card details
                        showAlert = true
                    }
                } label: {
                    Text("Buy")
                }
                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Card Details"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            // Add your onAppear logic here
        }
    }
    
    // Function to validate card details
    private func validateCardDetails() -> Bool {
        // Example of basic validation (you can expand this as needed)
        guard !cardNumber.isEmpty, cardNumber.count == 16 else {
            alertMessage = "Invalid card number. Please enter a 16-digit card number."
            return false
        }
        guard !cardHolderName.isEmpty else {
            alertMessage = "Cardholder name cannot be empty."
            return false
        }
        guard !expirationDate.isEmpty, expirationDate.contains("/") else {
            alertMessage = "Invalid expiration date. Please enter in MM/YY format."
            return false
        }
        guard !cvv.isEmpty, cvv.count == 3 else {
            alertMessage = "Invalid CVV. Please enter a 3-digit CVV."
            return false
        }
        return true
    }
    
    // Function to handle purchase logic
    private func handlePurchase() {
        // Perform additional purchase logic here
        print("Card Number: \(cardNumber)")
        print("Cardholder Name: \(cardHolderName)")
        print("Expiration Date: \(expirationDate)")
        print("CVV: \(cvv)")
        
        // Example: Add purchase to Firestore or another backend
        fireDBHelper.addPurchase(walk: selectedWalk, quantity: Int(quantity), totalAmount: totalAmount)
    }
}
