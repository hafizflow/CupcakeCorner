import SwiftUI

struct AddressView: View {
    @Binding var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.address.name).submitLabel(.next)
                TextField("StreetAddress", text: $order.address.streetAddress).submitLabel(.next)
                TextField("City", text: $order.address.city).submitLabel(.next)
                TextField("Zip", text: $order.address.zip).submitLabel(.done)
            }
            
            Section {
                NavigationLink("CheckOut") {
                    CheckOutView(order: $order)
                }
            }
            .disabled(order.address.isValidAddress == false)
        }
        .navigationTitle("Address")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: .constant(Order()))
}
