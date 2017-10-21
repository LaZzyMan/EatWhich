//
//  RouteAnnotation.swift
//  EatWhich
//
//  Created by seirra on 2017/9/9.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class RouteAnnotation: BMKPointAnnotation {
    
    var type: Int!///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    var degree: Int!
    
    override init() {
        super.init()
    }
    
    init(type: Int, degree: Int) {
        self.type = type
        self.degree = degree
    }
    
}
