//
//  TestViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/10/25.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit
import Charts

class TestViewController: UIViewController {

    var CharView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let recipes = [
        [
            "hot" : 144,
            "name" : " 鸭脯玉米沙拉 "
            ],
        [
            "hot" : 218,
            "name" : " 梵高沙拉 "
            ],
        [
            "hot" : 258,
            "name" : " 鲷鱼 "
            ]
        ]
        var entrySet = [PieChartDataEntry]()
        for recipe in recipes{
            let entry = PieChartDataEntry(value: Double(recipe["hot"] as! Int), label: recipe["name"] as? String)
            entrySet.append(entry)
        }
        CharView = PieChartView(frame: CGRect(x: 0, y: 100, width: 375, height: 500))
        self.view.addSubview(CharView)
        let inEnergyDataset = PieChartDataSet(values: entrySet, label: "In")
        let data = PieChartData(dataSet: inEnergyDataset)
        CharView.data = data
        inEnergyDataset.sliceSpace = 2.0
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .percent
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        data.setValueFormatter(formatter as? IValueFormatter)
        //CharView.chartDescription?.text = "Energy in"
        
        inEnergyDataset.colors = ChartColorTemplates.vordiplom()
        CharView.holeColor = UIColor.clear
        CharView.legend.orientation = .vertical
        CharView.drawEntryLabelsEnabled = false
        CharView.usePercentValuesEnabled = true
        CharView.dragDecelerationEnabled = true
        CharView.drawHoleEnabled = true
        CharView.holeRadiusPercent = 0.5
        CharView.transparentCircleRadiusPercent = 0.6
        CharView.centerText = "摄入能量"
        CharView.animate(xAxisDuration: 1, easingOption: .easeOutSine)
        
        CharView.notifyDataSetChanged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
