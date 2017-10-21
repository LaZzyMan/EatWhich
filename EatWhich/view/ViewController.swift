//
//  ViewController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/12.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var loginStyle: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
   
    
    @IBOutlet weak var userName: UITextField!//
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var result_1: UILabel!//
    var userLogin:User = User()
    var path:URL = URL(fileURLWithPath: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        passWord.delegate = self
        
        
        //设置按钮样式
        loginStyle.layer.borderWidth = 2
        loginStyle.layer.masksToBounds = true
        loginStyle.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
        loginStyle.layer.cornerRadius = 12
        //设置图片圆形显示
        mainImage.layer.cornerRadius = 60
        mainImage.layer.masksToBounds = true
        mainImage.layer.borderWidth = 0
        mainImage.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    //显示密码
    @IBAction func eyeLook(_ sender: Any) {
        passWord.isSecureTextEntry = false
    }
    
    //登录按钮
    @IBAction func login_Click(_ sender: Any) {
        let username = userName.text!
        let password = passWord.text!
        let parameters = ["username":username,"password":password] as [String : Any]
        let headers = [
            "content-type": "application/json",
            "authorization": "Basic eno6MjAxNzA3MzE=",
            "cache-control": "no-cache",
            "postman-token": "609cf8e1-cad3-dae1-8d6e-b1e459216599"
        ]
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/eat/api/v1.0/login")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    NSLog(error.debugDescription)
                } else {
                    let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    let status = json?.object(forKey: "status") as! Int
                    if status == 0{
                        let alertController = UIAlertController(title: "系统提示",message: "用户名或密码错误！", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                        self.userName.text = ""
                        self.passWord.text = ""
                    }else{
                        self.userLogin.initWithJson(with: json?.object(forKey: "user") as AnyObject)
                        self.performSegue(withIdentifier: "myLogin", sender: self)
                    }
                }
            })
            dataTask.resume()
        }
        catch let error{
            NSLog("JSON失败\(error)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func nextEdit(_ sender: Any) {
        self.userName.resignFirstResponder()
        self.passWord.becomeFirstResponder()
    }
    
    @IBAction func finishEdit(_ sender: Any) {
        self.passWord.resignFirstResponder()
    }
    @IBAction func register_Click(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRegister", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myLogin" {
            if let a = segue.destination as? mainViewController {
                userLogin.healthInfo.updateUserData()
                a.user = userLogin
            }
        }
    }
    
}

