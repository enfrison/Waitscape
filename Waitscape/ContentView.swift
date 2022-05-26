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
    @State var isSearching = false
    
    var body: some View {
        ScrollView{
            
         VStack{

             HStack {
                 Image("Waitscape Logo")
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .bottom])
                    .frame(height: 175.0)
               
                 Spacer()
             }
     
            HStack{
            HStack{
                TextField("Search Airports", text: $searchAirports)
                    .padding(.leading, 24)
            }
            .padding()
            .onChange(of: searchAirports) {newValue in Task {
                await fetchAirportStatus(name: newValue)
            }
                
            }
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .padding(.horizontal)
      
            .onTapGesture(perform: {
                isSearching = true
            })
            .overlay(
                HStack{
                   Image(systemName: "magnifyingglass")
                    Spacer()
                if isSearching {
                    Button(action: { searchAirports = "" }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(.vertical)
                    })

                    }
                }.padding(.horizontal, 32)
                    .foregroundColor(.gray)
            )
                if isSearching{
                Button(action: { isSearching = false
                    searchAirports = ""
                }, label: { Text("Cancel")
                        .padding(.trailing)
                        .padding(.leading, -12)
                })
                    .transition(.move(edge: .trailing))
                    
                }
            }
            
            
//            NavigationView{
        
             
                //      VStack {
                    //                    HStack {
                    //                        Text(airportStatus.city)
                    //                            .font(.largeTitle)
                    //
                    //                        Text(airportStatus.state)
                    //                            .font(.largeTitle)
                    //                    }
  //
//                    Text(airportStatus.code)
//                        .font(.title2)
//                        .padding()
                    
                    
                    //Text(airportStatus.rightnow_description)
                    //Text("Wait time at :")
          //      .padding()
           // .padding(.vertical, -15)
            Spacer()
             GeometryReader { geometry in
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
                            .opacity(0.3)
                            Arc(waitTime: waitTime)
                                .stroke(Color("Waitscape Orange"), lineWidth:12)
                     //animation line
                   
                        }
                        .padding(40)
                 .frame(width: geometry.size.width, height: geometry.size.width)
                    .task {
                        await fetchAirportStatus(name: "")
                }
             }
            
                 
                    
                  
//            }
//            .searchable(text: $searchAirports)
            
        
           
            }
      
    }
        }
    func fetchAirportStatus(name: String) async {
        guard let url = URL(string: "https://www.tsawaittimes.com/api/airport/tNnuJo9m20iRpv2MKI1XFbZeC2BrjYLr/\(name)"
) else {
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
     
}

        



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
