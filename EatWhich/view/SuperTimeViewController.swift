//
//  SuperTimeViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/9/15.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class SuperTimeViewController: UIViewController {
    var user:User!

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remindSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        //submitButton.layer.cornerRadius = 10
        //submitButton.layer.masksToBounds = true
        //submitButton.layer.borderWidth = 2
        //submitButton.layer.borderColor = user.colorTheme.cgColor
        //submitButton.setTitleColor(user.colorTheme, for: .normal)
        //openOrClose.tintColor = user.colorTheme

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back5"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
    }
    
    @IBAction func `return`(_ sender: Any) {
        self.performSegue(withIdentifier: "back5", sender: self)
    }

    
    @IBAction func submit(_ sender: Any) {
        if remindSwitch.isOn == true{
            //创建UILocalNotification来进行本地消息通知
            let localNotification = UILocalNotification()
            //推送时间（设置为30秒以后）
            localNotification.fireDate = datePicker.date
            //时区
            localNotification.timeZone = NSTimeZone.default
            //推送内容
            localNotification.alertBody = "唯有爱与美食不可辜负"
            //声音
            localNotification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(localNotification)
            self.performSegue(withIdentifier: "back5", sender: self)
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
