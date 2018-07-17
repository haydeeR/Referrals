//
//  OAuthHandler.swift
//  Referrals
//
//  Created by Haydee Rodriguez on 7/17/18.
//  Copyright © 2018 Haydee Rodriguez. All rights reserved.
//

import Foundation
import Alamofire

class OAuthHandler: RequestAdapter {
    
    static var sessionManager = Server.manager
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    
    private let lock = NSLock()
    
    private var accessToken: String
    private var baseURLString: String
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(accessToken: String, baseURLString: String) {
        self.accessToken = accessToken
        self.baseURLString = baseURLString
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            print(urlRequest)
            return urlRequest
        }
        
        return urlRequest
    }
}
