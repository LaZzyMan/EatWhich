//
//  MapViewController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/16.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, BMKMapViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, BMKRouteSearchDelegate {

    var user:User!
    var mapView:BMKMapView!
    var pageViewController: UIPageViewController!
    //var locationService:BMKLocationService = BMKLocationService()
    var pageList = [PageViewController]()
    var currentLocation:CLLocationCoordinate2D!
    var routeSearch:BMKRouteSearch!
    @IBOutlet weak var blackFilter: UIView!
    @IBOutlet weak var map: UIView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var waitProgress: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stylePath = Bundle.main.path(forResource: "mapConfig", ofType: "")
        BMKMapView.customMapStyle(stylePath)
        
        routeSearch = BMKRouteSearch()
        mapView = BMKMapView(frame: map.frame)
        self.map.addSubview(mapView)
        BMKMapView.enableCustomMapStyle(true)
        //mapView.isBuildingsEnabled = false
        //locationService.startUserLocationService()
        //mapView.showsUserLocation = false
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        //mapView.showsUserLocation = true
        //blackFilter.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        pageViewController = self.childViewControllers.first as! UIPageViewController
        pageViewController.delegate = self;
        pageViewController.dataSource = self;
        pageViewController.setViewControllers([pageList[0] as UIViewController] , direction: .forward, animated: false, completion: nil)
        self.pageController.currentPage = 0
        
        //ui更新
        //self.containView.layer.cornerRadius = 20
        //self.containView.layer.masksToBounds = true
        //self.containView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.mapView.isBuildingsEnabled = false
        
        //创建加载动画
        self.waitView.backgroundColor = UIColor.white
        let layer = self.waitView.layer
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
        DispatchQueue.main.async(execute: {
            self.updateBackground()
            })
        //updateBackground()
    }
    override func viewWillAppear(_ animated: Bool) {
        mapView.viewWillAppear()
        routeSearch.delegate = self
        //locationService.delegate = self
        mapView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.region = BMKCoordinateRegionMake(mapView.centerCoordinate, BMKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    }
    override func viewWillDisappear(_ animated: Bool) {
        mapView.viewWillDisappear()
        //locationService.delegate = self
        routeSearch.delegate = nil
        mapView.delegate = nil
    }
    //刷新背景页面
    func updateBackground(){
        let from = BMKPlanNode()
        from.pt = currentLocation
        //from.name = "当前位置"
        //from.cityName = "武汉"
        let to = BMKPlanNode()
        //to.name = pageList[self.pageController.currentPage].poi.name
        //to.cityName = "武汉"
        to.pt = pageList[self.pageController.currentPage].poi.pt
        let walkingRouteSearchOption = BMKWalkingRoutePlanOption()
        walkingRouteSearchOption.from = from
        walkingRouteSearchOption.to = to
        let flag = routeSearch.walkingSearch(walkingRouteSearchOption)
        if !flag {
            NSLog("步行检索发送失败")
        }
    }
    /*
    func didUpdate(_ userLocation: BMKUserLocation!) {
        currentLocation = userLocation.location.coordinate
        mapView.updateLocationData(userLocation)
        pageList[self.pageController.currentPage].currentLocation = currentLocation
        self.updateBackground()
    }
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        currentLocation = userLocation.location.coordinate
        //mapView.updateLocationData(userLocation)
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //监听步行路线规划
    
    func onGetWalkingRouteResult(_ searcher: BMKRouteSearch!, result: BMKWalkingRouteResult!, errorCode error: BMKSearchErrorCode) {
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        if error == BMK_SEARCH_NO_ERROR {
            let plan = result.routes[0] as! BMKWalkingRouteLine
            
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                let transitStep = plan.steps[i] as! BMKWalkingStep
                if i == 0 {
                    let item = RouteAnnotation()
                    item.coordinate = plan.starting.location
                    item.title = "当前位置"
                    item.type = 0
                    mapView.addAnnotation(item)  // 添加起点标注
                }
                if i == size - 1 {
                    let item = RouteAnnotation()
                    item.coordinate = plan.terminal.location
                    item.title = pageList[self.pageController.currentPage].poi.name
                    item.type = 1
                    mapView.addAnnotation(item)  // 添加终点标注
                }
                // 添加 annotation 节点
                let item = RouteAnnotation()
                item.coordinate = transitStep.entrace.location
                item.title = transitStep.entraceInstruction
                item.degree = Int(transitStep.direction) * 30
                item.type = 4
                mapView.addAnnotation(item)
                
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            // 轨迹点
            var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
            var i = 0
            for j in 0..<size {
                let transitStep = plan.steps[j] as! BMKWalkingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i += 1
                }
            }
            
            // 通过 points 构建 BMKPolyline
            let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
            mapView.add(polyLine)  // 添加路线 overlay
            mapViewFitPolyLine(polyLine)
            waitProgress.stopAnimating()
            blackFilter.isUserInteractionEnabled = true
            waitView.isHidden = true
        }
    }
    
    //DataSource
    //返回当前页面的下一个页面，左划
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if self.pageController.currentPage == 2{
            return nil
        }
        waitProgress.startAnimating()
        blackFilter.isUserInteractionEnabled = false
        self.pageController.currentPage += 1
        DispatchQueue.main.async(execute: {
            self.updateBackground()
        })
        return pageList[self.pageController.currentPage] as UIViewController
    }
    
    //返回当前页面的上一个页面，右划
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if self.pageController.currentPage == 0{
            return nil
        }
        waitProgress.startAnimating()
        blackFilter.isUserInteractionEnabled = false
        self.pageController.currentPage -= 1
        DispatchQueue.main.async(execute: {
            self.updateBackground()
        })
        return pageList[self.pageController.currentPage] as UIViewController
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.pageController.currentPage
    }
    
    //Delegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        return .min
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
    // MARK: - BMKMapViewDelegate
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if let routeAnnotation = annotation as! RouteAnnotation? {
            return getViewForRouteAnnotation(routeAnnotation)
        }
        return nil
    }
    

    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay as! BMKPolyline? != nil {
            let polylineView = BMKPolylineView(overlay: overlay as! BMKPolyline)
            polylineView?.strokeColor = UIColor(red: 255/255, green: 66/255, blue: 56/255, alpha: 0.7)
            polylineView?.lineWidth = 5
            return polylineView
        }
        return nil
    }

    func getViewForRouteAnnotation(_ routeAnnotation: RouteAnnotation!) -> BMKAnnotationView? {
        var view: BMKAnnotationView?
        
        var imageName: String?
        switch routeAnnotation.type {
        case 0:
            imageName = "nav_start"
        case 1:
            imageName = "nav_end"
        case 2:
            imageName = "nav_bus"
        case 3:
            imageName = "nav_rail"
        case 4:
            imageName = "direction"
        case 5:
            imageName = "nav_waypoint"
        default:
            return nil
        }
        let identifier = "\(String(describing: imageName))_annotation"
        view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if view == nil {
            view = BMKAnnotationView(annotation: routeAnnotation, reuseIdentifier: identifier)
            view?.centerOffset = CGPoint(x: 0, y: -(view!.frame.size.height * 0.5))
            view?.canShowCallout = true
        }
        
        view?.annotation = routeAnnotation
        
        let bundlePath = (Bundle.main.resourcePath)! + "/mapapi.bundle/"
        let bundle = Bundle(path: bundlePath)
        var tmpBundle : String?
        tmpBundle = (bundle?.resourcePath)! + "/images/icon_\(imageName!).png"
        if let imagePath = tmpBundle {
            var image = UIImage(contentsOfFile: imagePath)
            if routeAnnotation.type == 4 {
                image = imageRotated(image, degrees: routeAnnotation.degree)
            }
            if image != nil {
                view?.image = image
            }
        }
        
        return view
    }
    
    
    
    
    //根据polyline设置地图范围
    func mapViewFitPolyLine(_ polyline: BMKPolyline!) {
        if polyline.pointCount < 1 {
            return
        }
        
        let pt = polyline.points[0]
        var leftTopX = pt.x
        var leftTopY = pt.y
        var rightBottomX = pt.x
        var rightBottomY = pt.y
        
        for i in 1..<polyline.pointCount {
            let pt = polyline.points[Int(i)]
            leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
            leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
            rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
            rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
        }
        
        let rect = BMKMapRectMake(leftTopX, leftTopY, rightBottomX - leftTopX, rightBottomY - leftTopY)
        mapView.visibleMapRect = rect
    }
    
    //旋转图片
    func imageRotated(_ image: UIImage!, degrees: Int!) -> UIImage {
        let width = image.cgImage?.width
        let height = image.cgImage?.height
        let rotatedSize = CGSize(width: width!, height: height!)
        UIGraphicsBeginImageContext(rotatedSize);
        let bitmap = UIGraphicsGetCurrentContext();
        bitmap?.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2);
        bitmap?.rotate(by: CGFloat(Double(degrees) * Double.pi / 180.0));
        bitmap?.rotate(by: CGFloat(Double.pi));
        bitmap?.scaleBy(x: -1.0, y: 1.0);
        bitmap?.draw(image.cgImage!, in: CGRect(x: -rotatedSize.width/2, y: -rotatedSize.height/2, width: rotatedSize.width, height: rotatedSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }
    //画圆
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
    @IBAction func returnMainView(_ sender: Any) {
        self.performSegue(withIdentifier: "returnMainView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnMainView"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
    }
}
