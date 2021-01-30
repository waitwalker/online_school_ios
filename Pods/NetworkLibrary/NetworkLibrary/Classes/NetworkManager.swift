
//
//  NetworkManager.swift
//
//
//  Created by waitwalker on 2021/1/23.
//

import UIKit
import Alamofire
import Foundation
import HandyJSON


import UIKit
import HandyJSON



/// 接口API
public class ApiConst {
    
    
    /// 通用URL
    static let baseURL: String = "https://school.etiantian.com/"
    
    /// 登录接口
    public static let login: String = baseURL + "authentication-center/authentication/login?"
    
    /// 获取验证码接口
    public static let code: String = baseURL + "api-cloudaccount-service/api/user/sms"
    
    /// 注册接口
    public static let register: String = baseURL + "api-cloudaccount-service/api/user/register"
    
    /// 忘记密码接口
    public static let forget_password: String = baseURL + "api-cloudaccount-service/api/user/password"
}








/// 网络管理类
public class NetworkManager: NSObject {
    
    public typealias MTTResponse<T> = (T)->Void
    
    /// 初始化
    private override init() {
        
    }
    
    /// 单例变量
    public static let sharedInstance = NetworkManager()
    
    // 全局网络状态
    public var networkStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .notReachable
    
    
    /// 全局网络请求头token
    public var bearerToken: String = ""
    
    
    
    /// get请求方法
    public func getRequest(_ convertible: URLConvertible,
                    parameters: Parameters? = nil,
                    networkResponse: @escaping MTTResponse<BaseModel>) -> Void {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(NetworkManager.sharedInstance.bearerToken)",
            "Accept": "application/json",
        ]
        var url: String = "\(convertible)"
        if url == ApiConst.login {
            url = url + mapToQuery(parameters!)
        }
        
        print("\(url)")
        
