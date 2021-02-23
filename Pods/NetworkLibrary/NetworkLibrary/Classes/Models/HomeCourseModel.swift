//
//  HomeCourseModel.swift
//  NetworkLibrary
//
//  Created by waitwalker on 2021/2/1.
//

/// 首页智领/智学课model

import UIKit
import HandyJSON


public class HomeCourseModel: BaseModel {
    public var data: [HomeCourseDataModel] = []
    
}

public class HomeCourseDataModel: HandyJSON {
    public var currentIndex: Int = 10000
    public var isZhiLing: Bool = false
    public var subjectId: Int = 0
    public var subjectName: String = ""
    public var grades: [HomeCourseGradesModel] = []
    required public init() {}
}

public class HomeCourseGradesModel: HandyJSON {
    public var gradeId: Int = 0
    public var gradeName: String = ""
    required public init() {}
}
