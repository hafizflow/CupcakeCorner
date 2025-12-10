//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Hafizur Rahman on 10/12/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    let trackId: Int
    let trackName: String
    let collectionName: String
    let artworkUrl100: String
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { result in
            VStack(alignment: .leading) {
                HStack {
                    AsyncImage(url: URL(string: result.artworkUrl100)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Text("There was an error loading the image.")
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(.rect(cornerRadius: 16))
                    
                    VStack(alignment: .leading) {
                        Text(result.trackName).fontDesign(.monospaced)
                        Text(result.collectionName).font(.callout.bold())
                    }
                }
            }
        }
        .task {
             await fetchData()
        }
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invaild URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
            
        } catch {
            print("Invalid Data")
        }
    }
}

#Preview {
    ContentView()
}
