//
//  Practice.swift
//  CupcakeCorner
//
//  Created by Hafizur Rahman on 10/12/25.
//

import SwiftUI

@Observable
class User: Codable {
    enum CodingKeys: String, CodingKey {
        case _name = "name"
    }
    
    var name = "Hafiz"
}


struct Practice: View {
    var body: some View {
        Button("Encode", action: encodeData)
    }
    
    func encodeData() {
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }
}

#Preview {
    Practice()
}
