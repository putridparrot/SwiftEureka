public struct LeaseInfo: Codable {
    public var renewalIntervalInSecs: UInt?
    public var durationInSecs: UInt?
    public var registrationTimestamp: UInt?
    public var lastRenewalTimestamp: UInt?
    public var evictionTimestamp: UInt?
    public var serviceUpTimestamp: UInt?
}
