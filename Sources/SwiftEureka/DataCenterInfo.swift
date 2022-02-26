public struct DataCenterInfo: Codable {
    var name: DataCenterName = DataCenterName.myown
    var cls: String = "com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo"

    public init() {        
    }

    public init(name: DataCenterName, cls: String) {
        self.name = name
        self.cls = cls
    }

    private enum CodingKeys: String, CodingKey {
        case name, cls = "@class"
    }
}