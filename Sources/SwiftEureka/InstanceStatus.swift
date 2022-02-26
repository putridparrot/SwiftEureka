public enum InstanceStatus: String, Codable {
    case up = "UP"
    case down = "DOWN"
    case starting = "STARTING"
    case out_of_service = "OUT_OF_SERVICE"
    case unknown = "UNKNOWN"
}