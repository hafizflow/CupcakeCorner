import SwiftUI


struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Special Request", isOn: $order.specialRequestEnabled)
                    
                    if order.specialRequestEnabled {
                        Toggle("Add Sprinkles", isOn: $order.addSprinkles)
                        Toggle("Add Extra Frosting", isOn: $order.extraFrosting)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
    
}

#Preview {
    ContentView()
}
