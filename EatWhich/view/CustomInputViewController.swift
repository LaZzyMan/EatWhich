//
//  CustomInputViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/10/21.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class CustomInputViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    var user:User!
    var selfpickerView: UIPickerView!
    var myImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selfpickerView = UIPickerView()
        selfpickerView.frame = CGRect(x:37, y:290, width:300, height:250)
        
        myImage = UIImageView()
        myImage.frame = CGRect(x:80, y:100, width:220, height:220)
        myImage.layer.cornerRadius = 20;
        myImage.layer.masksToBounds = true;
        myImage.image = UIImage(named:"1")
        selfpickerView.dataSource = self
        selfpickerView.delegate = self
        
        //设置选择框的默认值
        selfpickerView.selectRow(0,inComponent:0,animated:true)
        self.view.addSubview(selfpickerView)
        
        //建立一个按钮
        let startbtn = UIButton(frame:CGRect(x:130, y:530, width:118, height:40))
        startbtn.backgroundColor = UIColor.blue
        startbtn.setTitle("确定",for:.normal)
        startbtn.addTarget(self, action:#selector(self.getPickerViewValue),
                           for: .touchUpInside)
        startbtn.layer.borderColor = UIColor.white.cgColor
        startbtn.layer.borderWidth = 2
        startbtn.layer.cornerRadius = 12;
        self.view.addSubview(myImage)
        self.view.addSubview(startbtn)
    }
    //设置列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //设置行数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    //设置选择框各选项的内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let choose_1 = "中午好像吃多了"
        let choose_2 = "今天真的好饿嘛"
        let choose_3 = "运动时没带手机"
        if(row == 0){
            return choose_1}
        else if(row == 1){
            return choose_2}
        else{
            return choose_3}
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
        switch (row) {
        case 0:
            myImage.image = #imageLiteral(resourceName: "adjustOp_1")
        case 1:
            myImage.image = #imageLiteral(resourceName: "adjustOp_2")
        case 2:
            myImage.image = #imageLiteral(resourceName: "adjustOp_3")
        default:
            break;
        }
    }
    
    //触摸按钮时，获得被选中的索引
    func getPickerViewValue(){
        let message = String(selfpickerView.selectedRow(inComponent: 0))
        if(message == "adjustOp_1"){
            //中午吃多了-----减量
        }
        else if(message == "adjustOp_2"){
            //饿----加量
        }
        else{
            //没带手机---加量
        }
        self.performSegue(withIdentifier: "enterRecommand", sender: self.user)
    }
    @IBAction func customBack(_ sender: Any) {
        self.performSegue(withIdentifier: "customBack", sender: self.user)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterRecommand"{
            if let a = segue.destination as? WaitViewController{
                a.user = sender as! User
            }
        }
        if segue.identifier == "customBack"{
            if let a = segue.destination as? mainViewController{
                a.user = sender as? User
            }
        }
    }
}
