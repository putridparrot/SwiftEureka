public struct Port: Codable {
    var number: UInt = 0
    var enabled: Bool = true

    public init(number: UInt, enabled: Bool) {
        self.number = number
        self.enabled = enabled
    }

    private enum CodingKeys: String, CodingKey {
        case number = "$", enabled = "@enabled"
    }
}