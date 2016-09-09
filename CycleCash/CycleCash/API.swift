//
//  API.swift
//  CycleCash
//
//  Created by Joel Wasserman on 9/5/16.
//  Copyright © 2016 cyclecash. All rights reserved.
//

import UIKit

class API: NSObject {

    private static let singleton = API()
    
    class func sharedInstance() -> API {
        return singleton
    }

    func requestWithMethod(method: String, url: NSString, parameters:[String:AnyObject]?) -> NSMutableURLRequest {
        
        let jsonFileURL = NSURL(string: url as String)
        let urlRequest = NSMutableURLRequest(URL: jsonFileURL!)
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(parameters!, options: .PrettyPrinted)
            urlRequest.HTTPBody = jsonData
        } catch {
            print("error creating json data")
        }
        urlRequest.HTTPMethod = method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
    func signUp(username: String, password: String, completion: (result: JSON) -> Void) {
    
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let urlRequest = requestWithMethod("POST", url: "http://cyclecash-api-prod.ppqmmfjpjt.us-west-2.elasticbeanstalk.com/api/v1/users/", parameters: ["email":username, "password":password])
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {(data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                let json: JSON = "Error: did not receive data"
                completion(result: json)
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            let json = JSON(data: responseData)
            completion(result: json)
        })
        task.resume()
    }
    
    func logIn(username: String, password: String, completion: (result: JSON) -> Void) {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let urlRequest = requestWithMethod("POST", url: "http://cyclecash-api-prod.ppqmmfjpjt.us-west-2.elasticbeanstalk.com/api/v1/users/login/", parameters: ["email":username, "password":password])
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {(data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                let json: JSON = "Error: did not receive data"
                completion(result: json)
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            let json = JSON(data: responseData)
            completion(result: json)
        })
        task.resume()
    }
}


