import SwiftUI
import MapKit

struct ShareableSession {
    let name: String
    let pricePerPerson: Double

    var shareContent: String {
        "Check out the \(name) session for only $\(pricePerPerson) per person!"
    }
}

struct CustomMapAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var content: () -> AnyView
}

struct SessionDetailsView: View {
    let selectedWalkIndex: Int
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @StateObject private var fireAuthHelper = FireAuthHelper.getInstance()
    
    @State private var isShowingShareSheet = false
    @State private var isLiked = false
    @State private var isShowingLogin = false
    @State private var isNavigatingToPurchase = false
    
    @State private var name: String = "NA"
    @State private var description: String = "NA"
    @State private var starRating: Int = 5
    @State private var guideName: String = "NA"
    @State private var phoneNumber: String = "NA"
    @State private var pricePerPerson: Double = 0.0
    @State private var photos: [String] = []
    @State private var date: Date = Date()
    @State private var time: String = "NA"
    @State private var address: String = "NA"
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default center for San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showMapSheet = false // Flag to show map in sheet
    @State private var geocodingError: Error? = nil
    @State private var mapAnnotation: CustomMapAnnotation?

    var shareableSession: ShareableSession {
        ShareableSession(name: self.name, pricePerPerson: self.pricePerPerson)
    }

    var body: some View {
        VStack(alignment: .center) {
            Section {
                Text(self.name)
                    .font(.title2)
                    .padding(.horizontal)
                Text(self.description)
                    .font(.title3)
                    .padding(.top, 10)
                HStack {
                    Text("Star Rating: \(self.starRating)/5")
                        .font(.title3)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                Button {
                    viewModel.callNumber(phoneNumber: phoneNumber)
                } label: {
                    VStack {
                        Text("Guide: \(self.guideName)")
                            .font(.title3)
                            .foregroundColor(.black)
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
                            Text("+\(self.phoneNumber)")
                                .foregroundColor(.black)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                }
                Text("Price per person: $\(String(format: "%.2f", self.pricePerPerson))")
                    .font(.title3)
                // Display address, date, and time
                Button {
                    showMapSheet.toggle()
                } label: {
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.blue)
                        Text("Address: \(self.address)")
                            .foregroundColor(.blue)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                Text("Date: \(formattedDate())")
                    .font(.title3)
                Text("Time: \(self.time)")
                    .font(.title3)
            }
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(self.photos, id: \.self) { photo in
                            Image(photo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button {
                    isShowingShareSheet.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.black)
                }
                .padding()
                Spacer()
                Button {
                    if fireAuthHelper.isUserLoggedIn {
                        isNavigatingToPurchase = true
                    } else {
                        isShowingLogin = true
                    }
                } label: {
                    Text("Buy")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .sheet(isPresented: $isShowingLogin) {
                    LoginView(onLoginSuccess: { email in
                        fireDBHelper.setUser(email)
                        fireAuthHelper.listenToAuthState()
                        isShowingLogin = false
                        isNavigatingToPurchase = true
                    })
                    .environmentObject(fireAuthHelper)
                }
                .background(
                    NavigationLink(destination: PurchaseView(selectedWalkIndex: selectedWalkIndex).environmentObject(fireDBHelper), isActive: $isNavigatingToPurchase) {
                        EmptyView()
                    }
                    .hidden()
                )
                Spacer()
                Button {
                    if fireAuthHelper.isUserLoggedIn {
                        isLiked.toggle()
                        let walk = self.fireDBHelper.walkList[selectedWalkIndex]
                        fireDBHelper.toggleFavorite(walk: walk, isFavorite: isLiked)
                    } else {
                        isShowingLogin = true
                    }
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.black)
                }
                .padding()
                Spacer()
            }
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ActivityViewController(activityItems: [shareableSession.shareContent])
        }
        .sheet(isPresented: $showMapSheet) {
            MapView(region: $region, annotation: mapAnnotation)
                .onAppear {
                    showMap()
                }
        }
        .onAppear {
            let walk = self.fireDBHelper.walkList[selectedWalkIndex]
            self.name = walk.name
            self.description = walk.description
            self.starRating = walk.starRating
            self.guideName = walk.guideName
            self.phoneNumber = walk.phoneNumber
            self.pricePerPerson = walk.pricePerPerson
            self.photos = walk.photos
            self.date = walk.date
            self.time = walk.time
            self.address = walk.address

            // Geocode the address to get coordinates
            self.geocodeAddress()
            
            // Check if the walk is already in the favorites list
            if fireDBHelper.favoritesList.contains(where: { $0.id == walk.id }) {
                self.isLiked = true
            }
        }
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self.date)
    }

    private func showMap() {
        self.mapAnnotation = CustomMapAnnotation(coordinate: self.region.center) {
            AnyView(
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                    .opacity(0.8)
                    .frame(width: 30, height: 30)
            )
        }
    }
    
    private func geocodeAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.address) { placemarks, error in
            if let error = error {
                print("Geocoding failed with error: \(error.localizedDescription)")
                self.geocodingError = error
                return
            }
            
            if let location = placemarks?.first?.location {
                let coordinate = location.coordinate
                self.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                
                // Set initial map annotation
                self.mapAnnotation = CustomMapAnnotation(coordinate: coordinate) {
                    AnyView(
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .opacity(0.8)
                            .frame(width: 30, height: 30)
                    )
                }
            } else {
                print("Location not found")
                self.geocodingError = NSError(domain: "Geocoding", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location not found"])
            }
        }
    }
}

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    let annotation: CustomMapAnnotation?
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            Text("Map")
                .font(.title)
                .padding()
            if let annotation = annotation {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [annotation]) { annot in
                    MapAnnotation(coordinate: annot.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1.0)) {
                        annot.content()
                    }
                }
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
            } else {
                Text("No location available")
                    .foregroundColor(.red)
            }
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController

    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct SessionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailsView(selectedWalkIndex: 0)
    }
}
