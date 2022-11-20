import XCTest
import class Foundation.Bundle

@testable import SwiftEureka

final class SwiftEurekaTests: XCTestCase {
    func testDeserialiseApplicationsResponse() throws {
        // guard #available(macOS 10.13, *) else {
        //     return
        // }
        let json = "{\"applications\":{\"versions__delta\":\"1\",\"apps__hashcode\":\"UP_1_\",\"application\":[{\"name\":\"SWIFT-EUREKA\",\"instance\":[{\"hostName\":\"myhost\",\"app\":\"SWIFT-EUREKA\",\"ipAddr\":\"10.0.0.10\",\"status\":\"UP\",\"overriddenStatus\":\"UNKNOWN\",\"port\":{\"$\":8080,\"@enabled\":\"true\"},\"securePort\":{\"$\":8443,\"@enabled\":\"false\"},\"countryId\":1,\"dataCenterInfo\":{\"@class\":\"com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo\",\"name\":\"MyOwn\"},\"leaseInfo\":{\"renewalIntervalInSecs\":30,\"durationInSecs\":90,\"registrationTimestamp\":1668935397689,\"lastRenewalTimestamp\":1768935397689,\"evictionTimestamp\":1120,\"serviceUpTimestamp\":1668935396936},\"metadata\":{\"@class\":\"java.util.Collections$EmptyMap\"},\"homePageUrl\":\"http://myservice:8080\",\"statusPageUrl\":\"http://myservice:8080/status\",\"healthCheckUrl\":\"http://myservice:8080/healthcheck\",\"vipAddress\":\"myservice\",\"secureVipAddress\":\"secure-myservice\",\"isCoordinatingDiscoveryServer\":\"false\",\"lastUpdatedTimestamp\":\"1668935397689\",\"lastDirtyTimestamp\":\"1668935396856\",\"actionType\":\"ADDED\"}]}]}}"

        let wrapper = try JSONDecoder().decode(ApplicationsWrapper.self, from: json.data(using: .utf8)!)
        let applications = wrapper.applications

        XCTAssertEqual(applications.versions__delta, "1")
        XCTAssertEqual(applications.apps__hashcode, "UP_1_")
        XCTAssertEqual(applications.application.count, 1)

        let application = applications.application[0];
        XCTAssertEqual(application.name, "SWIFT-EUREKA")
        XCTAssertEqual(application.instance.count, 1)

        let instance = application.instance[0];
        XCTAssertEqual(instance.hostName, "myhost")
        XCTAssertEqual(instance.app, "SWIFT-EUREKA")
        XCTAssertEqual(instance.ipAddr, "10.0.0.10")
        XCTAssertEqual(instance.status, .up)
        XCTAssertEqual(instance.overriddenStatus, .unknown)
        XCTAssertNotNil(instance.port)
        XCTAssertEqual(instance.port?.number, 8080)
        XCTAssertTrue(instance.port!.enabled)
        XCTAssertNotNil(instance.securePort)
        XCTAssertEqual(instance.securePort?.number, 8443)
        XCTAssertFalse(instance.securePort!.enabled)
        XCTAssertEqual(instance.countryId, 1)
        XCTAssertNotNil(instance.dataCenterInfo)
        XCTAssertEqual(instance.dataCenterInfo?.cls, "com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo")
        XCTAssertEqual(instance.dataCenterInfo?.name, .myown)
        XCTAssertNotNil(instance.leaseInfo)
        XCTAssertEqual(instance.leaseInfo!.renewalIntervalInSecs, 30)
        XCTAssertEqual(instance.leaseInfo!.durationInSecs, 90)
        XCTAssertEqual(instance.leaseInfo!.registrationTimestamp, 1668935397689)
        XCTAssertEqual(instance.leaseInfo!.lastRenewalTimestamp, 1768935397689)
        XCTAssertEqual(instance.leaseInfo!.evictionTimestamp, 1120)
        XCTAssertEqual(instance.leaseInfo!.serviceUpTimestamp, 1668935396936)
        XCTAssertNotNil(instance.metadata)
        XCTAssertEqual(instance.homePageUrl, "http://myservice:8080")
        XCTAssertEqual(instance.statusPageUrl, "http://myservice:8080/status")
        XCTAssertEqual(instance.healthCheckUrl, "http://myservice:8080/healthcheck")
        XCTAssertEqual(instance.vipAddress, "myservice")
        XCTAssertEqual(instance.secureVipAddress, "secure-myservice")
        XCTAssertNotNil(instance.isCoordinatingDiscoveryServer)
        XCTAssertFalse(instance.isCoordinatingDiscoveryServer!)
        XCTAssertEqual(instance.lastUpdatedTimestamp, 1668935397689)
        XCTAssertEqual(instance.lastDirtyTimestamp, 1668935396856)
        XCTAssertEqual(instance.actionType, .added)
    }
}
