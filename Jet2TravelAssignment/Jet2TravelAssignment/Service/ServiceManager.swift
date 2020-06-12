//
//  ServiceManager.swift
//  Jet2TravelAssignment
//
//  Created by Anand Yadav on 09/06/20.
//  Copyright © 2020 Anand Yadav. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    static func getArticles(param: [String:Any]?, success: @escaping (_ response: Results?) -> Void,
                         failure: @escaping (_ error: Error?) -> Void) {
        
        BaseService.sharedInstance.apiRequest(urlRequest: ServiceHelper.getArticles(parameters: param!).asURLRequest(), success: { (results) in
            success(results)
        }) { (error) in
            failure(error)
        }
    }
}
