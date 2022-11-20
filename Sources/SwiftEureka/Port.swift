public struct Port: Codable {
    var number: UInt = 0
    var enabled: Bool = true

    private enum CodingKeys: String, CodingKey {
        case number = "$", enabled = "@enabled"
    }

    public init(number: UInt, enabled: Bool) {
        self.number = number
        self.enabled = enabled
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringValue = try container.decode(String.self, forKey: .enabled)
        switch stringValue {
            case "true": enabled = true
            default: enabled = false
        }

        do {
            number = try container.decode(UInt.self, forKey: .number)
        } catch DecodingError.typeMismatch {
            let tmp = try container.decode(String?.self, forKey: .number)            
            number = tmp != nil ? UInt(tmp!) ?? 0 : 0
        }
    }
}
