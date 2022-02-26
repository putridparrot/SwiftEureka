public struct LeaseInfo: Codable {
    var evictionDurationInSecs: UInt?

    public init(evictionDurationInSecs: UInt?) {
        self.evictionDurationInSecs = evictionDurationInSecs
    }
}
