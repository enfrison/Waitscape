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
    
    var animatableData: Double {
        get { waitTime }
        set { waitTime = newValue }
    }
    

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: Angle(degrees: -240), endAngle: Angle(degrees: Double(-240.0 + (waitTime * 300 / 120))), clockwise: false)
        
        return path
    }
}

struct ContentView: View {
    @State private var airportStatus = AirportStatus(rightnow_description: "Empty", city: "No results", state: "Nothing", code: "No Results")
    @State private var waitTime: Double = 15
    @State private var searchAirports = ""
    @State var isSearching = false
    
    var body: some View {
     //   ScrollView{
        GeometryReader { geometry in
         VStack{
             Spacer()

             HStack {
                 Image("Waitscape Logo")
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .bottom])
                    .padding(.top)
                    .frame(height: 100.0)
               
                 Spacer()
             }
     
            HStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search Airports", text: $searchAirports)
                  
            }
            .padding(10)
            .submitLabel(.search)
            .onChange(of: searchAirports) {newValue in Task {
                await fetchAirportStatus(name: newValue)
            }
                
            }
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .padding(.horizontal, 5)
      
            .onTapGesture(perform: {
                withAnimation {
                isSearching = true
                }
            })
            .overlay(
                HStack{
                   
                    Spacer()
                if isSearching {
                    Button(action: { searchAirports = "" }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(.vertical)
                    })

                    }
                }.padding(.horizontal)
                    .foregroundColor(.gray)
            )
                if isSearching{
                Button(action: {
                    withAnimation {
                    isSearching = false
                    }
                    searchAirports = ""
                    hideKeyboard()
                }, label: { Text("Cancel")
                        .padding(.trailing)
                        
                  
                })
                        .animation(.linear, value: isSearching)
                }
                
            }


                 ZStack {
                            VStack{
                                Text(airportStatus.code)
                                    .font(.largeTitle)
                                    .padding(.top)
                            Text("\(Int(waitTime)) Minutes")
                                .font(.largeTitle)
            
                                .multilineTextAlignment(.center)
                            }
                            .animation(.none, value: waitTime)
                        Arc(waitTime: 120)
                            .stroke(Color("Waitscape Blue"), lineWidth: 12)
                            .opacity(0.4)
                            Arc(waitTime: waitTime)
                                .stroke(Color("Waitscape Orange"), lineWidth:12)
                                
                   
                        }
                        .padding(40)
                 .frame(width: geometry.size.width, height: geometry.size.width)
                    .task {
                        await fetchAirportStatus(name: "")
                }
                    .padding(.top)
             Spacer()
             Spacer()
             }
            }
    //    .ignoresSafeArea(.keyboard)

        }
    func fetchAirportStatus(name: String) async {
        guard let url = URL(string: "https://www.tsawaittimes.com/api/airport/Rj9mo0YaIOk0RgoEx4wI1YDJWdunmEmL/\(name)"
                            
) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(AirportStatus.self, from: data) {
                airportStatus = decodedResponse
                withAnimation {
                waitTime = (airportStatus.rightnow_description as NSString).doubleValue
                }
            }            } catch {
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
