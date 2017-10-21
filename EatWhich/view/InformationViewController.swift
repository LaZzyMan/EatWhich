//
//  InformationViewController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/13.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    
    var user = User()
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var editInforStyle: UIButton!
    @IBOutlet weak var sexLabel: UILabel!//性别
    @IBOutlet weak var birthLabel: UILabel!//生日
    @IBOutlet weak var hightLabel: UILabel!//身高
    @IBOutlet weak var weightLabel: UILabel!//体重
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置按钮样式
        editInforStyle.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
        editInforStyle.layer.borderWidth = 2
        editInforStyle.layer.cornerRadius = 12
        editInforStyle.layer.masksToBounds = true
        sexLabel.text = user.gender == true ? "男" : "女"
        birthLabel.text = user.birthday.description
        hightLabel.text = String(user.height)
        weightLabel.text = String(user.weight)
        name.text = user.name
        headImage.image = user.headImage
        headImage.layer.cornerRadius = 75
        headImage.layer.masksToBounds = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func `return`(_ sender: Any) {
        self.performSegue(withIdentifier: "back1", sender: self)
    }
    @IBAction func toEdit(_ sender: Any) {
         self.performSegue(withIdentifier: "toEditView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditView"{
            if let a = segue.destination as? EditInforViewController{
                a.user = self.user
            }
        }
        if segue.identifier == "back1"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
    }
}
