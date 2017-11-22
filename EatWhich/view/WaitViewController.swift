//
//  WaitViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/9/9.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class WaitViewController: UIViewController, BMKLocationServiceDelegate, BMKPoiSearchDelegate {
    
    var user: User!
    var locationService:BMKLocationService!
    var pageList: [PageViewController]!
    var search: BMKPoiSearch!
    var currentLocation:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageList = [PageViewController]()
        locationService = BMKLocationService()
        search = BMKPoiSearch()
        locationService.startUserLocationService()

        // Do any additional setup after loading the view.
        //创建加载动画
        self.view.backgroundColor = UIColor.white
        let layer = self.view.layer
        let size = CGSize(width: 80, height: 80)
        let color = user.colorTheme
        let circleSpacing: CGFloat = -2
        let circleSize = (size.width - 4 * circleSpacing) / 5
        let x = (self.view.bounds.width - size.width) / 2
        let y = (self.view.bounds.width - size.height) / 2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0, 0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84]
        // 大小变化
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = duration
        // 透明度变化
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        //该属性是一个数组，用以指定每个子路径的时间。
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        //values属性指明整个动画过程中的关键帧点，需要注意的是，起点必须作为values的第一个值。
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = duration
        // 组动画
        let animation = CAAnimationGroup()
        //将大小变化和透明度变化的动画加入到组动画
        animation.animations = [scaleAnimation, opacityAnimaton]
        //动画的过渡效果
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        //动画的持续时间
        animation.duration = duration
        //设置重复次数,HUGE可看做无穷大，起到循环动画的效果
        animation.repeatCount = HUGE
        //运行一次是否移除动画
        animation.isRemovedOnCompletion = false
        // Draw circles
        for i in 0 ..< 8 {
            let circle = creatCircle(angle: CGFloat(Double.pi/4 * Double(i)),size: circleSize,origin: CGPoint(x: x, y: y + 50),containerSize: size, color: color)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationService.delegate = self
        search.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        locationService.delegate = self
        search.delegate = nil
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        currentLocation = userLocation.location.coordinate
        let option = BMKNearbySearchOption()
        option.pageIndex = 0
        option.pageCapacity = 100
        option.location = currentLocation
        option.keyword = "餐厅"
        if !search.poiSearchNear(by: option){
            NSLog("Search Failed")
        }
    }
    //poi搜索结果监听
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if errorCode == BMK_SEARCH_NO_ERROR {
            let poiInfo = poiResult.poiInfoList as! [BMKPoiInfo]
            //编辑请求参数
            var poiNameAndDistance = [[String:Any?]]()
            for poi in poiInfo{
                let fromPoint = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                let toPoint = CLLocation(latitude: poi.pt.latitude, longitude: poi.pt.longitude)
                let distance = Int(fromPoint.distance(from: toPoint))
                poiNameAndDistance.append(["name":poi.name, "distance":distance])
            }
            let parameters = ["restaurants":poiNameAndDistance,"energy":user.energyNeed] as [String : Any]
        
            //访问服务器
            let headers = [
                "authorization": "Basic eGp5OjIwMTcwNzI0",
                "content-type": "application/json",
                "cache-control": "no-cache",
                "postman-token": "ee43bdf3-ee2a-7154-7594-1a0a63de0eb1"
            ]
            //let parameters = ["energy": 800,"restaurants": [["name": "金马门国际美食百汇(珞喻路店)","distance": 450]]] as [String : Any]
            do{
                let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/api/v2.0/recommand")! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "PUT"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData as Data
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        NSLog(error.debugDescription)
                        self.performSegue(withIdentifier: "showRecommand", sender: self)
                    } else {
                        let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                        for i in 0..<3{
                            let restaurant = json?.object(forKey: String(i)) as AnyObject
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let pViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
                            pViewController.restaurant = restaurant
                            pViewController.poi = poiInfo[restaurant.object(forKey: "index") as! Int]
                            pViewController.color = UIColor.white.withAlphaComponent(0.1)
                            pViewController.currentLocation = self.currentLocation
                            pViewController.user = self.user
                            self.pageList.append(pViewController)
                        }
                        self.performSegue(withIdentifier: "showRecommand", sender: self)
                    }
                })
                dataTask.resume()
            }
            catch let error{
                NSLog("JSON失败\(error)")
                
            }
            
            //let detailOption = BMKPoiDetailSearchOption()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecommand"{
            if let a = segue.destination as? MapViewController{
                a.pageList = self.pageList
                a.user = self.user
                a.currentLocation = self.currentLocation
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func creatCircle(angle: CGFloat, size: CGFloat, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer{
        let radius = containerSize.width/2
        let circle = createLayerWith(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1) - size / 2,
            y: origin.y + radius * (sin(angle) + 1) - size / 2,
            width: size,
            height: size)
        
        circle.frame = frame
        
        return circle
    }
    
    func createLayerWith(size:CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        //创建贝塞尔曲线路径（CAShapeLayer就依靠这个路径渲染）
        let path: UIBezierPath = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false);
        layer.lineWidth = 2
        layer.fillColor = color.cgColor
        layer.backgroundColor = nil
        layer.path = path.cgPath
        
        return layer;
    }

}
