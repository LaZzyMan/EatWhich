//
//  HistoryViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/10/19.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController: UIViewController{
    @IBOutlet weak var data: UIView!
    var user:User!
    let colorSet = [UIColor(red: 208/255, green: 217/255, blue: 224/255, alpha: 0.7), UIColor(red: 133 / 255.0, green: 207 / 255.0, blue: 213 / 255.0, alpha: 0.7), UIColor(red: 30/255, green: 161/255, blue: 177/255, alpha: 0.7)]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayDataView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func displayDataView(){
        initLineChart(days: 7, frame: CGRect(x: 0, y: 95, width: 375, height: 270))
        initLineChart(days: 30, frame: CGRect(x: 0, y: 397, width: 375, height: 270))
    }
    
    func initLineChart(days:Int, frame:CGRect){
        //data
        var entrySet1 = [ChartDataEntry]()
        var entrySet2 = [ChartDataEntry]()
        for i in 0...days{
            entrySet1.append(ChartDataEntry(x: Double(i), y: Double(user.historyRecord[i].energyIn)))
            entrySet2.append(ChartDataEntry(x: Double(i), y: Double(user.historyRecord[i].energyOut)))
        }
        let lineDataset1 = LineChartDataSet(values: entrySet1, label: "摄入热量")
        let lineDataset2 = LineChartDataSet(values: entrySet2, label: "消耗热量")
        let LineView = LineChartView(frame: frame)
        let data = LineChartData(dataSets: [lineDataset1, lineDataset2])
        LineView.data = data
        self.data.addSubview(LineView)
        //view        LineView.chartDescription?.text = "最近\(days)天晚餐历史统计"
        LineView.chartDescription?.enabled = true
        LineView.chartDescription?.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 17.0)!
        LineView.chartDescription?.position = CGPoint(x: frame.minX+5.0, y: frame.minY+5.0)
        LineView.rightAxis.drawLabelsEnabled = false
        LineView.xAxis.labelPosition = .bottom
        LineView.drawGridBackgroundEnabled = false
        lineDataset1.drawValuesEnabled = false
        lineDataset2.drawValuesEnabled = false
        lineDataset1.drawFilledEnabled = true
        lineDataset2.drawFilledEnabled = true
        lineDataset1.fillColor = colorSet[0]
        lineDataset2.fillColor = colorSet[2]
        lineDataset1.fillAlpha = 0.7
        lineDataset2.fillAlpha = 0.7
        lineDataset1.drawCirclesEnabled = false
        lineDataset2.drawCirclesEnabled = false
        lineDataset1.mode = .cubicBezier
        lineDataset2.mode = .cubicBezier
        lineDataset1.colors = [colorSet[0]]
        lineDataset2.colors = [colorSet[2]]
        LineView.chartDescription?.text = ""
        LineView.legend.font = UIFont(name: "FZQingKeBenYueSongS-R-GB", size: 10.0)!
        LineView.legend.horizontalAlignment = .right
        LineView.legend.verticalAlignment = .bottom
        LineView.legend.orientation = .vertical
        LineView.legend.form = .line
        LineView.animate(yAxisDuration: 1.4)
        LineView.notifyDataSetChanged()
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
