//
//  HealthViewController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/13.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit
import CoreMotion

class HealthViewController: UIViewController {
    
    @IBOutlet weak var floorsText: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var distanceText: UILabel!
    @IBOutlet weak var stepsText: UILabel!
    @IBOutlet weak var usedText: UILabel!
    @IBOutlet weak var stasticView: UIView!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var downlabel: UILabel!
    @IBOutlet weak var baseUse: UILabel!
    @IBOutlet weak var sportUse: UILabel!
    @IBOutlet weak var totalEnergy: UILabel!
    var user:User!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        stasticView.isHidden = true
        let baseUseNum = user.BMR
        let sportUseNum = user.healthInfo.energy
        baseUse.text! = "基本消耗"+String(Int(baseUseNum))+"KCal"
        sportUse.text! = "运动消耗"+String(Int(sportUseNum))+"KCal"
        progressView.setProgress(baseUseNum/(baseUseNum+sportUseNum), animated: true)
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 7.0)
        floorsText.text = String(user.healthInfo.floors)+"层"
        //floorsText.textColor = user.colorTheme
        distanceText.text = String(format: "%.2f", user.healthInfo.distance)+"KM"
        //distanceText.textColor = user.colorTheme
        stepsText.text = String(user.healthInfo.steps)+"步"
        //stepsText.textColor = user.colorTheme
        usedText.text = String(Int(user.healthInfo.energy))+"Kcal"
        //usedText.textColor = user.colorTheme
        
    }


    @IBAction func returnhealth(_ sender: Any) {
        stasticView.isHidden = true
    }
    @IBAction func showStatic(_ sender: Any) {
        stasticView.isHidden = false
        
        let energyRate = [[880,816],[888,619],[980,600],[962,746],[667,603],[814,746],[824,976]]
        let color = UIColor(red: 29/255, green: 176/255, blue: 184/255, alpha: 0.8)
        upLabel.textColor = color.withAlphaComponent(0.3)
        downlabel.textColor = color.withAlphaComponent(0.3)
        //circle
        let shaperLayer = CAShapeLayer()
        shaperLayer.frame = view.bounds
        shaperLayer.strokeColor = color.cgColor
        shaperLayer.fillColor = UIColor.clear.cgColor
        shaperLayer.lineWidth = 10
        shaperLayer.path = UIBezierPath(roundedRect: CGRect(x:8,y:323,width:20,height:20), cornerRadius: 10).cgPath
        stasticView.layer.addSublayer(shaperLayer)
        let  drawCircle = CABasicAnimation(keyPath: "strokeEnd")
        drawCircle.duration = 0.5
        drawCircle.fromValue = 0
        drawCircle.toValue = 1
        drawCircle.timingFunction = nil
        shaperLayer.add(drawCircle, forKey: "drawCircle")
        //line
        let lineLayer = CAShapeLayer()
        lineLayer.frame = view.bounds
        lineLayer.strokeColor = color.cgColor
        lineLayer.lineWidth = 6
        lineLayer.fillColor = UIColor.clear.cgColor
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: view.center.y))
        path.addLine(to: CGPoint(x: view.bounds.width, y: view.center.y))
        lineLayer.path = path
        stasticView.layer.addSublayer(lineLayer)
        let drawLine = CABasicAnimation(keyPath: "strokeEnd")
        drawLine.duration = 0.5
        drawLine.fromValue = 0
        drawLine.toValue = 1
        drawLine.timingFunction = nil
        lineLayer.add(drawLine, forKey: "drawLine")
        //bar
        let barLayer = CAShapeLayer()
        barLayer.frame = view.bounds
        barLayer.lineWidth = 10
        barLayer.strokeColor = UIColor(red: 25/255, green: 176/255, blue: 118/255, alpha: 0.8).cgColor
        barLayer.fillColor = UIColor.clear.cgColor
        let multiPath = CGMutablePath()
        for i in 0..<7{
            multiPath.move(to: CGPoint(x: CGFloat(50+i*50), y: view.center.y - 3))
            let height:CGFloat = CGFloat(energyRate[i][0]/5)
            multiPath.addLine(to: CGPoint(x: CGFloat(50+i*50), y: view.center.y - 3 - height))
            barLayer.path = multiPath
        }
        stasticView.layer.addSublayer(barLayer)
        let drawBar = CABasicAnimation(keyPath: "strokeEnd")
        drawBar.duration = 0.8
        drawBar.fromValue = 0
        drawBar.toValue = 1
        drawBar.timingFunction = nil
        barLayer.add(drawBar, forKey: "drawBar")
        
        let barLayer2 = CAShapeLayer()
        barLayer2.frame = view.bounds
        barLayer2.lineWidth = 10
        barLayer2.strokeColor = UIColor(red: 255/255, green: 15/255, blue: 51/255, alpha: 0.8).cgColor
        barLayer2.fillColor = UIColor.clear.cgColor
        let multiPath2 = CGMutablePath()
        for i in 0..<7{
            multiPath2.move(to: CGPoint(x: CGFloat(60+i*50), y: view.center.y + 3))
            let height:CGFloat = CGFloat(energyRate[i][1]/5)
            multiPath2.addLine(to: CGPoint(x: CGFloat(60+i*50), y: view.center.y + 3 + height))
            barLayer2.path = multiPath2
        }
        stasticView.layer.addSublayer(barLayer2)
        let drawBar2 = CABasicAnimation(keyPath: "strokeEnd")
        drawBar2.duration = 0.8
        drawBar2.fromValue = 0
        drawBar2.toValue = 1
        drawBar2.timingFunction = nil
        barLayer2.add(drawBar2, forKey: "drawBar")
        //stateline
        let lineLayer1 = CAShapeLayer()
        lineLayer1.frame = view.bounds
        lineLayer1.strokeColor = color.withAlphaComponent(0.3).cgColor
        lineLayer1.lineWidth = 1
        lineLayer1.fillColor = UIColor.clear.cgColor
        let path1 = CGMutablePath()
        path1.move(to: CGPoint(x: 30, y: view.center.y - 140))
        path1.addLine(to: CGPoint(x: view.bounds.width, y: view.center.y - 140))
        lineLayer1.path = path1
        stasticView.layer.addSublayer(lineLayer1)
        let drawLine1 = CABasicAnimation(keyPath: "strokeEnd")
        drawLine1.duration = 0.5
        drawLine1.fromValue = 0
        drawLine1.toValue = 1
        drawLine1.timingFunction = nil
        lineLayer1.add(drawLine1, forKey: "drawLine")
        
        let lineLayer2 = CAShapeLayer()
        lineLayer2.frame = view.bounds
        lineLayer2.strokeColor = color.withAlphaComponent(0.3).cgColor
        lineLayer2.lineWidth = 1
        lineLayer2.fillColor = UIColor.clear.cgColor
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 30, y: view.center.y + 140))
        path2.addLine(to: CGPoint(x: view.bounds.width, y: view.center.y + 140))
        lineLayer2.path = path2
        stasticView.layer.addSublayer(lineLayer2)
        let drawLine2 = CABasicAnimation(keyPath: "strokeEnd")
        drawLine2.duration = 0.5
        drawLine2.fromValue = 0
        drawLine2.toValue = 1
        drawLine2.timingFunction = nil
        lineLayer2.add(drawLine2, forKey: "drawLine")
        
        //圆圈动画
        
        let shaperLayer2 = CAShapeLayer()
        shaperLayer2.frame = view.bounds
        shaperLayer2.strokeColor = user.colorTheme.cgColor
        shaperLayer2.fillColor = UIColor.clear.cgColor
        shaperLayer2.lineWidth = 5
        shaperLayer2.path = UIBezierPath(arcCenter: totalEnergy.center, radius: 50, startAngle: CGFloat(3*Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true).cgPath
        stasticView.layer.addSublayer(shaperLayer2)
        let  draw = CABasicAnimation(keyPath: "strokeEnd")
        draw.duration = 0.8
        draw.fromValue = 0
        draw.toValue = 1
        draw.timingFunction = nil
        draw.isRemovedOnCompletion = false
        shaperLayer2.add(draw, forKey: "draw")
        totalEnergy.text = "322KCal"
        totalEnergy.textColor = user.colorTheme
        
    }
    @IBAction func touch(_ sender: Any) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back2"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
    }

    @IBAction func `return`(_ sender: Any) {
        self.performSegue(withIdentifier: "back2", sender: self)
    }
}
