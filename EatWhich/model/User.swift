//
//  User.swift
//  EatWhich
//
//  Created by seirra on 2017/9/4.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class User: NSObject{
    var userName:String!
    var height:Int32!
    var weight:Int32!
    var birthday:Date!
    var gender:Bool!
    var healthInfo:HealthInfo!
    var headImage: UIImage!
    var name:String!
    var email:String!
    var remind:[String:Any]!
    var historyRecord:[EatRecord]!
    var colorTheme:UIColor{
        get{
            let colors = [UIColor(red: 29/255, green: 176/255, blue: 184/255, alpha: 0.8), UIColor(red: 55 / 255.0, green: 202 / 255.0, blue: 123 / 255.0, alpha: 0.8), UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 0.8)]
            return colors[state]
        }
    }
    var energyNeed:Float{
        get{
            return (healthInfo.energy + BMR)*0.25
        }
    }
    var state:Int{
        get{
            switch Int(BMR/energyNeed) {
            case 2:
                return 2
            case 3:
                return 1
            default:
                return 0
            }
        }
    }
    var old:Int{
        get{
            let current = Calendar.current
            let currentDate = Date()
            let componet = current.dateComponents([Calendar.Component.year], from: currentDate, to: birthday)
            return componet.year!
        }
    }
    
    var BMR:Float{
        get{
            if gender{
                let weightTemp = 13.7*Float(weight)
                let heightTemp = 5*Float(height)
                let oldTemp = 6.8*Float(old)
                return (66+weightTemp+heightTemp-oldTemp)*1.2
            }else{
                let weightTemp = 9.6*Float(weight)
                let heightTemp = 1.8*Float(height)
                let oldTemp = 4.7*Float(old)
                return (655+weightTemp+heightTemp-oldTemp)*1.2
            }
        }
    }
    /*
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName, forKey:"userName")
        aCoder.encode(passWord, forKey:"passWord")
        aCoder.encode(healthInfo,forKey:"healthInfo")
        aCoder.encode(birthday,forKey:"birthday")
        aCoder.encode(name, forKey:"name")
        aCoder.encode(headImage, forKey:"headImage")
        aCoder.encode(String(height), forKey:"height")
        aCoder.encode(String(weight), forKey:"weight")
        let g = gender == true ? "男" : "女"
        aCoder.encode(g, forKey:"gender")
        
    }
    required init?(coder aDecoder: NSCoder) {
        userName = aDecoder.decodeObject(forKey: "userName") as! String
        passWord = aDecoder.decodeObject(forKey: "passWord") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        healthInfo = aDecoder.decodeObject(forKey: "healthInfo") as! HealthInfo
        headImage = aDecoder.decodeObject(forKey: "headImage") as! UIImage
        birthday = aDecoder.decodeObject(forKey: "birthday") as! Date
        let g = aDecoder.decodeObject(forKey: "gender") as! String
        let w = aDecoder.decodeObject(forKey: "weight") as! String
        let h = aDecoder.decodeObject(forKey: "height") as! String
        weight = (w as NSString).intValue
        height = (h as NSString).intValue
        gender = g == "男" ? true : false
        
        super.init()
    }*/
    override init() {
        healthInfo = HealthInfo()
        userName = ""
        height = 0
        weight = 0
        gender = true
        birthday = Date()
        email = ""
        remind = ["on":0, "time":"00:00"]
        historyRecord = [EatRecord]()
        super.init()
        
    }
    /*
    func documentsDirectory()  -> URL {
        let paths = FileManager.default.urls( for: .documentDirectory,
                                              in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath()  -> URL {
        return documentsDirectory().appendingPathComponent( "UserInfo.plist")
    }
    func save(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(self, forKey: self.userName)
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }*/
    //登录时初始化数据
    func initWithJson(with json:AnyObject?){
        userName = json?.object(forKey:"username") as! String
        name = json?.object(forKey: "name") as! String
        healthInfo.updateUserData()
        let imageURL = URL(string: json?.object(forKey: "headImage") as! String)
        let imageData = NSData(contentsOf: imageURL!)
        headImage = UIImage(data: imageData! as Data)
        birthday = json?.object(forKey: "birthday") as! Date
        email = json?.object(forKey: "email") as! String
        let remindObject = json?.object(forKey:"remind") as AnyObject
        remind["on"] = remindObject.object(forKey: "on") as! Int
        remind["time"] = remindObject.object(forKey: "time") as! Int
        let g = json?.object(forKey: "gender") as! String
        let w = json?.object(forKey: "weight") as! String
        let h = json?.object(forKey: "height") as! String
        weight = (w as NSString).intValue
        height = (h as NSString).intValue
        gender = g == "男" ? true : false
    }
    //向服务器端提交修改请求
    func editUserInfo()->Int{
        var result = 0
        let parameters = ["name":self.name,"gender":self.gender,"height":self.height,"weight":self.weight,"birthday":self.birthday] as [String : Any]
        let headers = [
            "content-type": "application/json",
            "authorization": "Basic eno6MjAxNzA3MzE=",
            "cache-control": "no-cache",
            "postman-token": "609cf8e1-cad3-dae1-8d6e-b1e459216599"
        ]
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/eat/api/v1.0/login")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    NSLog(error.debugDescription)
                } else {
                    let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    result = json?.object(forKey: "status") as! Int
                }
            })
            dataTask.resume()
        }
        catch let error{
            NSLog("JSON失败\(error)")
        }
        return result
    }
    //访问餐厅历史数据
    func getRestaurantHistory(number:Int){
        let parameters = ["username":userName, "num":number] as [String : Any]
        let headers = [
            "content-type": "application/json",
            "authorization": "Basic eno6MjAxNzA3MzE=",
            "cache-control": "no-cache",
            "postman-token": "609cf8e1-cad3-dae1-8d6e-b1e459216599"
        ]
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/eat/api/v1.0/history")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    NSLog(error.debugDescription)
                } else {
                    let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    let records = json?.object(forKey: "records") as! [AnyObject]
                    for record in records{
                        self.historyRecord.append(EatRecord(with: record))
                    }
                }
            })
            dataTask.resume()
        }
        catch let error{
            NSLog("JSON失败\(error)")
        }
    }
}
