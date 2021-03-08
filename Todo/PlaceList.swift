//
//  PlaceList.swift
//  Todo
//
//  Created by Tran Tran on 3/7/21.
//

import SwiftUI

struct PlacesList: View {
    // 1
    @ObservedObject private var placesManager = PlacesManager()
    
    var body: some View {
        NavigationView {
            // 2
            List(placesManager.places, id: \.place.placeID) { placeLikelihood in
                // 3
                PlaceRow(place: placeLikelihood.place)
            }
            .navigationBarTitle("Nearby Locations")
        }
    }
}
