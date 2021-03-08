//
//  PlaceRow.swift
//  Todo
//
//  Created by Tran Tran on 3/7/21.
//
import SwiftUI
import GooglePlaces

struct PlaceRow: View {
    // 1
    var place: GMSPlace
    
    var body: some View {
        HStack {
            // 2
            Text(place.name ?? "")
                .foregroundColor(.white)
            Spacer()
        }
    }
}
