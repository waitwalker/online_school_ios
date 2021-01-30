//
//  BaseModel.swift
//  onlineSchool-ios
//
//  Created by waitwalker on 2021/1/21.
//

import UIKit
import HandyJSON

/// 基类model 用于数据的基本初始铺垫, 传参; 为子类提供
public class BaseModel: HandyJSON {
    /// 状态码
    /// -601解析错误; -602状态码获取错误
    /// -701网络不可用或已断开
    public var code: Int = 0
    public var msg: String = ""
    
    
    required public init() {}
}
