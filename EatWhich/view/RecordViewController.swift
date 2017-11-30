//
//  RecordViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/10/19.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit
import Charts
class RecordViewController: UIViewController, BMKLocationServiceDelegate, JNStarReteViewDelegate{
    var record:EatRecord!
    var user:User!
    var locationService:BMKLocationService!
    var location:CLLocationCoordinate2D!
    let colorSet = [UIColor(red: 208/255, green: 217/255, blue: 224/255, alpha: 0.7), UIColor(red: 133 / 255.0, green: 207 / 255.0, blue: 213 / 255.0, alpha: 0.7), UIColor(red: 30/255, green: 161/255, blue: 177/255, alpha: 0.7)]

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        rateView.isHidden = true
        rateView.layer.cornerRadius = 5
        rateView.layer.masksToBounds = true
        rateView.layer.borderWidth = 2
        rateView.layer.borderColor = UIColor.black.cgColor

        // Do any additional setup after loading the view.
        locationService = BMKLocationService()
        progressView.stopAnimating()
        // 文字外观
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        datelabel.text = dateFormatter.string(from: record.date)
        timeLabel.text = "晚餐时间:" + timeFormatter.string(from: record.date)
        nameLabel.text = record.restaurant["name"] as? String
        addressLabel.text = "地址:" + (record.restaurant["address"] as! String)
        //enterBtn.layer.cornerRadius = 12
        //enterBtn.layer.masksToBounds = true
        //enterBtn.layer.borderWidth = 2
        //enterBtn.layer.borderColor = UIColor.black as! CGColor
        initInPieChart()
        initOutPieChart()
        initBarChart()
    }
    func initInPieChart(){
        var entrySet = [PieChartDataEntry]()
        for recipe in record.recipe{
            let entry = PieChartDataEntry(value: Double(recipe["hot"] as! Int), label: recipe["name"] as? String)
            entrySet.append(entry)
        }
        let CharView = PieChartView(frame: CGRect(x: 0, y: 300, width: 187, height: 250))
        self.mainView.addSubview(CharView)
        let inEnergyDataset = PieChartDataSet(values: entrySet, label: "")
        let data = PieChartData(dataSet: inEnergyDataset)
        CharView.data = data
        inEnergyDataset.sliceSpace = 4.0
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .percent
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        data.setValueFormatter(formatter as? IValueFormatter)
        //CharView.chartDescription?.text = "Energy in"
        inEnergyDataset.colors = colorSet
        CharView.holeColor = UIColor.clear
        CharView.legend.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 10.0)!
        CharView.legend.horizontalAlignment = .center
        CharView.legend.form = .circle
        CharView.legend.orientation = .vertical
        CharView.drawEntryLabelsEnabled = false
        CharView.usePercentValuesEnabled = true
        CharView.dragDecelerationEnabled = true
        CharView.drawHoleEnabled = true
        CharView.holeRadiusPercent = 0.5
        CharView.transparentCircleRadiusPercent = 0.6
        CharView.centerText = "摄入能量"
        CharView.animate(xAxisDuration: 1, easingOption: .easeOutSine)
        CharView.chartDescription?.text = ""
        CharView.notifyDataSetChanged()
    }
    func initOutPieChart(){
        var entrySet = [PieChartDataEntry]()
        entrySet.append(PieChartDataEntry(value: Double(record.health.distanceEnergy), label: "步行"))
        entrySet.append(PieChartDataEntry(value: Double(record.health.floorEnergy), label: "爬楼"))
        entrySet.append(PieChartDataEntry(value: Double(user.BMR), label: "基础消耗"))
        let CharView = PieChartView(frame: CGRect(x: 188, y: 300, width: 187, height: 250))
        self.mainView.addSubview(CharView)
        let inEnergyDataset = PieChartDataSet(values: entrySet, label: "")
        let data = PieChartData(dataSet: inEnergyDataset)
        CharView.data = data
        inEnergyDataset.sliceSpace = 4.0
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .percent
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        data.setValueFormatter(formatter as? IValueFormatter)
        //CharView.chartDescription?.text = "Energy in"
        inEnergyDataset.colors = colorSet
        CharView.holeColor = UIColor.clear
        CharView.legend.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 10.0)!
        CharView.legend.horizontalAlignment = .center
        CharView.legend.form = .circle
        CharView.legend.orientation = .vertical
        CharView.drawEntryLabelsEnabled = false
        CharView.usePercentValuesEnabled = true
        CharView.dragDecelerationEnabled = true
        CharView.drawHoleEnabled = true
        CharView.holeRadiusPercent = 0.5
        CharView.transparentCircleRadiusPercent = 0.6
        CharView.centerText = "消耗能量"
        CharView.animate(xAxisDuration: 1, easingOption: .easeOutSine)
        CharView.chartDescription?.text = ""
        CharView.notifyDataSetChanged()
    }
    
    func initBarChart(){
        //data
        
        var entrySet1 = [BarChartDataEntry]()
        var entrySet2 = [BarChartDataEntry]()
        entrySet1.append(BarChartDataEntry(x: 1, y: Double(record.energyIn)))
        entrySet2.append(BarChartDataEntry(x: 2, y: Double(record.energyOut)))
        let barDataset1 = BarChartDataSet(values: entrySet1, label: "摄入热量")
        let barDataset2 = BarChartDataSet(values: entrySet2, label: "推荐热量   ")
        let BarView = HorizontalBarChartView(frame: CGRect(x: 16, y: 100, width: 230, height: 170))
        let data = BarChartData(dataSets: [barDataset1, barDataset2])
        BarView.data = data
        self.mainView.addSubview(BarView)
        //view
        barDataset1.colors = [colorSet[0]]
        barDataset2.colors = [colorSet[1]]
        barDataset1.drawValuesEnabled = true
        barDataset2.drawValuesEnabled = true
        BarView.chartDescription?.text = ""
        BarView.rightAxis.drawLabelsEnabled = false
        BarView.leftAxis.drawLabelsEnabled = false
        BarView.xAxis.drawLabelsEnabled = false
        BarView.rightAxis.drawAxisLineEnabled = false
        BarView.leftAxis.drawAxisLineEnabled = false
        BarView.xAxis.drawAxisLineEnabled = false
        BarView.leftAxis.drawGridLinesEnabled = false
        BarView.rightAxis.drawGridLinesEnabled = false
        BarView.xAxis.drawGridLinesEnabled = false
        BarView.legend.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 10.0)!
        BarView.legend.horizontalAlignment = .right
        BarView.legend.verticalAlignment = .bottom
        BarView.legend.orientation = .vertical
        BarView.legend.form = .circle
        BarView.animate(yAxisDuration: 1.4)
        BarView.fitBars = true
        BarView.notifyDataSetChanged()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationService.delegate = self
    }
    func didUpdate(_ userLocation: BMKUserLocation!) {
        location = userLocation.location.coordinate
        if progressView.isAnimating{
            progressView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.performSegue(withIdentifier: "enterHistoryRestaurant", sender: nil)
        }
    }

    @IBAction func enterRestaurant(_ sender: Any) {
        progressView.startAnimating()
        self.view.isUserInteractionEnabled = false
        locationService.startUserLocationService()
    }
    @IBAction func showRateView(_ sender: Any) {
        rateView.isHidden = false
        self.rateView.becomeFirstResponder()
        let starView = JNStarRateView.init(frame: CGRect(x: 20,y: 60,width: 280,height: 50), starCount: 5, score: 0)
        //        starView.userInteractionEnabled = false//不支持用户操作
        starView.delegate = self
        starView.usePanAnimation = true
        starView.allowUserPan = true//滑动评星
        //        starView.allowUnderCompleteStar = false // 完整星星
        self.rateView.addSubview(starView)
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
    //starView Delegate
    func starRate(view starRateView: JNStarRateView, score: Float) {
        
    }
    @IBAction func finishRate(_ sender: Any) {
        rateView.isHidden = true
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
