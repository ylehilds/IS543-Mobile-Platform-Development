//
//  ContentView.swift
//  Map It 2023
//
//  Created by Lehi Alcantara on 9/8/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    private var formatter = NumberFormatter()
    @State private var latitudeValue = "40.2503"
    @State private var longitudeValue = "-111.65231"
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40, longitude: -111),
        span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        )
    )
    var body: some View {
        VStack {
            HStack {
                TextField("Latitude", text: $latitudeValue)
                TextField("Longititude", text: $longitudeValue)
                Button("Map It") {
                    updateMapRegion()
                }
            }
            .padding(.horizontal, 20)

            Map(position: $cameraPosition)
                .mapStyle(.hybrid(showsTraffic: true))
                .mapControls {
                    MapScaleView()
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: {
                    updateMapAppearance()
                })
        }
    }
    
    private func updateMapAppearance() {
        let map = MKMapView.appearance()
        
        map.mapType = .satellite
        map.showsTraffic = true
        map.showsBuildings = true
        map.showsScale = true
        map.isRotateEnabled = true
    }
    
    
    private func updateMapRegion() {
        withAnimation {
            if let latitude = formatter.number(from: latitudeValue),
                let longitude = formatter.number(from: longitudeValue) {
                cameraPosition = MapCameraPosition.region(
                    MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: latitude.doubleValue,
                        longitude: longitude.doubleValue
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
                    )
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