        baseRequest(url, apiType: "\(convertible)", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, networkResponse: networkResponse)
    }
    
    /// post请求方法
    public func postRequest(_ convertible: URLConvertible,
                    parameters: Parameters? = nil,
                    networkResponse: @escaping MTTResponse<BaseModel>) -> Void {
        
        /// appid 相关私有变量
        let appId: String = "2F5EE5930505950FA5D0F215171C15F9"
        let appSecret: String = "832E7959E349487D043D1561894AFD74"
        let appE: String = "\(appId):\(appSecret)"
        let data = appE.data(using: .utf8)
        
        
        let base64EncoderString: String = String(data: (data?.base64EncodedData())!, encoding: .utf8)!
        
        var headers: HTTPHeaders = []
        var url: String = "\(convertible)"
        if url == ApiConst.login {
            headers = [
                "Authorization": "Basic \(base64EncoderString)",
                "Accept": "application/json",
            ]
            url = url + mapToQuery(parameters!)
        } else if url == ApiConst.register {
            headers = [
                "Authorization": "Basic \(base64EncoderString)",
                "Accept": "application/json",
            ]
        } else {
            headers = [
                "Authorization": "Bearer \(NetworkManager.sharedInstance.bearerToken)",
                "Accept": "application/json",
            ]
        }
        
        
        print("\(url)")
        
        baseRequest(url, apiType: "\(convertible)", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers, networkResponse: networkResponse)
    }

    
    /// 基类请求方法
    public func baseRequest(_ convertible: URLConvertible,
                     apiType: String,
                     method: HTTPMethod = .get,
                     parameters: Parameters? = nil,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: HTTPHeaders? = nil,
                     networkResponse: @escaping MTTResponse<BaseModel>
                     ) -> Void {
        
        if NetworkManager.sharedInstance.networkStatus == .unknown || NetworkManager.sharedInstance.networkStatus == .notReachable {
            let baseModel = BaseModel()
            baseModel.code = -701;
            baseModel.msg = "网络不可用或已断开"
            networkResponse(baseModel)
            return
        }
        
        AF.request(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: nil) { (urlRequest) in
            // 设置超时时间
            urlRequest.timeoutInterval = 20
        }.response { [self] (res) in
            print(res.result)
            print(res.response?.statusCode as Any)
            switch res.result {
            case .success( _):
                if let statusCode = res.response?.statusCode {
                    print("状态码:\(statusCode)")
                    if statusCode == 200 || statusCode == 401 {
                        do {
                            let jsonObj = try JSONResponseSerializer().serialize(request: res.request, response: res.response, data: res.data, error: res.error)
                            handleResponse(apiType, responseObj: jsonObj, code: statusCode, response: networkResponse)
                            
                        } catch {
                            print("\(error)")
                            let baseModel = BaseModel()
                            baseModel.code = -601;
                            baseModel.msg = "解析错误"
                            networkResponse(baseModel)
                        }
                    } else if statusCode == 403 {
                        
                    } else if statusCode == 500 {
                        
                    }
                    
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -602;
                    baseModel.msg = "状态码获取错误"
                    networkResponse(baseModel)
                }
            case .failure(let error):
                print("响应失败的错误:\(error.localizedDescription)")
            }
        }
    }
    
    /// 将字典key=value格式拼接
    public func mapToQuery(_ parameters: [String : Any]) -> String {
        var list: [String] = []
        
        for (key, value) in parameters {
            print("key:\(key); value:\(value)")
            list.append("\(key)=\(value)")
        }
        return list.joined(separator: "&")
    }
    
    /// 处理response
    private func handleResponse(_ apiType: String, responseObj: Any, code: Int, response: @escaping MTTResponse<BaseModel>) -> Void {
        
        let jsonObjType: String = String(describing: type(of: responseObj))
        print("jsonObjType:\(jsonObjType)")
            
        switch apiType {
        case ApiConst.login:
            
            if jsonObjType.contains("Array") {
                /// 数组类型
                
            } else if jsonObjType.contains("Dictionary") {
                
                /// 字典类型
                if let model = LoginModel.deserialize(from: (responseObj as! Dictionary)) {
                    print("转换后的model:\(model)")
                    model.code = code == 200 ? 1 : code
                    response(model)
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -601;
                    baseModel.msg = "解析错误"
                    response(baseModel)
                }
            } else if jsonObjType.contains("String") {
                /// 字符串类型
                if let model = LoginModel.deserialize(from: (responseObj as! String)) {
                    print("转换后的model:\(model)")
                    model.code = code == 200 ? 1 : code
                    response(model)
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -601;
                    baseModel.msg = "解析错误"
                    response(baseModel)
                    
                }
            }
            break
            
        case ApiConst.register:
            
            if jsonObjType.contains("Array") {
                /// 数组类型
                
            } else if jsonObjType.contains("Dictionary") {
                
                /// 字典类型
                if let model = RegisterModel.deserialize(from: (responseObj as! Dictionary)) {
                    print("转换后的model:\(model)")
                    response(model)
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -601;
                    baseModel.msg = "解析错误"
                    response(baseModel)
                }
            } else if jsonObjType.contains("String") {
                /// 字符串类型
                if let model = RegisterModel.deserialize(from: (responseObj as! String)) {
                    print("转换后的model:\(model)")
                    model.code = code == 200 ? 1 : code
                    response(model)
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -601;
                    baseModel.msg = "解析错误"
                    response(baseModel)
                    
                }
            }
            break
            
        case ApiConst.code:
            
            if jsonObjType.contains("Array") {
                /// 数组类型
                
            } else if jsonObjType.contains("Dictionary") {
                
                /// 字典类型
                if let model = CodeModel.deserialize(from: (responseObj as! Dictionary)) {
                    print("转换后的model:\(model)")
                    response(model)
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -601;
                    baseModel.msg = "解析错误"
                    response(baseModel)
                }
            } else if jsonObjType.contains("String") {
                /// 字符串类型
                if let model = CodeModel.deserialize(from: (responseObj as! String)) {
                    print("转换后的model:\(model)")
                    model.code = code == 200 ? 1 : code
                    response(model)
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -601;
                    baseModel.msg = "解析错误"
                    response(baseModel)
                    
                }
            }
            break
            
        case ApiConst.forget_password:
            
            if jsonObjType.contains("Array") {
                /// 数组类型
                
            } else if jsonObjType.contains("Dictionary") {
                
                /// 字典类型
                if let model = ForgetPasswordModel.deserialize(from: (responseObj as! Dictionary)) {
                    print("转换后的model:\(model)")
                    response(model)
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -601;
                    baseModel.msg = "解析错误"
                    response(baseModel)
                }
            } else if jsonObjType.contains("String") {
                /// 字符串类型
                if let model = ForgetPasswordModel.deserialize(from: (responseObj as! String)) {
                    print("转换后的model:\(model)")
                    model.code = code == 200 ? 1 : code
                    response(model)
                } else {
                    let baseModel = BaseModel()
                    baseModel.code = -601;
                    baseModel.msg = "解析错误"
                    response(baseModel)
                }
            }
            break
            
        default:
            break
        }
    }
    
    
}
