//
//  HelpViewController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/16.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    var user:User!

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back3"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
    }
    
    @IBAction func `return`(_ sender: Any) {
        self.performSegue(withIdentifier: "back3", sender: self)
    }

    

}
