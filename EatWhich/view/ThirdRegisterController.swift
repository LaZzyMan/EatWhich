//
//  ThirdRegisterController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/18.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class ThirdRegisterController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var newUser:User = User()
    var password = String()
    var state = -1
    var identityCode:String?
    
    @IBOutlet weak var registerStyle: UIButton!
    @IBOutlet weak var errorInfoLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var labelMain: UILabel!
    @IBOutlet weak var info1: UITextField!
    @IBOutlet weak var info2: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var birthdatAndGenderview: UIView!
    @IBOutlet weak var headImageView: UIView!
    @IBOutlet weak var genderSelect: UISegmentedControl!
    @IBOutlet weak var birthdayCalendar: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var unChooseLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var identityTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var waitCircle: UIActivityIndicatorView!
    //从相册选择图片或使用相机拍照
    @IBAction func chooseFromPhotos(_ sender: Any) {
        let actionSheet = UIAlertController(title: "上传头像", message: nil, preferredStyle: .actionSheet)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let takePhotos = UIAlertAction(title: "拍照", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            //判断是否能进行拍照，可以的话打开相机
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
            else
            {
                NSLog("相机不可用");
            }
        })
        let selectPhotos = UIAlertAction(title: "相册选取", style: .default, handler: {
            (action:UIAlertAction)
            -> Void in
            //调用相册功能，打开相册
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }else{
                NSLog("相册不可用")
            }
        })
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        self.present(actionSheet, animated: true, completion: nil)
    }
    //选择图片窗口
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        
        //当选择的类型是图片
        if type == "public.image"
        {
            /*
            DispatchQueue.main.async {
                let image = self.fixOrientation((info[UIImagePickerControllerOriginalImage] as! UIImage))
                self.newUser.headImage = image
                self.headImage.image = image
                self.unChooseLabel.isHidden = true
            }*/
            picker.dismiss(animated: true, completion: (
                {let image = self.fixOrientation((info[UIImagePickerControllerOriginalImage] as! UIImage))
                self.newUser.headImage = image
                self.headImage.image = image
                self.unChooseLabel.isHidden = true}
            ))
        }
    }
    //裁剪图片
    func fixOrientation(_ aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation == .up {
            return aImage
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
        default:
            break
        }
        
        switch aImage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        
        
        
        let ctx: CGContext = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: aImage.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width))
        default:
            ctx.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }
    
    
    //下一步按钮响应函数
    @IBAction func registerAction(_ sender: UIButton) {
        //state代表注册进度
        if self.state == -1{
            //输入完整性检查
            if(nameTextField.text == nil){
                errorInfoLabel.isHidden=false
                errorInfoLabel.text = "请输入昵称！"
                return
            }
            //完成头像选取
            errorInfoLabel.isHidden = true
            headImageView.isHidden = true
            state = 0
            newUser.name = nameTextField.text!
            self.progress.setProgress(0.25, animated: true)
            return
        }
        if self.state == 0{
            //输入完整性检查
            if(info1.text == nil||info2.text == nil){
                errorInfoLabel.isHidden=false
                errorInfoLabel.text = "请填写用户名/密码！"
                return
            }
            //完成用户名密码输入
            errorInfoLabel.isHidden = true
            newUser.userName = info1.text!
            password = info2.text!
            labelMain.text = "请输入您的健康信息"
            label1.text = "身高/cm"
            label2.text = "体重/kg"
            self.state = 1
            info1.text = ""
            info2.text = ""
            info1.keyboardType = .numberPad
            info2.keyboardType = .numberPad
            info2.isSecureTextEntry = false
            nextButton.setTitle("下一步", for: UIControlState.normal)
            self.progress.setProgress(0.5, animated: true)
            return
            
        }
        if self.state == 1{
            if(info1.text == nil||info2.text == nil){
                errorInfoLabel.isHidden=false
                errorInfoLabel.text = "请完整填写健康信息！"
                return
            }
            //完成健康信息输入
            errorInfoLabel.isHidden = true
            self.state = 2
            newUser.height = (info1.text! as NSString).intValue
            newUser.weight = (info2.text! as NSString).intValue
            birthdatAndGenderview.isHidden = false
            nextButton.setTitle("下一步", for: UIControlState.normal)
            self.progress.setProgress(0.75, animated: true)
            return
        }
        if self.state == 2{
            //完成性别和生日信息输入
            self.state = 3
            newUser.gender = genderSelect.selectedSegmentIndex == 0 ? true : false
            newUser.birthday = birthdayCalendar.date
            self.progress.setProgress(1, animated: true)
            self.emailView.isHidden = false
            nextButton.setTitle("完成注册", for: UIControlState.normal)
            return
        }
        if self.state == 3{
            if(emailTextField.text == nil){
                errorInfoLabel.isHidden=false
                errorInfoLabel.text = "请填写电子邮件地址！"
                return
            }
            DispatchQueue.main.async(execute: {
                self.confirmEmail()
            })
        }
    }
    //返回登陆界面
    @IBAction func registerBack(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerToLogin", sender: self)
    }
    
    //回收键盘
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            info1.resignFirstResponder()
            info2.resignFirstResponder()
            nameTextField.resignFirstResponder()
            emailTextField.resignFirstResponder()
            identityTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func nextEdit(_ sender: Any) {
        self.info1.resignFirstResponder()
        self.info2.becomeFirstResponder()
    }
  
    //邮件发送响应按钮
    @IBAction func sendEmailButton(_ sender: Any) {
        waitCircle.startAnimating()
        DispatchQueue.main.async(execute: {
            self.registerToserver()
            self.uploadImage()
            self.sendEmail()
        })
    }
    @IBAction func keyBoardReturn(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //注册到服务器
    func registerToserver(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let headers = [
            "content-type": "application/json",
            "authorization": "Basic eGp5OjIwMTcwNzI0",
            "cache-control": "no-cache",
            "postman-token": "437228ac-ed70-cf35-c39f-332f10a3190c"
        ]
        let parameters = [
            "userID": newUser.userName,
            "password": password,
            "name": newUser.name,
            "email": newUser.email,
            "weight": newUser.weight,
            "height": newUser.height,
            "gender": newUser.gender == true ? 1 : 0,
            "birthday": dateFormatter.string(from: newUser.birthday),
            "remind": 1
            ] as [String : Any]
        
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/api/v2.0/register")! as URL,
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
                        self.errorInfoLabel.text = "网络异常"
                        self.errorInfoLabel.isHidden = false
                        self.waitCircle.stopAnimating()
                    })
                } else {
                    let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    let status = json?.object(forKey: "result") as! String
                    if status != "True"{
                        DispatchQueue.main.async(execute: {
                            self.errorInfoLabel.text = "网络异常"
                            self.errorInfoLabel.isHidden = false
                            self.waitCircle.stopAnimating()
                        })
                    }
                }
            })
            dataTask.resume()
        }
        catch let error{
            NSLog("JSON失败\(error)")
        }
    }
    //发送邮件
    func sendEmail(){
        let headers = [
            "content-type": "application/json",
            "authorization": "Basic eGp5OjIwMTcwNzI0",
            "cache-control": "no-cache",
            "postman-token": "437228ac-ed70-cf35-c39f-332f10a3190c"
        ]
        let parameters = [
            "userID": newUser.userName,
            ] as [String : Any]
        
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/api/v2.0/sendmessage")! as URL,
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
                        self.errorInfoLabel.text = "邮件发送失败"
                        self.errorInfoLabel.isHidden = false
                        self.waitCircle.stopAnimating()
                    })
                } else {
                    let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    let status = json?.object(forKey: "result") as! String
                    if status != "True"{
                        DispatchQueue.main.async(execute: {
                            self.errorInfoLabel.text = "邮件发送失败"
                            self.errorInfoLabel.isHidden = false
                            self.waitCircle.stopAnimating()
                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            self.sendButton.setTitle("重新发送", for: .normal)
                            self.waitCircle.stopAnimating()
                        })
                    }
                }
            })
            dataTask.resume()
        }
        catch let error{
            NSLog("JSON失败\(error)")
        }
    }
    //验证邮箱
    func confirmEmail(){
        let headers = [
            "authorization": "Basic eGp5OjIwMTcwNzI0",
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "ee43bdf3-ee2a-7154-7594-1a0a63de0eb1"
        ]
        let parameters = [
            "userID": newUser.userName,
            "confirmnumber": identityTextField.text!
            ] as [String : Any]
        
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/api/v2.0/ensureemail")! as URL,
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
                        self.errorInfoLabel.text = "网络异常"
                        self.errorInfoLabel.isHidden = false
                    })
                } else {
                    let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    let status = json?.object(forKey: "result") as! String
                    if status != "True"{
                        DispatchQueue.main.async(execute: {
                            self.errorInfoLabel.text = "验证码错误"
                            self.errorInfoLabel.isHidden = false
                            self.identityTextField.text = ""
                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "registerToLogin", sender: nil)
                        })
                    }
                }
            })
            dataTask.resume()
        }
        catch let error{
            NSLog("JSON失败\(error)")
        }
    }
    //讲头像图片上传到服务器
    func uploadImage(){
        let data=UIImagePNGRepresentation(newUser.headImage)//把图片转成data
        let uploadurl:String="http://www.sgmy.site/api/v2.0/uploadimage"//设置服务器接收地址
        let request=NSMutableURLRequest(url:URL(string:uploadurl)!)
        request.httpMethod="POST"//设置请求方式
        let boundary:String="-------------------21212222222222222222222"
        let contentType:String="multipart/form-data;boundary="+boundary
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        let body=NSMutableData()
        //在表单中写入要上传的图片
        body.append(NSString(format:"--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Disposition:form-data;name=\"headimage\";filename=\"\(newUser.userName).jpg\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        
        //body.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(data!)
        body.append(NSString(format:"\r\n--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        //设置post的请求体
        request.httpBody=body as Data
        let que=OperationQueue()
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: que, completionHandler: {
            (response, data, error) ->Void in
            if (error != nil){
                NSLog("NetWork Unconnected")
                DispatchQueue.main.async(execute: {
                    self.errorInfoLabel.text = "网络异常"
                    self.errorInfoLabel.isHidden = false
                    self.waitCircle.stopAnimating()
                })
            }else{
                let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                let status = json?.object(forKey: "result") as! Int
                if status == 0{
                    NSLog("Upload Failed")
                    DispatchQueue.main.async(execute: {
                        self.errorInfoLabel.text = "网络异常"
                        self.errorInfoLabel.isHidden = false
                        self.waitCircle.stopAnimating()
                    })
                }
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        info1.delegate = self
        info2.delegate = self
        nameTextField.delegate = self
        errorInfoLabel.isHidden = true
        waitCircle.stopAnimating()
        registerStyle.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
        registerStyle.layer.borderWidth = 2
        registerStyle.layer.cornerRadius = 12;
        registerStyle.layer.masksToBounds = true
        progress.transform = CGAffineTransform.init(scaleX: 1.0, y: 3.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
