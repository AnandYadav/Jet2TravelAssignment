//
//  BaseService.swift
//  Jet2TravelAssignment
//
//  Created by Anand Yadav on 09/06/20.
//  Copyright © 2020 Anand Yadav. All rights reserved.
//

import UIKit

struct BaseService {
    static let sharedInstance = BaseService()
    
    private let session = URLSession.shared

    func apiRequest(urlRequest:URLRequest, success: @escaping (_ response: Results?)-> Void, failure: @escaping (_ error:Error?)-> Void) {

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                failure(error)
                return
            }
            guard let responseData = data, let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    failure(HTTPError.invalidResponse(data, response))
                    return
            }

            success(Results(withData: responseData, response: Response(fromURLResponse: httpResponse)))
        }
        task.resume()
    }
}

enum HTTPError: Error {
    case invalidURL
    case invalidData
    case invalidResponse(Data?, URLResponse?)
}

extension HTTPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString(
                "A server with the specified hostname could not be found.",
                comment: ""
            )
        case .invalidData:
        return NSLocalizedString(
            "Invalid response data.",
            comment: ""
        )
        case .invalidResponse:
            return NSLocalizedString(
                "Invalid response data",
                comment: ""
            )}
    }
}
