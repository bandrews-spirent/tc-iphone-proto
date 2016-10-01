//
//  TrafficCenter.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/27/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class TrafficCenter {
    
    var ipAddr: String
    var baseUrl: String
    var testsUrl: URL
    var orionToken: String
    var token = ""
    
    init(ipAddr: String, orionToken: String) {
        self.ipAddr = ipAddr
        self.orionToken = orionToken
        self.baseUrl = "http://\(ipAddr)/traffic-center"
        self.testsUrl = URL(string: "\(self.baseUrl)/tests")!
    }
    
    func signIn(onComplete: DictServiceResponse) {
        let url = URL(string: "\(baseUrl)?expires_in=86400&access_token=\(orionToken)&refresh_token=\(orionToken)&return_token=yes")!
        RestApiManager.sharedInstance.makeHTTPGetRequest(url: url, headers: nil, onCompletion: { data, err in
            if err != nil {
                print("sign in error ---> \(err) \(url)")
                onComplete([String: AnyObject](), err)
                return
            }
            
            let dataDict = data as! [String: AnyObject]
            if let token = dataDict["token"] {
                // Save token for future requests.
                self.token = token as! String
            }
            
            onComplete(dataDict, err)
        })
    }
    
    func listTests(onComplete: ArrayServiceResponse) {
        RestApiManager.sharedInstance.makeHTTPGetRequest(url: testsUrl, headers: headers(), onCompletion: { data, err in
            if err != nil {
                onComplete([], err)
                return
            }
            
            onComplete(data as! Array<AnyObject>, err)
        })
    }
    
    func headers() -> [String: String] {
        return ["X-AuthToken" : token]
    }
    
    func startTest(id: String, onComplete: BoolServiceResponse) {
        let url = URL(string: testsUrl.absoluteString + "/\(id)/start")!
        RestApiManager.sharedInstance.makeHTTPPostRequest(url: url, body: nil, headers: headers(), onCompletion: { data, err in
            if err != nil {
                onComplete(false, err)
                return
            }
            
            let dataDict = data as! [String: AnyObject]
            if let state = dataDict["state"] as? String {
                if state == "Pending" {
                    onComplete(true, nil)
                    return
                }
            }
            
            onComplete(false, nil)
        })
    }
    
    func stopTest(id: String, onComplete: BoolServiceResponse) {
        let url = URL(string: testsUrl.absoluteString + "/\(id)/stop")!
        RestApiManager.sharedInstance.makeHTTPPostRequest(url: url, body: nil, headers: headers(), onCompletion: { data, err in
            if err != nil {
                onComplete(false, err)
                return
            }
            
            let dataDict = data as! [String: AnyObject]
            if let state = dataDict["state"] as? String {
                if state == "Pending" {
                    onComplete(true, nil)
                    return
                }
            }
            
            onComplete(false, nil)
        })
    }
    
    func getRunningTest(id: String, onComplete: DictServiceResponse) {
        let url = URL(string: "\(self.baseUrl)/running_tests/\(id)")!
        RestApiManager.sharedInstance.makeHTTPGetRequest(url: url, headers: headers(), onCompletion: { data, err in
            if err != nil {
                onComplete([String: AnyObject](), err)
                return
            }
            
            let dataDict = data as! [String: AnyObject]
            onComplete(dataDict, err)
        })
    }
    
    func getLatestReport(id: String, onComplete: DictServiceResponse) {
        // Well... this is very unfortunate to have to retrieve all the reports to get the latest. :(
        let url = URL(string: testsUrl.absoluteString + "/\(id)/reports?min_view=1")!
        RestApiManager.sharedInstance.makeHTTPGetRequest(url: url, headers: headers(), onCompletion: { data, err in
            if err != nil {
                onComplete([String: AnyObject](), err)
                return
            }
            
            if let reports = data as? Array<AnyObject> {
                if reports.count == 0 {
                    onComplete([String: AnyObject](), err)
                    return
                }
                onComplete(reports[0] as! [String: AnyObject], err)
            }
        })
    }
}
