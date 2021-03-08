//
//  GoogleMapsView.swift
//  Todo
//
//  Created by Tran Tran on 3/7/21.
//
import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    // 1
    @ObservedObject var locationManager = LocationManager()
    private let zoom: Float = 15.0
    let UWposition = CLLocationCoordinate2D(latitude: 47.655548, longitude: -122.303200)
    let SpaceNeedle = CLLocationCoordinate2D(latitude: 47.6205, longitude: -122.3493)
    
    // 2
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    // 3
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        //        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        //        mapView.camera = camera
        mapView.clear()
        let position = CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
        let currentlocation = GMSMarker(position: position)
        currentlocation.icon = GMSMarker.markerImage(with: .blue)
        currentlocation.map = mapView
        
        let marker = GMSMarker(position: UWposition)
        let marker1 = GMSMarker(position: SpaceNeedle)
        marker.opacity = 0.5
        marker.title = "UW - (low polution)"
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = mapView
        marker1.opacity = 0.9
        marker1.title = "Space Needle - (high polution)"
        marker1.icon = GMSMarker.markerImage(with: .red)
        marker1.map = mapView
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker1.appearAnimation = GMSMarkerAnimation.pop
        // mapView.animate(toLocation: position)
    }
}

struct GoogleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapsView()
    }
}
