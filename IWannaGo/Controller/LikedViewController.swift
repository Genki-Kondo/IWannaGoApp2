//
//  LikedViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/23.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import Firebase
import ViewAnimator
class LikedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var ownLikedButton: UIButton!
    
    
    //一旦変数を格納
    var shopName :[String] = []
    var address :[String] = []
    var telNumber :[String] = []
    var station :[String] = []
    var time :[String] = []
    //お気に入り判定フラグ
    var ownLikedFrag = false
    //  userDefaultsの定義
    var userDefaults = UserDefaults.standard
    var notLikedFrag = false
    @IBOutlet var tableView: UITableView!
    
    //情報を次々に入れていくための配列
    var likedInfoArray = [Info]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchContentsData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "likedCell", for: indexPath)
        //色を変える
        if indexPath.row % 2 == 0{
            cell.backgroundColor = .systemGreen
        }else if indexPath.row % 3 == 0{
            cell.backgroundColor = .systemYellow
        }else{
            cell.backgroundColor = .systemRed
        }
        
        
        let shopNameLabel = cell.viewWithTag(1)as! UILabel
        shopNameLabel.text = likedInfoArray[indexPath.row].shopName
        let addressLabel = cell.viewWithTag(2)as! UILabel
        addressLabel.text = likedInfoArray[indexPath.row].address
        let telNumberLabel = cell.viewWithTag(3)as! UILabel
        telNumberLabel.text = likedInfoArray[indexPath.row].telNumber
        let stationLabel = cell.viewWithTag(4)as! UILabel
        stationLabel.text = likedInfoArray[indexPath.row].station+"駅"
        let timeLabel = cell.viewWithTag(5)as! UILabel
        timeLabel.text = likedInfoArray[indexPath.row].time+"分"
        let notLikedLabel = cell.viewWithTag(6)as! UILabel
        if notLikedFrag == true{
            notLikedLabel.text = "お気に入りが解除されました"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let fromAnimation = [AnimationType.from(direction: .right, offset: 90.0)]
        tableView.reloadData()
        UIView.animate(views: tableView.visibleCells, animations: fromAnimation)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 4
    }
    //一度LikedInfoに送信されたデータを削除する
    func delete(){
        //インスタンスを作成
        let DBRef = Database.database().reference()
        //ユーザーが入力したパスワードをデータベースの親要素の名前にする
        var userPassWord:String = userDefaults.object(forKey: "userPassWord") as! String
        //データを削除
        DBRef.child(userPassWord).removeValue()
    }
    //firebaseからデータを取ってくる
    func fetchContentsData (){
        //ユーザーが入力したパスワードをデータベースの親要素の名前にする
        var userPassWord:String = userDefaults.object(forKey: "userPassWord") as! String
        let ref = Database.database().reference().child(userPassWord).observe(.value) { (snapShot) in
            //                self.ShopInfoArray.removeAll()
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot{
                    if let postData = snap.value as? [String:Any]{
                        
                        let shopName = postData["likedShopName"] as? String
                        let address = postData["likedAddress"] as? String
                        let telNumber = postData["likedTelNumber"] as? String
                        let station = postData["likedStation"] as? String
                        let time =  postData["likedTime"] as? String
                        self.likedInfoArray.append(Info(shopName: shopName!, address: address!, telNumber: telNumber!, station: station!, time: time!))
                        
                    }
                }
                self.tableView.reloadData()
                let indexPath = IndexPath(row:self.likedInfoArray.count - 1,section:0)
                if self.likedInfoArray.count >= 5 {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    //お気に入りのデータを全て削除
    @IBAction func likedDelete(_ sender: Any) {
        
        notLikedFrag = true
        delete()
    }
    
}
