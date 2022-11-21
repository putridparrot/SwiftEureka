import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import Logging

internal struct ApplicationsWrapper: Codable {
    public let applications: Applications
}

public struct Applications: Codable {
    public let versions__delta: String
    public let apps__hashcode: String
    public let application: [Application]
}

public struct Application: Codable {
    public let name: String
    public let instance: [InstanceInfo]
}

internal struct ApplicationWrapper: Codable {
    public let application: Application
}

internal struct InstanceWrapper: Codable {
    public let instance: InstanceInfo
}

public enum HTTPError: Error {
    case transportError(Error)
    case httpError(Int)
}

public struct EurekaClient {
    private let rootUrl = "eureka"

    private let session: URLSession;
    private let baseUrl: URL
    private let logger: Logger?

    /// Initialize an instance of the Eureka client
    /// 
    /// - Parameter baseUrl: The base URL, including the port of the server
    public init(baseUrl: URL, logger: Logger? = nil, session: URLSession = .shared) {
        self.baseUrl = baseUrl
        self.logger = logger
        self.session = session
    }

    /// Register an instance with the Eureka server
    /// 
    /// - Parameter instanceInfo: The instance information
    /// - Returns: Void
    public func register(instanceInfo: InstanceInfo) async throws -> Void {
        let json = try instanceInfo.toJson()
        let request = json.toDictionary()
        let httpBody = try JSONSerialization.data(withJSONObject: request!, options: [])

        let url = URL(string: "\(baseUrl)/\(rootUrl)/apps/\(instanceInfo.app!)")
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
        let url = URL(string: "\(baseUrl)/\(rootUrl)/apps/\(appId)/\(instanceId)")
        let result = await dataTask(url: url!, httpMethod: "DELETE", httpBody: nil)
        if case .failure(let error) = result  {
            throw error
        }
    }

    /// Sends an application instance heartbeat
    /// - Parameters:
    ///   - appId: 
    ///   - instanceId: 
    /// - Returns: 
    public func sendHeartBeat(appId: String, instanceId: String) async throws -> Void {
        let url = URL(string: "\(baseUrl)/\(rootUrl)/apps/\(appId)/\(instanceId)")
        let result = await dataTask(url: url!, httpMethod: "PUT", httpBody: nil)
        switch result {
            case .success: 
                return
            case .failure(let error): throw error
        }
    }

    /// Find all instances registered with the Eureka Server
    /// 
    /// - Returns: 
    public func findAll() async throws -> Applications? {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/apps", httpMethod: "GET")
        switch result {
            case .success(let data): 
                do {
                    let wrapper = try JSONDecoder().decode(ApplicationsWrapper.self, from: data!)
                    return wrapper.applications
                } catch {
                    throw error
                }
            case .failure(let error): throw error
        }
    }

    /// Find instance by app id
    /// 
    /// - Parameter appId: 
    /// - Returns: 
    public func find(appId: String) async throws -> Application? {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/apps/\(appId)", httpMethod: "GET")
        switch result {
            case .success(let data): 
                do {
                    let wrapper = try JSONDecoder().decode(ApplicationWrapper.self, from: data!)
                    return wrapper.application;
                } catch {
                    throw error
                }
            case .failure(let error): throw error
        }
    }

    /// Find instance by app id and instance id
    /// 
    /// - Parameters:
    ///   - appId: 
    ///   - instanceId: 
    /// - Returns: 
    public func find(appId: String, instanceId: String) async throws -> InstanceInfo? {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/apps/\(appId)/\(instanceId)", httpMethod: "GET")
        switch result {
            case .success(let data): 
                do {
                    let wrapper = try JSONDecoder().decode(InstanceWrapper.self, from: data!)
                    return wrapper.instance;
                } catch {
                    throw error
                }
            case .failure(let error): throw error
        }
    }

    /// Find instance by instance id
    /// 
    /// - Parameter instanceId: 
    /// - Returns: 
    public func find(instanceId: String) async throws -> InstanceInfo? {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/instances/\(instanceId)", httpMethod: "GET")
        switch result {
            case .success(let data): 
                do {
                    let wrapper = try JSONDecoder().decode(InstanceWrapper.self, from: data!)
                    return wrapper.instance;
                } catch {
                    throw error
                }
            case .failure(let error): throw error
        }
    }

    public func find(vipAddress: String) async throws -> Applications? {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/vips/\(vipAddress)", httpMethod: "GET")
        switch result {
            case .success(let data): 
                do {
                    let wrapper = try JSONDecoder().decode(ApplicationsWrapper.self, from: data!)
                    return wrapper.applications
                } catch {
                    throw error
                }
            case .failure(let error): throw error
        }
    } 

    public func find(secureVipAddress: String) async throws -> Applications? {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/svips/\(secureVipAddress)", httpMethod: "GET")
        switch result {
            case .success(let data): 
                do {
                    let wrapper = try JSONDecoder().decode(ApplicationsWrapper.self, from: data!)
                    return wrapper.applications
                } catch {
                    throw error
                }
            case .failure(let error): throw error
        }
    } 

    /// Update meta data for the application/instance
    /// - Parameters:
    ///   - appId: 
    ///   - instanceId: 
    ///   - key: 
    ///   - value: 
    /// - Returns: 
    public func updateMeta(appId: String, instanceId: String, key: String, value: String) async throws -> Void {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/apps/\(appId)/\(instanceId)/metadata?\(key)=\(value)", httpMethod: "PUT")
        if case .failure(let error) = result  {
            throw error
        }
    } 

    /// Mark the service as "Out of Service"
    /// - Parameters:
    ///   - appId: 
    ///   - instanceId: 
    /// - Returns: 
    public func takeOutOfService(appId: String, instanceId: String) async throws -> Void {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/apps/\(appId)/\(instanceId)/status?value=OUT_OF_SERVICE", httpMethod: "PUT")
        if case .failure(let error) = result  {
            throw error
        }
    } 

    /// Mark service as UP/return to service
    /// - Parameters:
    ///   - appId: 
    ///   - instanceId: 
    /// - Returns: 
    public func moveInstanceIntoService(appId: String, instanceId: String) async throws -> Void {
        let result = await serviceCall(url: "\(baseUrl)/\(rootUrl)/apps/\(appId)/\(instanceId)/status?value=UP", httpMethod: "DELETE")
        if case .failure(let error) = result  {
            throw error
        }
    } 

    private func serviceCall(url: String, httpMethod: String) async -> Result<Data?, Error> {
        logger?.debug("HttpMethod: \(httpMethod), URL: \(url)")
        return await dataTask(url: URL(string: url)!, httpMethod: httpMethod, httpBody: nil)
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
            logger?.debug("Request: \(request)")

            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(returning: .failure(HTTPError.transportError(error)))
                    logger?.error("\(error)")
                    return
                }

                let resp = response as! HTTPURLResponse
                let status = resp.statusCode
                
                logger?.debug("Response: Status code \(status)")

                guard (200...299).contains(status) else {                    
                    continuation.resume(returning: .failure(HTTPError.httpError(status)))
                    return
                }

                if let data = data {
                    logger?.debug("Response: \(String.init(data: data, encoding: .utf8) ?? "")")
                }

                continuation.resume(returning: .success(data))
            }.resume()
        }
    }

    // for debug purposes
    // private func logResponse(data: Data) {
    //     if let json = String(data: data, encoding: .utf8) {
    //         print("JSON Result")
    //         print("'\(json)'")
    //     }
    // }
}
