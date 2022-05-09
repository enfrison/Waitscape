//
//  ContentView.swift
//  Waitscape
//
//  Created by Erika Frison on 5/6/22.
//

import SwiftUI

struct Arc: Shape {
var waitTime: Double
//    let startAngle: Angle
//    let endAngle: Angle
//    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: Angle(degrees: -240), endAngle: Angle(degrees: Double(-240.0 + (waitTime * 300 / 120))), clockwise: false)
        
        return path
    }
}

struct ContentView: View {
    @State private var waitTime: Double = 15
    @State private var searchAirports = ""
    var body: some View {
        VStack{

            Image("Waitscape Logo")
                .resizable()
                .scaledToFit()
            NavigationView{
                
                ZStack{
                    Text("Detroit Metro Airport")
                      .font(.headline)
                Arc(waitTime: 120)
                    .stroke(.blue, lineWidth: 12)

                    Arc(waitTime: waitTime)
                        .stroke(.gray, lineWidth:12)
           
            
                }
                .padding()
            }
            
        }
        .searchable(text: $searchAirports)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
