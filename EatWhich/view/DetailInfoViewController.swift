//
//  DetailInfoViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/9/14.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class DetailInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var swipeLeft :UISwipeGestureRecognizer!;   // 左滑手势
    var user:User!
    var restaurant:AnyObject!
    var recipes:[[String:Any]]!
    var currentLocation:CLLocationCoordinate2D!
    var restaurantPt:CLLocationCoordinate2D!
    var totalHot:Int!
    var selectedIndex = [Int]()

    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tasteLabel: UILabel!
    @IBOutlet weak var servicelabel: UILabel!
    @IBOutlet weak var environmentLabel: UILabel!
    @IBOutlet weak var teleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var followMeButton: UIButton!
    @IBOutlet weak var takeOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recommand: UILabel!
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var ofo: UIImageView!
    @IBOutlet weak var meituan: UIImageView!
    @IBOutlet weak var didi: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseView.layer.cornerRadius = 20
        chooseView.layer.masksToBounds = true
        chooseView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        chooseView.layer.borderColor = UIColor.black.cgColor
        chooseView.layer.borderWidth = 2
        totalHot = 0
        upView.backgroundColor = user.colorTheme
        followMeButton.layer.masksToBounds = true
        followMeButton.setTitleColor(user.colorTheme, for: .normal)
        followMeButton.layer.cornerRadius = 25
        takeOutButton.layer.masksToBounds = true
        takeOutButton.setTitleColor(user.colorTheme, for: .normal)
        takeOutButton.layer.cornerRadius = 25
        nameLabel.text = restaurant.object(forKey: "name") as? String
        teleLabel.text = "电话"+(restaurant.object(forKey: "tel") as? String)!
        addressLabel.text = "地址："+(restaurant.object(forKey: "address") as? String)!
        typeLabel.text = "类型："+(restaurant.object(forKey: "type") as? String)!
        priceLabel.text = "人均："+(restaurant.object(forKey: "avgPrice") as? String)!+"元"
        let rate = restaurant.object(forKey: "commentScore") as AnyObject
        servicelabel.text = "服务："+(rate.object(forKey: "service") as? String)!+"分"
        environmentLabel.text = "环境："+(rate.object(forKey: "environment") as? String)!+"分"
        tasteLabel.text = "口味："+(rate.object(forKey: "taste") as? String)!+"分"
        recipes = restaurant.object(forKey: "recipe") as? [[String:Any]]
        recommand.text = "0/"+String(format:"%d",Int(user.energyNeed))
        tableView.delegate = self
        tableView.dataSource = self
        
        swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(DetailInfoViewController.swipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

        // Do any additional setup after loading the view.
    }
    @IBAction func hideImage(_ sender: Any) {
        didi.isHidden = true
        ofo.isHidden = true
        meituan.isHidden = true
    }
    func swipe(_ recognizer:UISwipeGestureRecognizer){
        didi.isHidden = true
        ofo.isHidden = true
        meituan.isHidden = true
    }
    //delegate
    
    //dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "recipeCell")
        cell.textLabel?.text = recipes[indexPath.row]["name"] as? String
        cell.detailTextLabel?.text = "预计热量摄入：" + String(format: "%d", (recipes[indexPath.item]["hot"] as! Int)) + "KCal"
        if selectedIndex.contains(indexPath.row){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedIndex.index(of:indexPath.row){
            selectedIndex.remove(at: index)
            tableView.reloadData()
            let hot = recipes[indexPath.item]["hot"] as! Int
            totalHot = totalHot - hot
            recommand.text = String(format: "%d", totalHot) + "/" + String(format:"%d",Int(user.energyNeed))
            if( totalHot<Int(user.energyNeed)){
                recommand.textColor = UIColor.white
            }
        }else{
            selectedIndex.append(indexPath.row)
            let hot = recipes[indexPath.item]["hot"] as! Int
            totalHot = hot + totalHot
            recommand.text = String(format: "%d", totalHot) + "/" + String(format:"%d",Int(user.energyNeed))
            if( totalHot>Int(user.energyNeed)){
                recommand.textColor = UIColor.red.withAlphaComponent(0.7)
            }
            tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showChoose(_ sender: Any) {
        chooseView.isHidden = false
    }
    @IBAction func returnMain(_ sender: Any) {
        chooseView.isHidden = true
    }
    @IBAction func OnClickWalk(_ sender: Any) {
        self.performSegue(withIdentifier: "beginNavigation", sender: self)
    }
    @IBAction func didi(_ sender: Any) {
        didi.isHidden = false
    }
    @IBAction func ofo(_ sender: Any) {
        ofo.isHidden = false
    }
    @IBAction func meituan(_ sender: Any) {
        meituan.isHidden = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beginNavigation"{
            if let a = segue.destination as? NavigationViewController{
                //节点数组
                var nodesArray = [BNRoutePlanNode]()
                //起点
                let startNode = BNRoutePlanNode()
                startNode.pos = BNPosition()
                startNode.pos.x = currentLocation.longitude
                startNode.pos.y = currentLocation.latitude
                startNode.pos.eType = BNCoordinate_BaiduMapSDK;
                nodesArray.append(startNode)
                //终点
                let endNode = BNRoutePlanNode()
                endNode.pos = BNPosition()
                endNode.pos.x = restaurantPt.longitude
                endNode.pos.y = restaurantPt.latitude
                endNode.pos.eType = BNCoordinate_BaiduMapSDK;
                nodesArray.append(endNode)
                a.routePlan = nodesArray
                a.user = user
            }
        }
        if segue.identifier == "returnDetail"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
    }
    
    @IBAction func `return`(_ sender: Any) {
        self.performSegue(withIdentifier: "returnDetail", sender: nil)
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
