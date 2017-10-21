//
//  ThirdRegisterController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/18.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class ThirdRegisterController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var registerStyle: UIButton!
    var newUser:User = User()
    var password = String()
    var state = -1
    var identityCode:String?
    
    //获取用户名和密码
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        info1.delegate = self
        info2.delegate = self
        nameTextField.delegate = self
        registerStyle.layer.borderColor = UIColor(red: 25/255, green: 148/255, blue: 117/255, alpha: 0.8).cgColor
        registerStyle.layer.borderWidth = 2
        registerStyle.layer.cornerRadius = 12;
        registerStyle.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        if self.state == -1{
            headImageView.isHidden = true
            state = 0
            newUser.name = nameTextField.text!
            self.progress.setProgress(0.25, animated: true)
            return
        }
        if self.state == 0{
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
            self.state = 2
            newUser.height = (info1.text! as NSString).intValue
            newUser.weight = (info2.text! as NSString).intValue
            birthdatAndGenderview.isHidden = false
            nextButton.setTitle("下一步", for: UIControlState.normal)
            self.progress.setProgress(0.75, animated: true)
            return
        }
        if self.state == 2{
            self.state = 3
            newUser.gender = genderSelect.selectedSegmentIndex == 0 ? true : false
            newUser.birthday = birthdayCalendar.date
            self.progress.setProgress(1, animated: true)
            return
        }
        if self.state == 3{
            self.emailView.isHidden = false
            nextButton.setTitle("完成注册", for: UIControlState.normal)
            if identityCode == identityTextField.text{
                let registerResult = self.registerToserver()
                if registerResult == 1{
                    self.performSegue(withIdentifier: "registerToLogin", sender: nil)
                }else{
                    let alertController = UIAlertController(title: "系统提示",message: "网络错误", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
                let alertController = UIAlertController(title: "系统提示",message: "验证码错误", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                identityTextField.text = ""
            }
        }
    }
    
    @IBAction func registerBack(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerToLogin", sender: self)
    }
    
    //回收键盘
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            info1.resignFirstResponder()
            info2.resignFirstResponder()
            nameTextField.resignFirstResponder()
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
  
    @IBAction func keyBoardReturn(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //注册到服务器
    func registerToserver() -> Int{
        let fileManager:FileManager = FileManager.default
        fileManager.createFile(atPath: NSHomeDirectory()+"/headimage.png", contents: UIImagePNGRepresentation(newUser.headImage), attributes: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let headers = [
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "cache-control": "no-cache",
            "postman-token": "20b4efa1-39fc-5668-6bdf-c32b3e84d758"
        ]
    
        let parameters = [
            [
                "name": "username",
                "value": self.newUser.userName
            ],
            [
                "name": "password",
                "value": self.password
            ],
            [
                "name": "name",
                "value": self.newUser.name
            ],
            [
                "name": "gender",
                "value": "\(self.newUser.gender)"
            ],
            [
                "name": "height",
                "value": "\(newUser.height)"
            ],
            [
                "name": "weight",
                "value": "\(newUser.weight)"
            ],
            [
                "name": "birthday",
                "value": dateFormatter.string(from: newUser.birthday)
            ],
            [
                "name": "email",
                "value": newUser.email
            ],
            [
                "name": "headimage",
                "fileName": NSHomeDirectory()+"headimage.png"
            ]
        ] as [[String:String]]
        
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        var body = ""
        let error: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                var fileContent:String?
                do{
                    fileContent = try String(contentsOfFile: filename, encoding: .utf8)
                }catch{
                    fileContent = nil
                }
                if (error != nil) {
                    print(error!)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent!
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/eat/api/v1.0/register")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = body.data(using: .utf8)
        
        let session = URLSession.shared
        var connstatus = 0
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                NSLog(error.debugDescription)
            } else {
                let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                connstatus = json?.object(forKey: "status") as! Int
            }
        })
        
        dataTask.resume()
        return connstatus
    }
   
}
