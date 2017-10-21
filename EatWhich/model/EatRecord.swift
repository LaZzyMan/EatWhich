//
//  EatRecord.swift
//  EatWhich
//
//  Created by seirra on 2017/10/16.
//  Copyright © 2017年 zz. All rights reserved.
//

import Foundation
import UIKit

class EatRecord:NSObject{
    var date:Date!
    var energyIn:Float!
    var energyOut:Float!
    var restaurant:[String:Any]!
    var recipe:[[String:Any]]!
    var location:CLLocationCoordinate2D!
    var state:Int{
        get{
            let inOutRate = self.energyIn/self.energyOut
            if inOutRate>1.2{
                return 1
            }
            if inOutRate<0.8{
                return -1
            }
            return 0
        }
    }
    var health:HealthInfo!
    init(with json:AnyObject){
        date = json.object(forKey: "date") as! Date
        energyIn = json.object(forKey: "energyIn") as! Float
        energyOut = json.object(forKey: "energyOut") as! Float
        recipe = json.object(forKey: "recipe") as! [[String:Any]]
        restaurant = json.object(forKey: "restaurant") as! [String:Any]
        let coordinate = json.object(forKey: "location") as! [String:Any]
        location = CLLocationCoordinate2D(latitude: coordinate["lat"] as! CLLocationDegrees, longitude: coordinate["lon"] as! CLLocationDegrees)
        health = HealthInfo(with: json.object(forKey: "health") as AnyObject)
        super.init()
    }
    override init(){
        date = Date()
        energyOut = 0
        energyIn = 0
        restaurant = [String:Any]()
        recipe = [[String:Any]]()
        location = CLLocationCoordinate2D()
        super.init()
    }
}
