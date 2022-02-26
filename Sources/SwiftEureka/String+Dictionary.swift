import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension String {
    func toDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
        }
        return nil
    } 
}
