import XCTest
import class Foundation.Bundle

@testable import SwiftEureka

// issue around the mocking shows up on OSX, so fix these tests to Linux for now
#if os(Linux)

@available(iOS 13.0.0, *)
final class SwiftEurekaTests: XCTestCase {
    func testDeserialiseApplicationsResponse() throws {
        // guard #available(macOS 10.13, *) else {
        //     return
        // }

        guard let path = Bundle.module.url(forResource: "findAll", withExtension: "json") else {
            XCTFail("Missing file: applications.json")
            return
        }

        let json = try Data(contentsOf: path)

        let wrapper = try JSONDecoder().decode(ApplicationsWrapper.self, from: json)
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

    func testFindAll() async throws {
        let session = URLSessionMock(jsonFileName: "findAll")

        let svc =  EurekaClient(baseUrl: URL(string: "http://192.168.0.1:8761")!,
            logger: nil, session: session)

        do {
            let response = try await svc.findAll()
            if response == nil {
                XCTFail()    
            }

            let applications = response!

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
        catch {
            print("Unexpected error \(error)")
        }
    }

}

#endif