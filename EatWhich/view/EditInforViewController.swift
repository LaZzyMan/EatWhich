//
//  EditInforViewController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/14.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class EditInforViewController: UIViewController,UITextFieldDelegate {
    var user = User()
    @IBOutlet weak var submitStyle: UIButton!
    @IBOutlet weak var nameField: UITextField!//姓名
    @IBOutlet weak var theSex: UISegmentedControl!//性别
    @IBOutlet weak var theBirth: UIDatePicker!//生日
    @IBOutlet weak var theHight: UISlider!//身高
    @IBOutlet weak var theWeight: UISlider!//体重
    
    //获取身高体重
    @IBOutlet weak var displayHight: UILabel!
    @IBOutlet weak var displayWeight: UILabel!
    var birthYear:Int = 0
    var birthMonth:Int = 0
    var birthDay:Int = 0
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        //设置按钮样式
        submitStyle.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
        submitStyle.layer.borderWidth = 2
        submitStyle.layer.cornerRadius = 12;
        submitStyle.layer.masksToBounds = true
        nameField.text = user.name
        theSex.selectedSegmentIndex = user.gender==true ? 1 : 0
        theBirth.date = user.birthday
        theHight.setValue(Float(user.height), animated: true)
        theWeight.setValue(Float(user.weight), animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitAction(_ sender: UIButton) {
        
        //在此获取用户输入的新的信息值
        user.gender = theSex.selectedSegmentIndex==1 ? true : false
        user.birthday = theBirth.date
        user.name = nameField.text!
        user.height = Int32(theHight.value)
        user.weight = Int32(theWeight.value)
        if user.editUserInfo() != 0{
            let alertController = UIAlertController(title: "系统提示",message: "修改成功！", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: {
                action in
                self.performSegue(withIdentifier: "backToInfo", sender: self)
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "系统提示",message: "网络错误", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: {
                action in
                self.performSegue(withIdentifier: "backToInfo", sender: self)
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func getHight(_ sender: UISlider) {
        let i = Int(sender.value)
        sender.value = Float(i)
        displayHight.text = "\(i)cm"
        user.height = Int32(i)
    }
    
    @IBAction func getWeight(_ sender: UISlider) {
        let i = Int(sender.value)
        sender.value = Float(i)
        displayWeight.text = "\(i)kg"
        user.weight = Int32(i)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToInfo"{
            if let a = segue.destination as? InformationViewController{
                a.user = user
            }
        }
    }
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "backToInfo", sender: self)    }
    
}
