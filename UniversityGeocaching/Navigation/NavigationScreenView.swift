//
//  NavigationScreenView.swift
//  UniversityGeocaching
//
//  Created by Ewhondens Kenel on 3/19/23.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation

struct Cache: Identifiable {
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct NavigationScreenView: View {
    @StateObject private var locationManager = LocationManager()
    var caches = [
        Cache(name: "USD Torero Store", coordinate: CLLocationCoordinate2D(latitude: 32.772364, longitude: -117.187653)),
        Cache(name: "Student Life Pavilion", coordinate: CLLocationCoordinate2D(latitude: 32.77244, longitude: -117.18727)),
        Cache(name: "Warrren Hall", coordinate: CLLocationCoordinate2D(latitude: 32.77154, longitude:  -117.18884)),
        Cache(name: "Copley Library", coordinate: CLLocationCoordinate2D(latitude: 32.771443, longitude: -117.193472)),
    ]
    
    var body: some View {
        TabView {
            ZStack {
                Map(coordinateRegion: $locationManager.region, annotationItems: caches) {
                    cache in MapAnnotation(coordinate: cache.coordinate) {
                        Circle()
                            .foregroundColor(Color.green.opacity(0.4))
                            .frame(width: 100, height: 100)
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Code to show current location
                        }) {
                            Image(systemName: "location.circle.fill")
                                .foregroundColor(.blue)
                                .padding(.top, 10) // Adds 10 points of padding to the top
                                .padding(.leading, 20) // Adds 20 points of padding to the leading (left) side
                                .padding(.bottom, 80) // Adds 30 points of padding to the bottom
                                .padding(.trailing, 40) // Adds 40 points of padding to the trailing (right) side
                                .font(.system(size: 32))
                        }
                    }
                }
                
            }
            
                        .tabItem {
                Image(systemName: "map")
                Text("Map")
            }
            
            Text("Camera/QR reader")
                .tabItem {
                    Image(systemName: "camera")
                    Text("Camera")
                    
                }
            
            List(caches) { cache in
                Text(cache.name)
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("List")
            }
            
            
                
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    struct NavigationScreenView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationScreenView()
        }
    }
    
    class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.772364, longitude: -117.187653), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        private let locationManager = CLLocationManager()
        
        override init() {
            super.init()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        }
    }
}
