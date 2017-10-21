//
//  RecordViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/10/19.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit
import Charts
class RecordViewController: UIViewController, ChartViewDelegate, BMKLocationServiceDelegate{
    var record:EatRecord!
    var user:User!
    var locationService:BMKLocationService!
    var location:CLLocationCoordinate2D!

    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var energyBarChart: BarChartView!
    @IBOutlet weak var inPieChart: PieChartView!
    @IBOutlet weak var outPieChart: PieChartView!
    @IBOutlet weak var enterBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 文字外观
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        datelabel.text = dateFormatter.string(from: record.date)
        timeLabel.text = timeFormatter.string(from: record.date)
        nameLabel.text = record.restaurant["name"] as? String
        addressLabel.text = record.restaurant["address"] as? String
        enterBtn.layer.cornerRadius = 12
        enterBtn.layer.masksToBounds = true
        enterBtn.layer.borderWidth = 2
        enterBtn.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
        //图表设置
        energyBarChart.delegate = self
        inPieChart.delegate = self
        outPieChart.delegate = self
        //创建数据集
        let inEnergyDataset = PieChartDataSet()
        for recipe in record.recipe{
            let entry = PieChartDataEntry(value: recipe["hot"] as! Double, label: recipe["name"] as! String)
            inEnergyDataset.addEntry(entry)
        }
        let outEnergyDataset = PieChartDataSet()
        outEnergyDataset.addEntry(PieChartDataEntry(value: record.health.distanceEnergy as! Double, label: "Walk"))
        outEnergyDataset.addEntry(PieChartDataEntry(value: record.health.floorEnergy as! Double, label: "Floors"))
        outEnergyDataset.addEntry(PieChartDataEntry(value: user.BMR as! Double, label: "BMR"))
        let barDataset = BarChartDataSet()
        barDataset.addEntry(BarChartDataEntry(x: 1, y: record.energyIn as! Double))
        barDataset.addEntry(BarChartDataEntry(x: 2, y: record.energyOut as! Double))
        //in pie chart
        inPieChart.usePercentValuesEnabled = true
        inPieChart.dragDecelerationEnabled = true
        inPieChart.drawHoleEnabled = true
        inPieChart.holeRadiusPercent = 0.5
        inPieChart.transparentCircleRadiusPercent = 0.6
        inPieChart.holeColor = UIColor.clear
        inPieChart.centerText = "摄入能量"
        inPieChart.animate(xAxisDuration: 1, easingOption: .easeOutSine)
        inPieChart.data = PieChartData(dataSet: inEnergyDataset)
        inPieChart.notifyDataSetChanged()
        //out pie chart
        outPieChart.usePercentValuesEnabled = true
        outPieChart.dragDecelerationEnabled = true
        outPieChart.drawHoleEnabled = true
        outPieChart.holeRadiusPercent = 0.5
        outPieChart.transparentCircleRadiusPercent = 0.6
        outPieChart.holeColor = UIColor.clear
        outPieChart.centerText = "摄入能量"
        outPieChart.animate(xAxisDuration: 1, easingOption: .easeOutSine)
        outPieChart.data = PieChartData(dataSet: outEnergyDataset)
        outPieChart.notifyDataSetChanged()
        energyBarChart.data = BarChartData(dataSet: barDataset)
        energyBarChart.notifyDataSetChanged()
    }
    override func viewWillAppear(_ animated: Bool) {
        locationService.delegate = self
    }
    func didUpdate(_ userLocation: BMKUserLocation!) {
        location = userLocation.location.coordinate
        self.performSegue(withIdentifier: "enterHistoryRestaurant", sender: nil)
    }

    @IBAction func enterRestaurant(_ sender: Any) {
        locationService = BMKLocationService()
        locationService.startUserLocationService()
    }
    @IBAction func backToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "historyBack", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyBack"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
        if segue.identifier == "enterHistoryRestaurant"{
            if let a = segue.destination as? DetailInfoViewController{
                a.user = self.user
                a.currentLocation = self.location
                a.restaurant = self.record.restaurant as AnyObject
                a.restaurantPt = self.record.location
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

}
