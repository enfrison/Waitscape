//
//  WaitscapeApp.swift
//  Waitscape
//
//  Created by Erika Frison on 5/6/22.
//

import SwiftUI

struct AirportStatus: Codable {
    var rightnow_description: String
    var city: String
    var state: String
    var code: String
}
struct ArcGraph: Shape {
    var waitTime: Double
    
    
    //range of mins: 0 to 120
    //range of arc: -240 to 60
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: Angle(degrees: -240), endAngle: Angle(degrees: Double(-240.0 + (waitTime * 300 / 120))), clockwise: false)
        
        return path
    }
}

struct TSA: View {
    @State private var waitTime: Double = 0
    
    var waitTimeColor: Color {
        if waitTime >= 0 && waitTime < 30 {
            return .green
        } else if waitTime >= 30 && waitTime < 60 {
            return .yellow
        } else if waitTime >= 60 && waitTime < 90 {
            return .orange
        } else {
            return .red
        }
    }
    
    @State private var airportStatus = AirportStatus(rightnow_description: "Empty", city: "Nothing", state: "Nothing", code: "Nothing")
    
    var body: some View {
        VStack {
            HStack { Text(airportStatus.city)
                    .font(.largeTitle)
                Text(airportStatus.state)
                    .font(.largeTitle)
                
            }
            Text(airportStatus.code)
                .font(.title2)
                .padding()
            
            
            //Text(airportStatus.rightnow_description)
            //Text("Wait time at :")
                .padding()
            ZStack {
                Text("\(Int(waitTime)) Minutes")
                    .font(.largeTitle)
                    .foregroundColor(waitTimeColor)
                    .multilineTextAlignment(.center)
                Arc(waitTime: 120)
                    .stroke(.gray, lineWidth: 10)
                Arc(waitTime: waitTime)
                    .stroke(waitTimeColor, lineWidth: 10)
                
            }
            .frame(width: 300, height: 300)
            //Slider(value: $waitTime, in: 0...120)
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
            
            
        }
        
        
    }
}



struct TSA_Previews: PreviewProvider {
    static var previews: some View {
        TSA()
    }
}


@main
struct WaitscapeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
