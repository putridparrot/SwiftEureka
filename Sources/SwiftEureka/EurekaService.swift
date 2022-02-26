import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct EurekaService {
    let serverUrl: String

    func register(instanceInfo: InstanceInfo, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        let json = try instanceInfo.toJson()

        let data = json.toDictionary()
        let httpBody = try JSONSerialization.data(withJSONObject: data!, options: [])

        let url = URL(string: "\(serverUrl)/eureka/apps/\(instanceInfo.app!)")
        return try dataTask(url: url!, httpMethod: "POST", httpBody: httpBody, completionHandler: completionHandler)
    }

    func deregister(appId: String, instanceId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        let url = URL(string: "\(serverUrl)/eureka/apps/\(appId)/\(instanceId)")
        return try dataTask(url: url!, httpMethod: "DELETE", httpBody: nil, completionHandler: completionHandler)
    }

    func findAll(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        return try find(appId: nil, instanceId: nil, completionHandler: completionHandler)
    }

    func findByAppId(appId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        return try find(appId: appId, instanceId: nil, completionHandler: completionHandler)
    }

    func findByAppIdAndInstanceId(appId: String, instanceId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        return try find(appId: appId, instanceId: instanceId, completionHandler: completionHandler)
    }

    func findByInstanceId(instanceId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        return try find(appId: nil, instanceId: instanceId, completionHandler: completionHandler)
    }

    private func find(appId: String?, instanceId: String?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        var url: String
        if appId == nil && instanceId != nil {
            url = "\(serverUrl)/eureka/instances/\(instanceId!)"
        } else {
            url = "\(serverUrl)/eureka/apps"
            if appId != nil {
                url = "\(url)/\(appId!)"
                if instanceId != nil {
                    url = "\(url)/\(appId!)/\(instanceId!)"
                }
            }
        }        
        return try dataTask(url: URL(string: url)!, httpMethod: "GET", httpBody: nil, completionHandler: completionHandler)
    }

    func takeOutOfService(appId: String, instanceId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        let url = URL(string: "\(serverUrl)/eureka/apps/\(appId)/\(instanceId)/status?value=OUT_OF_SERVICE")
        return try dataTask(url: url!, httpMethod: "PUT", httpBody: nil, completionHandler: completionHandler)
    } 

    func returnToService(appId: String, instanceId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        let url = URL(string: "\(serverUrl)/eureka/apps/\(appId)/\(instanceId)/status?value=UP")
        return try dataTask(url: url!, httpMethod: "DELETE", httpBody: nil, completionHandler: completionHandler)
    } 

    func matchVipAddress(vipAddress: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        let url = URL(string: "\(serverUrl)/eureka/vips/\(vipAddress)")
        return try dataTask(url: url!, httpMethod: "GET", httpBody: nil, completionHandler: completionHandler)
    } 

    func matchSecureVipAddress(secureVipAddress: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        let url = URL(string: "\(serverUrl)/eureka/svips/\(secureVipAddress)")
        return try dataTask(url: url!, httpMethod: "GET", httpBody: nil, completionHandler: completionHandler)
    } 

    private func dataTask(url: URL, httpMethod: String, httpBody: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if httpBody != nil {
            request.httpBody = httpBody
        } 

        return URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    }
}
