import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension InstanceInfo {

    // wraps the InstanceInfo into a Json Object
    struct RequestWrapper: Codable {
        var instance: InstanceInfo
    }

    public func toJson() throws -> String {
        let encoder = JSONEncoder();
        encoder.outputFormatting = .withoutEscapingSlashes
        let jsonData = try encoder.encode(RequestWrapper(instance: cloneAndInitialize(self)))
        return String(data: jsonData, encoding: String.Encoding.utf8)!;
    }    

    /// Creates a clone and ensure any initialization that needs to take
    /// place occurs
    /// - Parameter instance: 
    /// - Returns: 
    private func cloneAndInitialize(_ instance: InstanceInfo) -> InstanceInfo {
        var clone = InstanceInfo()
        clone.instanceId = instance.instanceId
        clone.sid = instance.sid ?? InstanceInfo.defaultSid
        clone.app = instance.app
        clone.ipAddr = instance.ipAddr
        clone.port = instance.port
        clone.securePort = instance.securePort
        clone.homePageUrl = instance.homePageUrl
        clone.statusPageUrl = instance.statusPageUrl
        clone.secureHealthCheckUrl = instance.secureHealthCheckUrl
        clone.vipAddress = instance.vipAddress
        clone.secureVipAddress = instance.secureVipAddress
        clone.countryCode = instance.countryCode
        clone.dataCenterInfo = instance.dataCenterInfo
        clone.hostName = instance.hostName
        clone.status = instance.status
        clone.overriddenStatus = instance.overriddenStatus
        clone.leaseInfo = instance.leaseInfo
        clone.isCoordinatingDiscoveryServer = instance.isCoordinatingDiscoveryServer
        // TBC clone.lastUpdatedTimestamp = 
        // TBC clone.lastDirtyTimestamp = 
        clone.actionType = instance.actionType
        clone.asgName = instance.asgName
        clone.metadata = instance.metadata == nil || instance.metadata!.count == 0 ? ["@class": "java.util.Collections$EmptyMap"] : instance.metadata

        return clone
    }
}
