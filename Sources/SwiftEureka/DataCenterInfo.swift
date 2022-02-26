struct DataCenterInfo: Codable {
    var name: DataCenterName = DataCenterName.myown
    var cls: String = "com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo"

    private enum CodingKeys: String, CodingKey {
        case name, cls = "@class"
    }
}