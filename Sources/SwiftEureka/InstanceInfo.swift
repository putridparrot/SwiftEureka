import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// See
// https://github.com/Netflix/eureka/blob/master/eureka-client/src/main/java/com/netflix/appinfo/InstanceInfo.java
// https://github.com/Netflix/eureka/wiki/Eureka-REST-operations

public struct InstanceInfo: Codable {
    public static let defaultStatusPageUrl = "/status"
    public static let defaultHealthPageUrl = "/healthckeck"
    public static let defaultSid: String = "na"
    public static let defaultPort: UInt = 7001
    public static let defaultSecurePort: UInt = 7002
    public static let defaultCountryId: UInt = 1 // US

    public var instanceId: String?
    public var app: String?
    public var appGroupName: String?
    public var ipAddr: String?
    public var sid: String? = defaultSid
    public var port: Port? = Port(number: defaultPort, enabled: true)
    public var securePort: Port? = Port(number: defaultSecurePort, enabled: true)
    public var homePageUrl: String?
    public var statusPageUrl: String?
    public var healthCheckUrl: String?
    public var secureHealthCheckUrl: String?
    public var vipAddress: String?
    public var secureVipAddress: String?
    public var countryId: UInt? = defaultCountryId
    public var dataCenterInfo: DataCenterInfo? = DataCenterInfo()
    public var hostName: String?
    public var status: InstanceStatus? = InstanceStatus.up
    public var overriddenStatus: InstanceStatus? = InstanceStatus.unknown
    public var leaseInfo: LeaseInfo?    
    public var isCoordinatingDiscoveryServer: Bool? = false
    public var metadata: [String:String]?
    public var lastUpdatedTimestamp: UInt64?
    public var lastDirtyTimestamp: UInt64?
    public var actionType: ActionType?
    public var asgName: String?
    public var isSecurePortEnabled: Bool? = false
    public var isUnsecurePortEnabled: Bool? = true

    public init() {        
    }    

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringValue = try container.decode(String.self, forKey: .isCoordinatingDiscoveryServer)
        switch stringValue {
            case "true": isCoordinatingDiscoveryServer = true
            default: isCoordinatingDiscoveryServer = false
        }
    }

}