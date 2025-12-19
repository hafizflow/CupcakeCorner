import Foundation

struct EchoResponse<T: Decodable>: Decodable {
    let body: T
}

struct Address: Codable {
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var isValidAddress: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStreetAddress = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedZip = zip.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty || trimmedStreetAddress.isEmpty || trimmedCity.isEmpty || trimmedZip.isEmpty {
            return false
        }
        return true
    }
}

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _address = "address"
    }
    
    static var types = ["Vanila", "Strawberry", "Chocolate", "Red Velvet"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    // Address
    var address: Address {
        didSet {
            if let encoded = try? JSONEncoder().encode(address) {
                UserDefaults.standard.set(encoded, forKey: "address")
            }
        }
    }
    
    init() {
        if let saveAddress = UserDefaults.standard.data(forKey: "address") {
            if let decoded = try? JSONDecoder().decode(Address.self, from: saveAddress) {
                address = decoded
                return
            }
        }
        address = Address()
    }
    
    var name: String {
        get { address.name }
        set { address.name = newValue }
    }
    
    var streetAddress: String {
        get { address.streetAddress }
        set { address.streetAddress = newValue }
    }
    
    var city: String {
        get { address.city }
        set { address.city = newValue }
    }
    
    var zip: String {
        get { address.zip }
        set { address.zip = newValue }
    }
    
    var isValidAddress: Bool {
        address.isValidAddress
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        cost += Decimal(type) / 2
        
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
    
        return cost
    }
}
