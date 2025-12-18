//
//  CheckOutView.swift
//  CupcakeCorner
//
//  Created by Hafizur Rahman on 12/12/25.
//

import SwiftUI

struct CheckOutView: View {
    @Binding var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 233)
            
            Text("Total cost is \(order.cost, format: .currency(code: "usd"))")
                .font(.title)
            
            Button("Place order") {
                Task {
                    await placeOrder()
                }
            }
            .padding()
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you", isPresented: $showingConfirmation) {
        } message: {
            Text(confirmationMessage)
        }
        
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcake is on the way!"
            showingConfirmation = true
        } catch {
            print("Checkout failed \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    CheckOutView(order: .constant(Order()))
}
