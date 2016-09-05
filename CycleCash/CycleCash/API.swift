//
//  API.swift
//  CycleCash
//
//  Created by Joel Wasserman on 9/5/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit
import AlamoFire

class API: NSObject {

    private static let singleton = API()
    
    class func sharedInstance() -> API {
        singleton.ensureManager()
        return singleton
    }
    
    private var defaultManager: Manager!
    func ensureManager() {
        if (defaultManager == nil) {
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
            defaultManager = Manager(configuration: configuration)
        }
    }
    
    func cancelAllRequests() {
        self.defaultManager.session.invalidateAndCancel()
        defaultManager = nil
    }

    func requestWithMethod(method: Alamofire.Method, url: NSURL, parameters:[String:AnyObject]?) -> Request {
        let headers = authenticationHeader()
        let req = AlamoFire.request(method, url, parameters: parameters, encoding: .URL, headers: headers)
        return req;
    }
    
    func signUp(username: String, password: String, firstname:String) {
    
        requestWithMethod(.POST, path: "/users", parameters: ["email":username, "password":password, "firstname":firstname])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    func logIn(username: String, password: String) {
        
        requestWithMethod(.POST, path: "/users/login", parameters: ["email":username, "password":password])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
}
