//
//  FriendViewController.swift
//  EatWhich
//
//  Created by apple on 2017/11/30.
//  Copyright © 2017年 zz. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var user:User!
    var friends = [Friend]()
    var selectedIndex = [Int]()

    @IBOutlet weak var groupCollection: UICollectionView!
    @IBOutlet weak var friendTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTableView.delegate=self
        friendTableView.dataSource=self
        groupCollection.dataSource=self
        groupCollection.delegate=self
        friends.append(Friend(name: "绿毛虫", state: "今日晚餐推荐：果腹", image: #imageLiteral(resourceName: "tmpHead1")))
        friends.append(Friend(name: "皮卡丘", state: "今日晚餐推荐：饱食", image: #imageLiteral(resourceName: "tmpHead2")))
        friends.append(Friend(name: "比比鸟", state: "今日晚餐推荐：饱食", image: #imageLiteral(resourceName: "tmpHead3")))
        friends.append(Friend(name: "小火龙", state: "今日晚餐推荐：少食", image: #imageLiteral(resourceName: "tmpHead4")))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back3"{
            if let a = segue.destination as? mainViewController{
                a.user = self.user
            }
        }
        if segue.identifier == "groupRecommend"{
            if let a = segue.destination as? WaitViewController{
                a.user = self.user
            }
        }
    }
    
    @IBAction func `return`(_ sender: Any) {
        self.performSegue(withIdentifier: "back3", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //delegate
    
    //dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendTableViewCell
        friendCell.nameLabel.text! = friends[indexPath.row].name
        friendCell.infoLabel.text! = friends[indexPath.row].state
        if selectedIndex.contains(indexPath.row){
            friendCell.accessoryType = .checkmark
        }else{
            friendCell.accessoryType = .none
        }
        friendCell.haedImageView.image = friends[indexPath.row].headImage
        return friendCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedIndex.index(of:indexPath.row){
            selectedIndex.remove(at: index)
            tableView.reloadData()
            //collection中删除头像
            groupCollection.reloadData()
            
        }else{
            selectedIndex.append(indexPath.row)
            tableView.reloadData()
            //collection中添加头像
            groupCollection.reloadData()
        }
    }
    //collection datasource protrcol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedIndex.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let friendCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCollectionCell", for: indexPath) as! FriendCollectionViewCell
        friendCollectionCell.headImageView.image = friends[selectedIndex[indexPath.item]].headImage
        return friendCollectionCell
    }
    @IBAction func getRecommend(_ sender: Any) {
        self.performSegue(withIdentifier: "friendCollectionCell", sender: self)
    }
}
