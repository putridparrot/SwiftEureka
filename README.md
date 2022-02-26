# SwiftEureka

Swift library for working with netflix/spring Eureka

The following examples use _completion handlers_.

Sample of creating an InstanceInfo and using the EurekaService to register the instance with Eureka

```swift
var instance = InstanceInfo()
instance.hostName = "myhost"
instance.app = "SWIFT-EUREKA"
instance.vipAddress = "myservice"
instance.secureVipAddress = "myservice"
instance.ipAddr = "10.0.0.10"
instance.status = InstanceStatus.up
instance.port = Port(number: 8080, enabled: true)
instance.securePort = Port(number: 8443, enabled: true)
instance.healthCheckUrl = "http://myservice:8080/healthcheck"
instance.statusPageUrl = "http://myservice:8080/status"
instance.homePageUrl = "http://myservice:8080"

let svc = EurekaService(serverUrl: "http://192.168.1.1:8761")

try svc.register(instanceInfo: instance) { (data, response, error) in
    let result = String.init(data: data!, encoding: .utf8)
    print(result!)
}.resume()
```


