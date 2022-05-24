//
//  Location.swift
//  Waitscape
//
//  Created by Cal Roskopp on 5/24/22.
//


import SwiftUI
import MapKit
import CoreLocationUI


    


struct ContentView1: View {
    @StateObject private var viewModel = LManager()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion:  $viewModel.region, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear {
                    viewModel.checkIfLocationServiceisEnabled()
                    
                    
        }
            
            LocationButton(.currentLocation) {
                viewModel.checkIfLocationServiceisEnabled()
                
            }
        
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
                .padding(.bottom, 50)
    }
}
}

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

