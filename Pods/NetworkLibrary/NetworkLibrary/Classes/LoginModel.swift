//
//  LoginModel.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/23.
//

import UIKit

/// 登录model
public class LoginModel: BaseModel {
    public var access_token: String = ""
    public var refresh_token: String = ""
    public var expiration: Int = 0
    public var expiresIn: Int = 0
}
