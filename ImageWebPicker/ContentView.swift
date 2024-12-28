//
//  ContentView.swift
//  ImageWebPicker
//
//  Created by 16Root24 on 17/12/2024.
//

import SwiftUI
import MapKit
import GeoImagePicker

struct ContentView: View {
  @State private var showingImagePicker = false
  @State private var selectedLocation: LocationCoordinate?
  @State private var selectedImage: UIImage?
  @State private var creationDate: Date?
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 37.3361, longitude: -122.0380),
    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
  )
  
  var body: some View {
    TabView {
      // Map Tab
      NavigationStack {
        ZStack {
          Map(coordinateRegion: $region,
              annotationItems: selectedLocation
            .map { [MapPin(coordinate: $0.coordinate)] } ?? []) { pin in
              MapMarker(coordinate: pin.coordinate, tint: .red)
            }
            .ignoresSafeArea(.all, edges: .top)
          
          VStack {
            Spacer()
            
            if let image = selectedImage {
              Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .cornerRadius(10)
                .padding()
                .background(
                  RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
                )
                .padding()
            }
            
            GeoImagePickerButton { result in
              print(result)
              if let result = result {
                selectedLocation = result.location
                selectedImage = result.image
                creationDate = result.creationDate
              }
            }
            
            Button(action: {
              showingImagePicker = true
            }) {
              Label(NSLocalizedString("Select Image", comment: "Button to select image"), systemImage: "photo.fill")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
          }
        }
        .navigationTitle(NSLocalizedString("Photo Map", comment: "Map screen title"))
        .sheet(isPresented: $showingImagePicker) {
          GeoImagePickerSheet { result in
            if let result = result {
              selectedLocation = result.location
              selectedImage = result.image
              creationDate = result.creationDate
            }
          }
        }
        .onChange(of: selectedLocation) { old, newLocation in
          if let location = newLocation {
            withAnimation {
              region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
              )
            }
          }
        }
      }
      .tabItem {
        Label(NSLocalizedString("Map", comment: "Map tab title"), systemImage: "map")
      }
      
      // Settings Tab
      SettingsView()
        .tabItem {
          Label(NSLocalizedString("Settings", comment: "Settings tab title"), systemImage: "gear")
        }
    }
  }
}


#Preview {
  ContentView()
}

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}
