//
//  PageViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/9/8.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    var color = UIColor()
    var currentLocation:CLLocationCoordinate2D!
    var poi:BMKPoiInfo!
    var user:User!
    var restaurant:AnyObject!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet var background: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //background.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        nameLabel.text = restaurant.object(forKey: "name") as? String
        distance.text = "距离您"+String(format: "%d", (restaurant.object(forKey: "distance") as! Int))+"米"
        energyLabel.text = "预计热量：" + String(format: "%.2f", restaurant.object(forKey: "hot") as! Float) + "KCal"
        detailButton.layer.masksToBounds = true
        detailButton.layer.borderColor = user.colorTheme.cgColor
        //detailButton.setTitleColor(user.colorTheme, for: .normal)
        detailButton.layer.borderWidth = 2
        detailButton.layer.cornerRadius = 10
        let service = (restaurant.object(forKey: "commentScore") as AnyObject).object(forKey: "service") as! NSString
        let taste = (restaurant.object(forKey: "commentScore") as AnyObject).object(forKey: "service") as! NSString
        let environment = (restaurant.object(forKey: "commentScore") as AnyObject).object(forKey: "environment") as! NSString
        rateLabel.text = "综合评分："+String(format: "%.2f", (environment.floatValue+taste.floatValue+service.floatValue)/3)
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showDetailView(_ sender: Any) {
        self.performSegue(withIdentifier: "showDetailInfo", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailInfo"{
            if let a = segue.destination as? DetailInfoViewController{
                a.user = self.user
                a.restaurant = self.restaurant
                a.currentLocation = self.currentLocation
                a.restaurantPt = self.poi.pt
            }
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
