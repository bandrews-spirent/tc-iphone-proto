//
//  Orion.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/26/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

typealias DictServiceResponse = ([String: AnyObject], Error?) -> Void
typealias ArrayServiceResponse = (Array<AnyObject>, Error?) -> Void
typealias BoolServiceResponse = (Bool, Error?) -> Void

class Orion {
    
    static let baseUrl = URL(string: "https://spirent.oriontest.net")
    static let authPath = "/api/iam/oauth2/token"
    static let appInstancesPath = "/api/inv/application-instances"
    static let tcAppId = "41ec3554ece54aa8a2540ae2483de9fc"
    
    // FIXME Hardcoded spirent.oriontest.net orgId
    static let orgId = "c49638a625374b95a254d42dda06ad0b"
    
    var token = ""
    
    func signIn(username: String, password: String, onComplete: DictServiceResponse) {
        let body = ["grant_type" : "password",
                    "username" : username,
                    "password" : password,
                    "scope" : Orion.orgId]
        let url = URL(string: Orion.authPath, relativeTo: Orion.baseUrl)!
        RestApiManager.sharedInstance.makeHTTPPostRequest(url: url, body: body, headers: nil, onCompletion: { data, err in
            if err != nil {
                onComplete([String: AnyObject](), err)
                return
            }

            let dataDict = data as! [String: AnyObject]
            if let accessToken = dataDict["access_token"] {
                // Save token for future requests.
                self.token = accessToken as! String
            }                    

            onComplete(dataDict, err)
        })
    }
    
    func listTrafficCenterApplicationInstances(onComplete: ArrayServiceResponse) {
        // TODO n=50 doesn't seem to have an affect. 25 instances are returned even
        // though there are definitely way more than that. Why???
        let path = Orion.appInstancesPath + "?application_id=\(Orion.tcAppId)&n=50"
        let headers = ["Authorization" : "Bearer " + token,
                       "X-Spirent-Api-Version" : "1",
                       "Accept" : "application/json"]
        let url = URL(string: path, relativeTo: Orion.baseUrl)!
        RestApiManager.sharedInstance.makeHTTPGetRequest(url: url, headers: headers, onCompletion: { data, err in
            if err != nil {
                onComplete([], err)
                return
            }
            
            onComplete(data as! Array<AnyObject>, err)
        })
    }
}

