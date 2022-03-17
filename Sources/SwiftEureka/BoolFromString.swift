@propertyWrapper
internal struct BoolFromString: Codable {
    public var wrappedValue: Bool? 

    public init(wrappedValue: Bool?) {
        self.wrappedValue = wrappedValue != nil ? wrappedValue : false
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        switch stringValue {
            case "true": wrappedValue = true
            default: wrappedValue = false
        }
    }
}