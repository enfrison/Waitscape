//
//  ContentView.swift
//  Waitscape
//
//  Created by Erika Frison on 5/6/22.
//

import SwiftUI

struct airportStatus: Codable {
    var rightnow_description: String
    var city: String
    var state: String
    var code: String
}
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
    @State private var airportStatus = AirportStatus(rightnow_description: "Empty", city: "Nothing", state: "Nothing", code: "Nothing")
    @State private var waitTime: Double = 15
    @State private var searchAirports = ""
    var body: some View {
        VStack{

            Image("Waitscape Logo")
                .resizable()
                .padding([.top, .leading, .bottom])
                .frame(width: 220.0, height: 150.0)
                .scaledToFit()
                .offset(x: -105, y: -5)
            NavigationView{
        
             
                VStack {
//                    HStack {
//                        Text(airportStatus.city)
//                            .font(.largeTitle)
//
//                        Text(airportStatus.state)
//                            .font(.largeTitle)
//                    }
                    }
//                    Text(airportStatus.code)
//                        .font(.title2)
//                        .padding()
                    
                    
                    //Text(airportStatus.rightnow_description)
                    //Text("Wait time at :")
                .padding()
                
                    ZStack {
                        VStack{
                            Text(airportStatus.code)
                                .font(.largeTitle)
                            .padding()
                        Text("\(Int(waitTime)) Minutes")
                            .font(.largeTitle)
        
                            .multilineTextAlignment(.center)
                        }
                    Arc(waitTime: 120)
                        .stroke(Color("Waitscape Blue"), lineWidth: 12)

                        Arc(waitTime: waitTime)
                            .stroke(Color("Waitscape Orange"), lineWidth:12)
               
                    }
                     .frame(width: 300, height: 300)
                .task {
                    guard let url = URL(string: "https://www.tsawaittimes.com/api/airport/bpmLZd3ywayMaJfSJHIjLGxzxOZlpzA9/DTW") else {
                        print("Invalid URL")
                        return
                    }
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        
                        if let decodedResponse = try? JSONDecoder().decode(AirportStatus.self, from: data) {
                            airportStatus = decodedResponse
                            waitTime = (airportStatus.rightnow_description as NSString).doubleValue
                        }            } catch {
                            print("Invalid data")
                        }
                }
                Spacer()
                 
                    
                  
            }
            .searchable(text: $searchAirports)
            .navigationBarBackButtonHidden(true)
           
            }
      
            
        }
     
}

        



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
