//
//  NetworkManager.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/20.
//

import UIKit
import Alamofire
import Foundation

class NetworkManager: NSObject {
    func baseRequest() -> Void {
        
        
        let appId: String = "2F5EE5930505950FA5D0F215171C15F9"
        let appSecret: String = "832E7959E349487D043D1561894AFD74"
        
        let appE: String = "\(appId):\(appSecret)"
        let base64EncoderString: String = String(data: Data(base64Encoded: appE)!, encoding: .utf8)!
        
        
        let headers: HTTPHeaders = [
            "Authorization": base64EncoderString,
            "Accept": "application/json",
        ]
        
        
        AF.request("https://school.etiantian.com/authentication-center/authentication/login", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil) { (urlRequest) in
            // 设置超时时间
            urlRequest.timeoutInterval = 20
        }.response { (res) in
            print(res)
        }
    }
    
    static func mapToQuery(_ parameters: [String : Any]) -> String {
        for item in parameters {
            
        }
        return ""
    }
}
