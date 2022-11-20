import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    public var jsonFileName: String

    enum MockError: Error {       
        case pathError
        case unknown
    }


    init(jsonFileName: String) {
        self.jsonFileName = jsonFileName        
        super.init(configuration: URLSessionConfiguration.default)
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        guard let path = Bundle.module.url(forResource: jsonFileName, withExtension: "json") else {
            return URLSessionDataTaskMock {
                completionHandler(Data(base64Encoded: ""), nil, MockError.pathError)
            }
        }

        do {
            let json = try Data(contentsOf: path)

            return URLSessionDataTaskMock {
                completionHandler(json, HTTPURLResponse(url: path, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
            }
        } catch {
            return URLSessionDataTaskMock {
                completionHandler(Data(base64Encoded: ""), HTTPURLResponse(url: path, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
            }
        }
    }
}
