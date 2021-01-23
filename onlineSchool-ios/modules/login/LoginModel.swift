//
//  LoginModel.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/23.
//

import UIKit

/// 登录model
class LoginModel: BaseModel {
    var access_token: String = ""
    var refresh_token: String = ""
    var expiration: Int = 0
    var expiresIn: Int = 0
}
