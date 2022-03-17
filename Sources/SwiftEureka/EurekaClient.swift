import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import Logging

public struct Application: Decodable {
    public let name: String
    public let instance: [InstanceInfo]
}

public struct Applications: Decodable {
    public let versions__delta: String
    public let apps__hashcode: String
    public let application: [Application]
}

private struct ApplicationsWrapper: Decodable {
    public let applications: Applications
}

public enum HTTPError: Error {
    case transportError(Error)
    case httpError(Int)
}

public struct EurekaClient {
    private let baseUrl: URL
    private let logger: Logger

    /// Initialize an instance of the Eureka client
    /// 
    /// - Parameter baseUrl: The base URL, including port of the server
    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
        self.logger = Logger(label: "com.putridparrot.EurekaService")
    }

    /// Register an instance with the Eureka server
    /// 
    /// - Parameter instanceInfo: The instance information
    /// - Returns: Void
    public func register(instanceInfo: InstanceInfo) async throws -> Void {
        let json = try instanceInfo.toJson()
        let request = json.toDictionary()
        let httpBody = try JSONSerialization.data(withJSONObject: request!, options: [])

        let url = URL(string: "\(baseUrl)/eureka/apps/\(instanceInfo.app!)")
        let result = await dataTask(url: url!, httpMethod: "POST", httpBody: httpBody)
        if case .failure(let error) = result  {
            throw error            
        }
    }

    /// Unregister the application with app id, instance id from the Eureka Server
    ///
    /// - Parameters:
    ///   - appId: The application id of the service
    ///   - instanceId: The instance id of the service
    /// - Returns: Void
    public func unregister(appId: String, instanceId: String) async throws -> Void {
        let url = URL(string: "\(baseUrl)/eureka/apps/\(appId)/\(instanceId)")
        let result = await dataTask(url: url!, httpMethod: "DELETE", httpBody: nil)
        if case .failure(let error) = result  {
            throw error
        }
    }

    /// Find all instances registered with the Eureka Server
    /// 
    /// - Returns: 
    public func findAll() async -> Result<Applications?, Error> {
        let result = await findBy(appId: nil, instanceId: nil)
        switch result {
            case .success(let data): 
                do {
                    let wrapper = try JSONDecoder().decode(ApplicationsWrapper.self, from: data!)
                    return .success(wrapper.applications)
                } catch {
                    return .failure(error)
                }
            case .failure(let error): return .failure(error)
        }
        // return await findBy(appId: nil, instanceId: nil)
    }

    /// Find instance by app id
    /// 
    /// - Parameter appId: 
    /// - Returns: 
    public func find(appId: String) async -> Result<Data?, Error> {
        return await findBy(appId: appId, instanceId: nil)
    }

    /// Find instance by app id and instance id
    /// 
    /// - Parameters:
    ///   - appId: 
    ///   - instanceId: 
    /// - Returns: 
    public func find(appId: String, instanceId: String) async -> Result<Data?, Error> {
        return await findBy(appId: appId, instanceId: instanceId)
    }

    /// Find instance by instance id
    /// 
    /// - Parameter instanceId: 
    /// - Returns: 
    public func find(instanceId: String) async -> Result<Data?, Error> {
        return await findBy(appId: nil, instanceId: instanceId)
    }

    private func findBy(appId: String?, instanceId: String?) async -> Result<Data?, Error> {
        var url: String
        if appId == nil && instanceId != nil {
            url = "\(baseUrl)/eureka/instances/\(instanceId!)"
        } else {
            url = "\(baseUrl)/eureka/apps"
            if appId != nil {
                url = "\(url)/\(appId!)"
                if instanceId != nil {
                    url = "\(url)/\(appId!)/\(instanceId!)"
                }
            }
        }        
        return await dataTask(url: URL(string: url)!, httpMethod: "GET", httpBody: nil)
    }

    public func takeOutOfService(appId: String, instanceId: String) async -> Result<Data?, Error> {
        let url = URL(string: "\(baseUrl)/eureka/apps/\(appId)/\(instanceId)/status?value=OUT_OF_SERVICE")
        return await dataTask(url: url!, httpMethod: "PUT", httpBody: nil)
    } 

    public func returnToService(appId: String, instanceId: String) async -> Result<Data?, Error> {
        let url = URL(string: "\(baseUrl)/eureka/apps/\(appId)/\(instanceId)/status?value=UP")
        return await dataTask(url: url!, httpMethod: "DELETE", httpBody: nil)
    } 

    public func matchVipAddress(vipAddress: String) async -> Result<Data?, Error> {
        let url = URL(string: "\(baseUrl)/eureka/vips/\(vipAddress)")
        return await dataTask(url: url!, httpMethod: "GET", httpBody: nil)
    } 

    public func matchSecureVipAddress(secureVipAddress: String) async -> Result<Data?, Error> {
        let url = URL(string: "\(baseUrl)/eureka/svips/\(secureVipAddress)")
        return await dataTask(url: url!, httpMethod: "GET", httpBody: nil)
    } 

    private func dataTask(url: URL, httpMethod: String, httpBody: Data?) async -> Result<Data?, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if httpBody != nil {
            request.httpBody = httpBody
        } 

        return await dataTask(with: request)
    }

    private func dataTask(with request: URLRequest) async -> Result<Data?, Error> {
        await withCheckedContinuation { continuation in
            logger.info("Request: \(request)")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(returning: .failure(HTTPError.transportError(error)))
                    logger.error("\(error)")
                    return
                }

                let resp = response as! HTTPURLResponse
                let status = resp.statusCode
                guard (200...299).contains(status) else {
                    continuation.resume(returning: .failure(HTTPError.httpError(status)))
                    return
                }

                logger.info("Response: \(response!)")

                if let data = data {
                    let d = String.init(data: data, encoding: .utf8)
                    logger.debug("Data: \(d!)")
                }

                continuation.resume(returning: .success(data))
            }.resume()
        }
    }
}
