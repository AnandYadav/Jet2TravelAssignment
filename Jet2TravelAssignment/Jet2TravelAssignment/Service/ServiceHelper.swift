//
//  ServiceHelper.swift
//  Jet2TravelAssignment
//
//  Created by Anand Yadav on 09/06/20.
//  Copyright © 2020 Anand Yadav. All rights reserved.
//

import UIKit
let baseURL = URL(string:"https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1")!

public enum APIDetails : String {
    case APIScheme     = "https"
    case APIHost    = "5e99a9b1bc561b0016af3540.mockapi.io"
    case APIPath     = "/jet2/api/v1"
}

enum ServiceHelper
{
    case getArticles(parameters: [String:Any])
    
    var method: HTTPMethod {
        switch self {
        case .getArticles:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getArticles:
            return "/blogs"
        }
    }
    
    var urlComponent:URLComponents {
            var components = URLComponents()
            components.scheme = APIDetails.APIScheme.rawValue
            components.host   = APIDetails.APIHost.rawValue
            components.path = APIDetails.APIPath.rawValue + path
            components.queryItems = [URLQueryItem]()

            switch self {
            case .getArticles(let parameters):
                if !parameters.isEmpty {
                    for (key, value) in parameters {
                        let queryItem = URLQueryItem(name: key, value: "\(value)")
                        components.queryItems!.append(queryItem)
                    }
                }
            }
            return components
        }
        
    func asURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        print(urlRequest)
        return urlRequest
    }
}

public enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

struct Response {
    var response: URLResponse?
    var httpStatusCode: Int = 0
    //var headers = RestEntity()

    init(fromURLResponse response: URLResponse?) {
        guard let response = response else { return }
        self.response = response
        httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
    }
}

struct Results {
    var data: Data?
    var response: Response?
    init(withData data: Data?, response: Response?) {
        self.data = data
        self.response = response
    }
}

extension Decodable {
    static func map(JSONData:Data) -> Self? {
        debugPrint(JSONData)

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let utf8Data = String(decoding: JSONData, as: UTF8.self).data(using: .utf8)
            return try decoder.decode(Self.self, from: utf8Data!)
        } catch let error {
            print(error)
            return nil
        }
    }
}

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self? {
        do {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8)
            return try decoder.decode(Self.self, from: utf8Data!)
        } catch let error {
            print(error)
            throw error
        }
    }
}

