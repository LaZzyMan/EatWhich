//
//  WaterView.swift
//  EatWhich
//
//  Created by seirra on 2017/9/12.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class WaterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //波浪宽度
    var waveWidth : CGFloat = 0
    //波浪颜色
    var waveColor : UIColor = .green
    //水纹振幅
    var waveA : CGFloat = 1.0
    //水纹周期
    var waveW : CGFloat = 1 / 30.0
    //位移
    var offsetX : CGFloat = 0
    //当前波浪高度Y
    var currentWaveK : CGFloat = 0
    //水纹速度
    var waveSpeed : CGFloat = 0
    //水纹宽度
    var waterWidth : CGFloat = 0
    //状态值
    var state: Int = 0
    //颜色表
    let colors = [[UIColor(red: 29/255, green: 176/255, blue: 184/255, alpha: 0.5),UIColor(red: 55/255, green: 198/255, blue: 192/255, alpha: 0.5),UIColor(red: 208/255, green: 233/255, blue: 255/255, alpha: 0.5)],
                  [UIColor(red: 55 / 255.0, green: 202 / 255.0, blue: 123 / 255.0, alpha: 0.5),UIColor(red: 50 / 255.0, green: 200 / 255.0, blue: 110 / 255.0, alpha: 0.5),UIColor(red: 60 / 255.0, green: 230 / 255.0, blue: 120 / 255.0, alpha: 0.5)],
                  [UIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 0.5) ,UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 0.5), UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 0.5)]]
    //定时器
    lazy var displayLink : CADisplayLink = CADisplayLink()
    //第一个Layer
    var firstWaveLayer : CAShapeLayer!
    //第二个Layer
    var secondWaveLayer : CAShapeLayer!
    //第三个Layer
    var thirdWaveLayer : CAShapeLayer!
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, state:Int) {
        super.init(frame: frame)
        self.state = state
        backgroundColor = UIColor.clear
        layer.masksToBounds = true
        //第一个Layer
        firstWaveLayer = CAShapeLayer.createWithFillColor(colors[state][0].cgColor)
        //第二个Layer
        secondWaveLayer = CAShapeLayer.createWithFillColor(colors[state][1].cgColor)
        //第三个Layer
        thirdWaveLayer = CAShapeLayer.createWithFillColor(colors[state][2].cgColor)
        setupUI()
        //添加上浮动画
        let upwardAnimation = CABasicAnimation(keyPath: "position")
        upwardAnimation.duration = 0.5
        upwardAnimation.fromValue = CGPoint(x: self.center.x, y: 3*center.y)
        upwardAnimation.toValue = CGPoint(x: self.center.x, y: center.y)
        upwardAnimation.isRemovedOnCompletion = false
        upwardAnimation.autoreverses = false
        layer.add(upwardAnimation, forKey: "upward")
    }
    func setupUI(){
        //设置基本信息
        //水纹宽度
        waterWidth = bounds.width
        //波浪速度
        waveSpeed = 0.4 / CGFloat(Double.pi)
        //设置波浪流动速度
        waveSpeed = 0.05
        //设置振幅
        waveA = 9
        //设置周期
        waveW = 2 * CGFloat(Double.pi) / bounds.width
        //设置波浪纵向位置
        currentWaveK = bounds.height*(0.75-0.25*CGFloat(state))
        
        //添加Layer
        layer.addSublayer(firstWaveLayer)
        layer.addSublayer(secondWaveLayer)
        layer.addSublayer(thirdWaveLayer)
        
        //开启定时器
        displayLink = CADisplayLink(target: self, selector: #selector(getCurrentWave(disPlayLink:)))
        displayLink.add(to: RunLoop.current, forMode: .commonModes)
    }
    func getCurrentWave(disPlayLink : CADisplayLink) {
        //实时位移
        offsetX += waveSpeed
        
        //设置路径
        setWavePath()
    }
    
    func setWavePath(){
        firstWaveLayer.path = drawPath(offset: 0)
        secondWaveLayer.path = drawPath(offset: -waterWidth * 0.5)
        thirdWaveLayer.path = drawPath(offset: waterWidth * 0.8)
    }
    
    func drawPath(offset : CGFloat) -> CGPath {
        let path = CGMutablePath()
        var y = currentWaveK
        
        path.move(to: CGPoint(x: 0, y: y))
        
        for i in 0...Int(waterWidth) {
            y = waveA * sin(waveW * CGFloat(i) + offsetX + offset) + currentWaveK
            path.addLine(to: CGPoint(x: CGFloat(i), y: y))
        }
        
        path.addLine(to: CGPoint(x: waterWidth, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.closeSubpath()
        return path
    }
    
}

extension CAShapeLayer {
    class func createWithFillColor(_ fillColor : CGColor) -> CAShapeLayer{
        let layer = CAShapeLayer()
        layer.fillColor = fillColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 0.8
        return layer
    }

}
