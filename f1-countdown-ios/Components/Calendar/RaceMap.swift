//
//  RaceMap.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI
import MapKit
import CoreLocation

struct RaceMap: View {
    @State var location: [CLPlacemark]?;
    
    var latitude: Double = 24.4821;
    var longitude: Double = 54.3482;
    
    var body: some View {
        @Namespace var mapScope;
        let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100);
        let region = MKCoordinateRegion(center: coords, span: span);
        let bounds = MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 1000);

        VStack {
            Map(bounds: bounds, interactionModes: [.all], scope: mapScope) {
                Marker(coordinate: coords) {
                    Text("Track")
                }
            }.mapStyle(.imagery)
        }.onAppear {
            print(coords)
        }.task {
            let geocoder = CLGeocoder();
            
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude));
                print(placemarks)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    RaceMap()
}
