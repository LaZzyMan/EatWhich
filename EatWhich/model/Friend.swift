//
//  Friend.swift
//  EatWhich
//
//  Created by apple on 2017/11/30.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class Friend: NSObject {
    var name:String!
    var state:String!
    var headImage:UIImage!
    override init() {
    }
    init(name:String, state:String, image:UIImage){
        self.name = name
        self.state = state
        self.headImage = image
    }

}
