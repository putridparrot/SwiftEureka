struct Port: Codable {
    var number: UInt = 0
    var enabled: Bool = true

    private enum CodingKeys: String, CodingKey {
        case number = "$", enabled = "@enabled"
    }
}