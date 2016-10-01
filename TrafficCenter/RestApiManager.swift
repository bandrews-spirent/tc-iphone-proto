//
//  RestApiManager.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/26/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

typealias ServiceResponse = (AnyObject?, Error?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    func makeHTTPGetRequest(url: URL, headers: [String: String]?, onCompletion: ServiceResponse) {
        var req = URLRequest(url: url)
        if headers != nil {
            for (header, val) in headers! {
                req.addValue(val, forHTTPHeaderField: header)
            }
        }

        makeRequest(req: req, onCompletion: onCompletion)
    }
    
    func makeHTTPPostRequest(url: URL, body: [String: String]?, headers: [String: String]?, onCompletion: ServiceResponse) {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if body != nil {
            do {
                req.httpBody = try JSONSerialization.data(withJSONObject: body!, options: JSONSerialization.WritingOptions.prettyPrinted)
            }
            catch let err {
                onCompletion(nil, err)
                return
            }
        }
        
        if headers != nil {
            for (header, val) in headers! {
                req.addValue(val, forHTTPHeaderField: header)
            }
        }
        
        makeRequest(req: req, onCompletion: onCompletion)
    }
    
    func makeRequest(req: URLRequest, onCompletion: ServiceResponse) {
        let session = URLSession.shared
        let task = session.dataTask(with: req, completionHandler: {data, response, error -> Void in
            if error != nil {
                onCompletion(nil, error)
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                onCompletion(jsonResult, error)
            }
            catch let err {
                onCompletion(nil, err)
            }
        })
        task.resume()
    }
}
