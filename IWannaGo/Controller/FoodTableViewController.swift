//
//  FoodTableViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/19.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Firebase
import ViewAnimator
class FoodTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    //tableviewCellを１度リセットするための判定フラグ
    var deleteFrag = true
    //二回タップされたか判定するためのフラグ
    var tapFrag:Bool = false
    //likedButtonのimageを変更するためのフラグ
    var changeFrag:Bool = false
    //情報を次々に入れていくための配列
    var FoodInfoArray = [Info]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var likedButton: UIButton!
    //表示方法
    var selectedShowType: String = ""
    //駐車場の有無
    var parking: String = ""
    // 緯度
    var latitudeNow: String = ""
    // 経度
    var longitudeNow: String = ""
    //ユーザーが出せる上限金額
    var maxMoney: String = ""
    //業種
    var selectedFoodDetail: String = ""
    
    //一度値を格納するためだけの変数
    var shopName :String = ""
    var address :String = ""
    var telNumber :String = ""
    var stationName :String = ""
    var time :String = ""
    //ロケーションマネージャーの初期化
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        //最初にデータをリセット
        delete()
        // ロケーションマネージャのセットアップ
        setupLocationManager()
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        }else if status == .authorizedWhenInUse {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "CustumTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        }
        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! CustumTableViewCell
        if deleteFrag == true{
            cell.shopNameLabel.text = ""
            cell.addressLabel.text = ""
            cell.telNumberLabel.text = ""
            cell.StationLabel.text = ""
            cell.timeLabel.text = ""
            deleteFrag = false
        }else if deleteFrag == false{
            
            //色を変える
            if indexPath.row % 2 == 0{
                cell.backgroundColor = .systemYellow
            }else if indexPath.row % 3 == 0{
                cell.backgroundColor = .systemBlue
            }else{
                cell.backgroundColor = .systemPurple
            }
            cell.shopNameLabel.text = FoodInfoArray[indexPath.row].shopName
            cell.addressLabel.text = FoodInfoArray[indexPath.row].address
            cell.telNumberLabel.text = FoodInfoArray[indexPath.row].telNumber
            cell.StationLabel.text = FoodInfoArray[indexPath.row].station+"駅"
            cell.timeLabel.text = FoodInfoArray[indexPath.row].time+"分"
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let zoomAnimation = [AnimationType.zoom(scale : 50)]
        tableView.reloadData()
        UIView.animate(views :tableView.visibleCells, animations: zoomAnimation)
        
    }
    //tableViewのcellがハイライトしたらfirebaseにデータをお気に入りとして送信する
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if tapFrag == true{
            //ユーザーが入力したパスワードをデータベースの親要素の名前にする
            var userPassWord:String = UserDefaults.standard.object(forKey: "userPassWord") as! String
            //firebaseにデータをお気に入りとして送信する
            let likedInfoDB = Database.database().reference().child(userPassWord).childByAutoId()
            let likedShopName = FoodInfoArray[indexPath.row].shopName
            let likedAddress = FoodInfoArray[indexPath.row].address
            let likedTelNumber = FoodInfoArray[indexPath.row].telNumber
            let likedStation = FoodInfoArray[indexPath.row].station
            let likedTime = FoodInfoArray[indexPath.row].time
            let likedInfo = ["likedShopName":likedShopName,"likedAddress":likedAddress ,"likedTelNumber":likedTelNumber,"likedStation":likedStation,"likedTime":likedTime]
            //likedInfoDBに入れて送信する
            likedInfoDB.updateChildValues(likedInfo)
            
            let cell = tableView.cellForRow(at:indexPath)
            // チェックマークを入れる
            cell?.accessoryType = .checkmark
            //お気に入りアラートを表示する
            LikedAlert()
            
            
            changeFrag = true
        }else if tapFrag == false {
            print("お気に入りに登録できません")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
    }
    //一度FoodInfoに送信されたデータを削除する
    func delete(){
        //インスタンスを作成
        let DBRef = Database.database().reference()
        //ユーザーが入力したパスワードをデータベースの親要素の名前にする
        var userPassWord:String = UserDefaults.standard.object(forKey: "userPassWord") as! String
        //データを削除
        DBRef.child(userPassWord).removeValue()
    }
    //YOLPのAPIに送信し地図を表示する
    //そしてfirebaseにデータを送信する
    func getApiAndSendToDB(){
        let urlString = "https://map.yahooapis.jp/search/local/V1/localSearch?"+"&lat="+latitudeNow+"&lon=" + longitudeNow+"&gc="+selectedFoodDetail+"&maxprice=" + maxMoney+"&sort="+selectedShowType+"&parking="+parking+"&results=30&appid=dj00aiZpPVBHOVBCb0daWTZXRSZzPWNvbnN1bWVyc2VjcmV0Jng9Y2M-&output=json"
        AF.request(urlString).responseJSON { response in
            debugPrint(response)
            if let jsonObject = response.value{
                let json = JSON(jsonObject)
                let features = json["Feature"]
                //Featureに入ってる分繰り返す
                for (_,subJson):(String, JSON) in features{
                    //jsonで取得してきた情報をそれぞれ変数に格納する
                    let shopName = subJson["Name"].stringValue
                    let address = subJson["Property"]["Address"].stringValue
                    let coordinates = subJson["Geometry"]["Coordinates"].stringValue
                    let telNumber = subJson["Property"]["Tel1"].stringValue
                    let station = subJson["Property"]["Station"][0]["Name"].stringValue
                    let time = subJson["Property"]["Station"][0]["Time"].stringValue
                    let coordinatesArray = coordinates.split(separator: ",")
                    //緯度、経度を作る
                    let lat = coordinatesArray[1]
                    let lon = coordinatesArray[0]
                    //文字列をDouble型に変換
                    let latDouble = Double(lat)
                    let lonDouble = Double(lon)
                    //確認するため
                    print(subJson["Name"])
                    print(subJson["Property"]["Address"])
                    print(subJson["Geometry"]["Coordinates"])
                    
                    //firebase
                    let infoDB = Database.database().reference().child("FoodInfo").childByAutoId()
                    //キーバリュー型で送信（dictionary）
                    let detailInfo = ["shopName":shopName,"address":address ,"telNumber":telNumber,"station":station,"time":time]
                    //infoDBに入れる
                    infoDB.updateChildValues(detailInfo)
                    
                }
            }
        }
        
    }
    
    // ロケーションマネージャのセットアップ
    func setupLocationManager() {
        locationManager = CLLocationManager()
        
        // 権限をリクエスト
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        
        // ステータスごとの処理
        //位置情報を更新する
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
        }
    }
    // 位置情報取得の許可アラートを表示する
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        // UIAlertController に Action を追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    //お気に入りに登録したことを伝えるアラート
    func LikedAlert(){
        let alertTitle = "お気に入りに登録しました"
        let alertMessage = "登録したデータはメニュー画面で確認できます"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        // UIAlertController に Action を追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    
    //位置情報が更新されるたびに呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        // 位置情報を格納する
        self.latitudeNow = String(latitude!)
        self.longitudeNow = String(longitude!)
        //judgeがtrueになったことを伝える
        //現在地の取得を止める（なかなか解決ができなかった）
        manager.stopUpdatingLocation()
        
        getApiAndSendToDB()
        
        fetchContentsData()
        
        
    }
    //firebaseからデータを取ってくる
    func fetchContentsData (){
        
        let ref = Database.database().reference().child("FoodInfo").observe(.value) { (snapShot) in
            self.FoodInfoArray.removeAll()
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot{
                    if let postData = snap.value as? [String:Any]{
                        
                        let shopName = postData["shopName"] as? String
                        let address = postData["address"] as? String
                        let telNumber = postData["telNumber"] as? String
                        let station = postData["station"] as? String
                        let time = postData["time"] as? String
                        self.FoodInfoArray.append(Info(shopName: shopName!, address: address!, telNumber: telNumber!, station: station!, time: time!))
                    }
                }
                self.tableView.reloadData()
                let indexPath = IndexPath(row:self.FoodInfoArray.count - 1,section:0)
                if self.FoodInfoArray.count >= 5 {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    //お気に入りに登録するボタン
    @IBAction func addLiked(_ sender: Any) {
        tapFrag = true
        
        let image = UIImage(named: "check")
        likedButton.setImage(image, for: .normal)
        
    }
}
