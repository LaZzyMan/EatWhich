//
//  NavigationViewController.swift
//  EatWhich
//
//  Created by seirra on 2017/9/9.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController, BMKMapViewDelegate, BNNaviRoutePlanDelegate, BNNaviUIManagerDelegate {
    var routePlan = [BNRoutePlanNode]()
    var user:User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BNCoreServices.routePlanService().startNaviRoutePlan(BNRoutePlanMode_Recommend, naviNodes: routePlan, time: nil, delegete: self, userInfo: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func routePlanDidFinished(_ userInfo: [AnyHashable: Any]!) {
        BNCoreServices.uiService().showPage(BNaviUI_NormalNavi, delegate: self, extParams: nil)
    }
    
    func onExitPage(_ pageType: BNaviUIType, extraInfo: [AnyHashable : Any]!) {
        self.performSegue(withIdentifier: "finishNavigation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishNavigation"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
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
