//
//  HealthInfo.swift
//  EatWhich
//
//  Created by seirra on 2017/9/4.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit
import CoreMotion

class HealthInfo: NSObject ,NSCoding{
    var distance:Float
    var steps:Int32
    var floors:Int32
    var distanceEnergy:Float{
        get{
            return 55*distance
        }
    }
    var floorEnergy:Float{
        get{
            return Float(15*floors)
        }
    }
    var energy:Float{
        get{
            return self.distanceEnergy+self.floorEnergy
        }
    }
    let pedometer = CMPedometer()
    func encode(with aCoder: NSCoder) {
        aCoder.encode(distance, forKey: "distance")
        aCoder.encode(steps, forKey: "steps")
        aCoder.encode(floors, forKey: "floors")
    }
    override init() {
        distance = 0
        steps = 0
        floors = 0
        super.init()
    }
    public func updateUserData(){
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day], from: Date())//获取当前时间的年月日
        
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let midnightOfToday = cal.date(from: comps)!//获取指定时间点
        
        //初始化并开始实时获取数据
        self.pedometer.startUpdates (from: midnightOfToday, withHandler: { pedometerData, error in
            //错误处理
            guard error == nil else {
                print(error!)
                return
            }
            
            if let numberOfSteps = pedometerData?.numberOfSteps {
                self.steps = Int32(numberOfSteps)
            }
            if let d = pedometerData?.distance {
                self.distance = (d as! Float)/1000
            }
            if let floorsAscended = pedometerData?.floorsAscended {
                self.floors = Int32(floorsAscended)
            }
        })
    }
    required init?(coder aDecoder: NSCoder) {
        distance = aDecoder.decodeFloat(forKey: "distance")
        steps = aDecoder.decodeInt32(forKey: "steps")
        floors = aDecoder.decodeInt32(forKey: "floors")
        super.init()
    }
    init(with json:AnyObject){
        distance = json.object(forKey: "distance") as! Float
        floors = json.object(forKey: "floors") as! Int32
        steps = json.object(forKey: "steps") as! Int32
        super.init()
    }

}
