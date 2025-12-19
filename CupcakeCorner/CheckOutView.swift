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
    
    @State private var errorMessage = ""
    @State private var showError = false
    
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
        .alert("Chekout Failed", isPresented: $showError) {
        } message: {
            Text(errorMessage)
        }
        
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode")
            return
        }
        
        let url = URL(string: "https://echo.zuplo.io/my/path")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedResponse = try JSONDecoder().decode(EchoResponse<Order>.self, from: data)
            let decodedOrder = decodedResponse.body
            
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcake is on the way!"
            showingConfirmation = true
        } catch {
            print("Checkout failed \(error.localizedDescription)")
            errorMessage = "Some thing went wrong: \(error.localizedDescription)"
            showError = true
        }
        
    }
}

#Preview {
    CheckOutView(order: .constant(Order()))
}
