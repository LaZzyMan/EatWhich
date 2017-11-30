//
//  ViewController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/12.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var loginStyle: UIButton!
    @IBOutlet weak var errorInfoLabel: UILabel!
    @IBOutlet weak var userName: UITextField!//
    @IBOutlet weak var passWord: UITextField!
    var userLogin:User = User()
    var path:URL = URL(fileURLWithPath: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        passWord.delegate = self
        progressView.stopAnimating()
        errorInfoLabel.isHidden = true
        Thread.sleep(forTimeInterval: 1.5)
        //设置按钮样式
        /*
        loginStyle.layer.borderWidth = 2
        loginStyle.layer.masksToBounds = true
        loginStyle.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
        loginStyle.layer.cornerRadius = 12
        //设置图片圆形显示
        
        mainImage.layer.cornerRadius = 60
        mainImage.layer.masksToBounds = true
        mainImage.layer.borderWidth = 0
        mainImage.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //登录按钮
    @IBAction func login_Click(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        self.progressView.startAnimating()
        //创建新线程登陆服务
        DispatchQueue.main.async(execute: {
            self.login()
        })
    }
    //登陆到服务器，返回0:成功，1:用户名密码错误，2:网络连接失败
    func login(){
        let username = userName.text!
        let password = passWord.text!
        let headers = [
            "authorization": "Basic eGp5OjIwMTcwNzI0",
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "ee43bdf3-ee2a-7154-7594-1a0a63de0eb1"
        ]
        let parameters = [
            "userID": username,
            "password": password
            ] as [String : Any]
        
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/api/v2.0/login")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    NSLog(error.debugDescription)
                    DispatchQueue.main.async(execute: {
                        self.errorInfoLabel.isHidden = false
                        self.errorInfoLabel.text = "网络错误"
                        self.progressView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        })
                } else {
                    let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    let status = json?.object(forKey: "result") as! String
                    if status != "True"{
                        DispatchQueue.main.async(execute: {
                            self.userName.text = ""
                            self.passWord.text = ""
                            self.errorInfoLabel.isHidden = false
                            self.errorInfoLabel.text = "用户名或密码错误！"
                            self.progressView.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            })
                    }else{
                        self.userLogin.initWithJson(with: json?.object(forKey: "user") as AnyObject)
                        DispatchQueue.main.async(execute: {
                            self.progressView.stopAnimating()
                            self.performSegue(withIdentifier: "myLogin", sender: self)
                            })
                    }
                }
            })
            dataTask.resume()
        }
        catch let error{
            NSLog("JSON失败\(error)")
            DispatchQueue.main.async(execute: {
                self.errorInfoLabel.isHidden = false
                self.errorInfoLabel.text = "网络错误"
                })
        }
    }
    //键盘回收
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
    //注册按钮相应
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

