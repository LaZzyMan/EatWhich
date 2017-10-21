//
//  HistoryViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/10/19.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController: UIViewController, BMKMapViewDelegate, BMKLocationServiceDelegate {

    @IBOutlet weak var weekView: LineChartView!
    @IBOutlet weak var monthView: LineChartView!
    @IBOutlet weak var transformer: UISegmentedControl!
    @IBOutlet weak var map: UIView!
    @IBOutlet weak var data: UIView!
    var mapView:BMKMapView!
    var locationService:BMKLocationService!
    var user:User!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView = BMKMapView()
        locationService = BMKLocationService()
        map.center.x += self.view.bounds.width
        map.addSubview(mapView)
        displayDataView()
    }
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        locationService.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        mapView.delegate = nil
        locationService.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func transform(_ sender: Any) {
        switch self.transformer.selectedSegmentIndex {
        case 1:
            displayMapView()
        default:
            displayDataView()
        }
    }
    
    @IBAction func detailHistoryBack(_ sender: Any) {
        self.performSegue(withIdentifier: "detailHistoryBack", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailHistoryBack"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
    }
    func displayMapView(){
        map.center.x -= self.view.bounds.width
        map.center.x += self.view.bounds.width
        locationService.startUserLocationService()
        mapView.showsUserLocation = true
        mapView.isBuildingsEnabled = false
        for record in user.historyRecord{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM,dd,YYYY"
            let annotion = BMKPointAnnotation()
            annotion.coordinate = record.location
            annotion.title = record.restaurant["name"] as! String
            annotion.subtitle = dateFormatter.string(from: record.date)
        }
    }
    func displayDataView(){
        map.center.x += self.view.bounds.width
        data.center.x += self.view.bounds.width
        //week
        let weekDatasetIn = LineChartDataSet()
        let weekDatasetOut = LineChartDataSet()
        for i in 0...7{
            weekDatasetIn.addEntry(ChartDataEntry(x: i as! Double, y: user.historyRecord[i].energyIn as! Double))
            weekDatasetOut.addEntry(ChartDataEntry(x: i as! Double, y: user.historyRecord[i].energyOut as! Double))
        }
        weekDatasetIn.drawFilledEnabled = true
        weekDatasetOut.drawFilledEnabled = true
        weekDatasetIn.mode = .cubicBezier
        weekDatasetOut.mode = .cubicBezier
        weekView.data = LineChartData(dataSets: [weekDatasetIn,weekDatasetOut])
        //momth
        let monthDatasetIn = LineChartDataSet()
        let monthDatasetOut = LineChartDataSet()
        for i in 0...30{
            monthDatasetIn.addEntry(ChartDataEntry(x: i as! Double, y: user.historyRecord[i].energyIn as! Double))
            monthDatasetOut.addEntry(ChartDataEntry(x: i as! Double, y: user.historyRecord[i].energyOut as! Double))
        }
        monthDatasetIn.drawFilledEnabled = true
        monthDatasetOut.drawFilledEnabled = true
        monthDatasetIn.mode = .cubicBezier
        monthDatasetOut.mode = .cubicBezier
        monthView.data = LineChartData(dataSets: [monthDatasetIn,monthDatasetOut])
    }
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let AnnotationViewID = "renameMark"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as! BMKPinAnnotationView?
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            // 设置颜色
            annotationView!.pinColor = UInt(BMKPinAnnotationColorRed)
            // 设置可拖拽
            annotationView!.isDraggable = false
            // 从天上掉下的动画
            annotationView!.animatesDrop = true
        }
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        return annotationView
    }
    func didUpdate(_ userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
