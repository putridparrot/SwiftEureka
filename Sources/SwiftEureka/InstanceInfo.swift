import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// See
// https://github.com/Netflix/eureka/blob/master/eureka-client/src/main/java/com/netflix/appinfo/InstanceInfo.java
// https://github.com/Netflix/eureka/wiki/Eureka-REST-operations

struct InstanceInfo: Codable {
    public static let defaultStatusPageUrl = "/status"
    public static let defaultHealthPageUrl = "/healthckeck"
    public static let defaultSid: String = "na"
    public static let defaultPort: UInt = 7001
    public static let defaultSecurePort: UInt = 7002
    public static let defaultCountryId: UInt = 1 // US

    var instanceId: String?
    var app: String?
    var appGroupName: String?
    var ipAddr: String?
    var sid: String? = defaultSid
    var port: Port? = Port(number: defaultPort, enabled: true)
    var securePort: Port? = Port(number: defaultSecurePort, enabled: true)
    var homePageUrl: String?
    var statusPageUrl: String?
    var healthCheckUrl: String?
    var secureHealthCheckUrl: String?
    var vipAddress: String?
    var secureVipAddress: String?
    var countryCode: UInt = defaultCountryId
    var dataCenterInfo: DataCenterInfo? = DataCenterInfo()
    var hostName: String?
    var status: InstanceStatus? = InstanceStatus.up
    var overriddenStatus: InstanceStatus? = InstanceStatus.unknown
    var leaseInfo: LeaseInfo?
    var isCoordinatingDiscoveryServer: Bool = false
    var metadata: [String:String]?
    var lastUpdatedTimestamp: UInt64?
    var lastDirtyTimestamp: UInt64?
    var actionType: ActionType?
    var asgName: String?

    var isSecurePortEnabled: Bool = false
    var isUnsecurePortEnabled: Bool = true

    init() {        
    }    
}
