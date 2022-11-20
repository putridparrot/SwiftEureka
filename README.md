# SwiftEureka

Swift library for working with netflix/spring Eureka

This is, by design, a simple Eureka Client package. Polling of the server is not implemented, nor is caching etc.

The package uses async/await for public facing API's

Sample of creating an InstanceInfo and using the EurekaClient to register the instance with Eureka

# API

## Init

To initialize an instance of the EurekaClient we pass in the URL of the Eureka server and optionally
supply a Logger. If a Logger is supplied then the EurekaClient will use it to log service call information. If no logger is supplied then nothing is logged (as I'm sure you'd expect).

_We currently use the swift-log package for logging._

```swift
let client = EurekaClient(
    baseUrl: URL(string: "http://192.168.0.88:8761")!, 
    logger: Logger(label: "com.putridparrot.MyApp"))
```

## Register

To register your application with Eureka, use the following _register_ method, passing in the 
_InstanceInfo_ for your application

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

do {
    try await client.register(instanceInfo: instance)
}
catch {
   print("Unexpected error \(error)")
}
```

## Unregister

To unregister and remove your application's details from Eureka, use the unregister method. You'll need
to pass the _appId_ as registered using _instance.app_ in your _InstanceInfo_. Also the specific _instanceId_ as per _instance.hostName_

```swift
do {
    try await client.unregister(appId: "SWIFT-EUREKA", instanceId: "myhost")
}
catch {
   print("Unexpected error \(error)")
}
```

## findAll

If your application either need to call the Eureka server and get an array of the registered application, use _findAll_. This will return the registered application name's and all the instance info. for them.

```swift
do {
    let applications = try await client.findAll()

    print("List of Applications")
    for application in applications!.application {
        print(application.name)
    }}
catch {
   print("Unexpected error \(error)")
}
```

The return is an _Applications_ type which contains some Eureka spoecific information along with an array of _Application_types. The _Application_ type includes the application name and an array of registered _InstanceInfo_ for the application name.

## find

In most scenario's an application that wants to find instances within Eureka will simply wish to find by _appId_ OR _appId_ and _instanceId_. The _find_ method allows us to do just that

```swift
do {
    let application = try await client.find(appId)
}
catch {
   print("Unexpected error \(error)")
}
```

## sendHeartBeat

Send a heart beat to Eureka

```swift
do {
    try await client.sendHeartBeat(appId: "SWIFT-EUREKA", instanceId: "myhost")
}
catch {
   print("Unexpected error \(error)")
}
```

## takeOutOfService

Mark your service as "out of service"

```swift
do {
    try await client.takeOutOfService(appId: "SWIFT-EUREKA", instanceId: "myhost")
}
catch {
   print("Unexpected error \(error)")
}
```

## moveInstanceIntoService

Mark your service as UP returning it into service

```swift
do {
    try await client.moveInstanceIntoService(appId: "SWIFT-EUREKA", instanceId: "myhost")
}
catch {
   print("Unexpected error \(error)")
}
```

## matchVipAddress


