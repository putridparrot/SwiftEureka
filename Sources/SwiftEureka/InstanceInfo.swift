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
    //public static let defaultSid: String = "na"
    public static let defaultPort: UInt = 7001
    public static let defaultSecurePort: UInt = 7002
    public static let defaultCountryId: UInt = 1 // US

    //public var instanceId: String?
    public var app: String?
    //public var appGroupName: String?
    public var ipAddr: String?
    //public var sid: String? = defaultSid
    public var port: Port? = Port(number: defaultPort, enabled: true)
    public var securePort: Port? = Port(number: defaultSecurePort, enabled: true)
    public var homePageUrl: String?
    public var statusPageUrl: String?
    public var healthCheckUrl: String?
    //public var secureHealthCheckUrl: String?
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
    //public var asgName: String?
    //public var isSecurePortEnabled: Bool? = false
    //public var isUnsecurePortEnabled: Bool? = true

    public init() {        
    }    

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        //instanceId = try container.decode(String?.self, forKey: .instanceId)
        app = try container.decode(String?.self, forKey: .app)
        //appGroupName = try container.decode(String?.self, forKey: .appGroupName)
        ipAddr = try container.decode(String?.self, forKey: .ipAddr)
        //sid = try container.decode(String?.self, forKey: .sid)
        port = try container.decode(Port?.self, forKey: .port)
        securePort = try container.decode(Port?.self, forKey: .securePort)
        homePageUrl = try container.decode(String?.self, forKey: .homePageUrl)
        statusPageUrl = try container.decode(String?.self, forKey: .statusPageUrl)
        healthCheckUrl = try container.decode(String?.self, forKey: .healthCheckUrl)
        //secureHealthCheckUrl = try container.decode(String?.self, forKey: .secureHealthCheckUrl)
        vipAddress = try container.decode(String?.self, forKey: .vipAddress)
        secureVipAddress = try container.decode(String?.self, forKey: .secureVipAddress)
        countryId = try container.decode(UInt?.self, forKey: .countryId)
        dataCenterInfo = try container.decode(DataCenterInfo?.self, forKey: .dataCenterInfo)
        hostName = try container.decode(String?.self, forKey: .hostName)
        status = try container.decode(InstanceStatus?.self, forKey: .status)
        overriddenStatus = try container.decode(InstanceStatus?.self, forKey: .overriddenStatus)
        leaseInfo = try container.decode(LeaseInfo?.self, forKey: .leaseInfo)

        let stringValue = try container.decode(String.self, forKey: .isCoordinatingDiscoveryServer)
        switch stringValue {
            case "true": isCoordinatingDiscoveryServer = true
            default: isCoordinatingDiscoveryServer = false
        }

        metadata = try container.decode([String:String]?.self, forKey: .metadata)
        do {
            lastUpdatedTimestamp = try container.decode(UInt64?.self, forKey: .lastUpdatedTimestamp)
        } catch DecodingError.typeMismatch {
            let tmp = try container.decode(String?.self, forKey: .lastUpdatedTimestamp)            
            lastUpdatedTimestamp = tmp != nil ? UInt64(tmp!) : 0
        }

        do {
            lastDirtyTimestamp = try container.decode(UInt64?.self, forKey: .lastDirtyTimestamp)
        } catch DecodingError.typeMismatch {
            let tmp = try container.decode(String?.self, forKey: .lastDirtyTimestamp)            
            lastDirtyTimestamp = tmp != nil ? UInt64(tmp!) : 0
        }

        actionType = try container.decode(ActionType?.self, forKey: .actionType)
        //asgName = try container.decode(String?.self, forKey: .asgName)
        //isSecurePortEnabled = try container.decode(Bool?.self, forKey: .isSecurePortEnabled)
        //isUnsecurePortEnabled = try container.decode(Bool?.self, forKey: .isUnsecurePortEnabled)
    }
}