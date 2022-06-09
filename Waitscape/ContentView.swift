//
//  ContentView.swift
//  Waitscape
//
//  Created by Erika Frison on 5/6/22.
//

import CoreLocation
import MapKit
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
    @State private var airportStatus = AirportStatus(rightnow_description: "Empty", city: "No results", state: "Nothing", code: "No Results")
    @State private var airports: [Airport] = []
    @State private var waitTime: Double = 15
    @State private var searchAirports = ""
    @State var isSearching = false
    @State private var selectedAirport: Airport?
    
    var searchResults: [Airport] {
        if searchAirports.isEmpty {
            return airports
        } else {
            return airports.filter { airport in  airport.formattedName.lowercased().contains(searchAirports.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView{
                
                VStack{
                    
                    
                    
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
                                .opacity(0.4)
                            Arc(waitTime: waitTime)
                                .stroke(Color("Waitscape Orange"), lineWidth:12)
                                .animation(.spring(), value: 0.1)
                            
                        }
                        .padding(40)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .task {
                            await fetchAirportStatus(name: "")
                            await fetchAirports()
                        }
                    }
                    
                    
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("Waitscape Logo")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(height: 100.0)
                }
            }
            .onChange(of: searchAirports) {newValue in Task {
                if let airport = airports.first(where: {$0.formattedName == searchAirports}) {
                    await fetchAirportStatus(name: airport.code)
                }
                
            }
            }
            .searchable(text: $searchAirports, placement: .navigationBarDrawer(displayMode: .always)) {
                ForEach(searchResults, id: \.code) { result in
                    Text(result.formattedName).searchCompletion(result.formattedName)
                }
            }
        }
    }
    func fetchAirportStatus(name: String) async {
        guard let url = URL(string: "https://www.tsawaittimes.com/api/airport/xdPHn0U0V8hXi59Q9MkfHCOrBctU8EfZ/\(name)"
                            
        ) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(AirportStatus.self, from: data) {
                airportStatus = decodedResponse
                waitTime = (airportStatus.rightnow_description as NSString).doubleValue
            }
            
        } catch {
            print("Invalid data")
        }
    }
    
    func fetchAirports() async {
        guard let url = URL(string: "https://www.tsawaittimes.com/api/airports/xdPHn0U0V8hXi59Q9MkfHCOrBctU8EfZ"
                            
        ) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedResponse = try! JSONDecoder().decode([Airport].self, from: data)
            airports = decodedResponse
            
            for airport in airports {
                print(airport.code)
            }
            
            
            
            //            if let decodedResponse = try? JSONDecoder().decode([Airport].self, from: data) {
            //                airports = decodedResponse
            //
            //                for airport in airports {
            //                    print(airport.code)
            //                }
            //            }
            
        } catch {
            print("Invalid data")
        }
    }
    
    
    
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
