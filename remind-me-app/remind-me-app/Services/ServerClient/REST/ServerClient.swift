//
//  ServerClient.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 27.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class ServerClient: NSObject {

    var serverURL = GlobalConstants.Networking.RemindMeServerURL
    let httpClient = AFHTTPRequestOperationManager()
   
    internal override init() {
        super.init()
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        setupSerializers()
    }
    
    func setupSerializers() {
        
        httpClient.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer
        
        let responseSerializer = AFJSONResponseSerializer() as AFJSONResponseSerializer
        let contentTypes = responseSerializer.acceptableContentTypes! as NSSet
        responseSerializer.acceptableContentTypes = contentTypes.setByAddingObject("application/json")
        
        httpClient.responseSerializer = responseSerializer
    }
    
    func executeGET(path: String, params: AnyObject?, success: (AnyObject -> Void), failure: (NSError -> Void)) {
        
        httpClient.GET(urlWithPath(path), parameters: params, success: {
            (operation, response) -> Void in
            success(response)
            }, failure: {
                (operation, error) -> Void in
                NSLog("\(error)")
                failure(error)
        })
    }
    
    func executePOST(path: String, params: AnyObject?, success: (AnyObject? -> Void), failure: (NSError? -> Void)) {
        
        httpClient.POST(urlWithPath(path), parameters: params, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            success(response)
            }) {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.localizedDescription)
                failure(error)
        }
    }
    
    func executeDELETE(path: String, params: AnyObject?, success: (AnyObject? -> Void), failure: (NSError? -> Void)) {
        
        httpClient.DELETE(urlWithPath(path), parameters: params, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            success(response)
            }) {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.localizedDescription)
                failure(error)
        }
    }
    
    func executePUT(path: String, params: AnyObject?, success: (AnyObject? -> Void), failure: (NSError? -> Void)) {
        
        httpClient.PUT(urlWithPath(path), parameters: params, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            success(response)
            }) {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                failure(error)
        }
    }
    
    private func urlWithPath(path: String) -> String {
        return "\(serverURL)\(path)"
    }
    
}
