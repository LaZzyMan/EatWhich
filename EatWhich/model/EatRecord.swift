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
    var BMP:Float!
    var energyIn:Float!{
        get{
            var sum:Float = 0
            for r in recipe{
                sum += r["hot"] as! Float
            }
            return sum
        }
    }
    var energyOut:Float!{
        get{
            return (self.health.distanceEnergy + self.health.floorEnergy + self.BMP)*0.25
        }
    }
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        date = dateFormatter.date(from: json.object(forKey: "date") as! String)
        recipe = json.object(forKey: "recipe") as! [[String:Any]]
        restaurant = json.object(forKey: "restaurant") as! [String:Any]
        let coordinate = restaurant["location"] as! [String:Any]
        location = CLLocationCoordinate2D(latitude: coordinate["lat"] as! CLLocationDegrees, longitude: coordinate["lng"] as! CLLocationDegrees)
        health = HealthInfo(with: json.object(forKey: "health") as AnyObject)
        super.init()
    }
    override init(){
        date = Date()
        BMP = 0
        restaurant = [String:Any]()
        recipe = [[String:Any]]()
        location = CLLocationCoordinate2D()
        super.init()
    }
}
