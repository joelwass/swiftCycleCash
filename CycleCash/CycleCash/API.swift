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
    
    func signUp(username: String, password: String) {
    
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let urlRequest = requestWithMethod("POST", url: "https://cyclecash-api-prod.ppqmmfjpjt.us-west-2.elasticbeanstalk.com/api/v1/users", parameters: ["email":username, "password":password])
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {(data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                
                dispatch_async(dispatch_get_main_queue(), {
//                    let alertCtrl = UIAlertController(title: "Whoops!", message: "Looks like our server is under maintenance, hang tight and try logging in again in a few minutes.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    // Find the presented VC...
                    //      self.presentViewController(alertCtrl, animated: true, completion: nil)
                })
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                print(responseData)
//                let json = JSON(data: responseData)
//                if json["success"].bool == true {
//                    self.view.endEditing(true)
//                    
//                    UserSettings.sharedInstance.UserId = json["message"].int!
//                    self.finishLoggingIn()
//                } else {
//                    self.existing = false
//                    self.errorMessage.hidden = false
//                }
            })
        })
        task.resume()
    }
    
    func logIn(username: String, password: String) {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let urlRequest = requestWithMethod("POST", url: "http://cyclecash-api-prod.ppqmmfjpjt.us-west-2.elasticbeanstalk.com/api/v1/users/login", parameters: ["email":username, "password":password])
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {(data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                
                dispatch_async(dispatch_get_main_queue(), {
//                    let alertCtrl = UIAlertController(title: "Whoops!", message: "Looks like our server is under maintenance, hang tight and try logging in again in a few minutes.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    // Find the presented VC...
                    //      self.presentViewController(alertCtrl, animated: true, completion: nil)
                })
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                let json = JSON(data: responseData)
                print(json)
                //                let json = JSON(data: responseData)
                //                if json["success"].bool == true {
                //                    self.view.endEditing(true)
                //
                //                    UserSettings.sharedInstance.UserId = json["message"].int!
                //                    self.finishLoggingIn()
                //                } else {
                //                    self.existing = false
                //                    self.errorMessage.hidden = false
                //                }
            })
        })
        task.resume()    }
    
}


