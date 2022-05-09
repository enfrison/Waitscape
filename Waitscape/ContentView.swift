//
//  ContentView.swift
//  Waitscape
//
//  Created by Erika Frison on 5/6/22.
//

import SwiftUI

struct ContentView: View {
    @State private var searchAirports = ""
    var body: some View {
        VStack{
            
         Image("Waitscape Logo")
            .resizable()
            .scaledToFit()
        NavigationView{
            Text("Detroit Metro Airport")
                .font(.headline)
        }
        .searchable(text: $searchAirports)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
