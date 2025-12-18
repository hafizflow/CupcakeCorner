import SwiftUI

struct AddressView: View {
    @Binding var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name).submitLabel(.next)
                TextField("StreetAddress", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink("CheckOut") {
                    CheckOutView(order: $order)
                }
            }
            .disabled(order.isValidAddress == false)
        }
        .navigationTitle("Address")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: .constant(Order()))
}
