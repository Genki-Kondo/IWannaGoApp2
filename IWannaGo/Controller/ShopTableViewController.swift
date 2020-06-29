//
//  ShopTableViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/16.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Firebase
import ViewAnimator
class ShopTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    //  userDefaultsの定義
    var userDefaults = UserDefaults.standard
    
    //tableviewCellを１度リセットするための判定フラグ
    var deleteFrag = true
    //タップされたか判定するためのフラグ
    var tapFrag:Bool = false
    //情報を次々に入れていくための配列
    var ShopInfoArray = [Info]()
    
    var btnReaction: UIButton!
    
    @IBOutlet var likedButton: UIButton!
    @IBOutlet var tableView: UITableView!
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
    var randomShoppingGc: String = ""
    var selectedShoppingDetail: String = ""
    
    //一度値を格納するためだけの変数
    var shopName :String = ""
    var address :String = ""
    var telNumber :String = ""
    var stationName :String = ""
    var time :String = ""
    
    //値を渡すための変数
    var descriptionString = ""
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
        
        
        
        
        
    }//viewDidLoad
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShopInfoArray.count
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
            cell.shopNameLabel.text = ShopInfoArray[indexPath.row].shopName
            cell.addressLabel.text = ShopInfoArray[indexPath.row].address
            cell.telNumberLabel.text = ShopInfoArray[indexPath.row].telNumber
            cell.StationLabel.text = ShopInfoArray[indexPath.row].station+"駅"
            cell.timeLabel.text = ShopInfoArray[indexPath.row].time+"分"
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let zoomAnimation = [AnimationType.zoom(scale : 50)]
        tableView.reloadData()
        UIView.animate(views :tableView.visibleCells, animations: zoomAnimation)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //tableViewのcellがハイライトしたらfirebaseにデータをお気に入りとして送信する
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if tapFrag == true{
            //ユーザーが入力したパスワードをデータベースの親要素の名前にする
            var userPassWord:String = userDefaults.object(forKey: "userPassWord") as! String
            //firebaseにデータをお気に入りとして送信する
            let likedInfoDB = Database.database().reference().child(userPassWord).childByAutoId()
            
            
            
            var likedShopName = ShopInfoArray[indexPath.row].shopName
            var likedAddress = ShopInfoArray[indexPath.row].address
            var likedTelNumber = ShopInfoArray[indexPath.row].telNumber
            var likedStation = ShopInfoArray[indexPath.row].station
            var likedTime = ShopInfoArray[indexPath.row].time
            let likedInfo = ["likedShopName":likedShopName,"likedAddress":likedAddress ,"likedTelNumber":likedTelNumber,"likedStation":likedStation,"likedTime":likedTime]
            
            //likedInfoDBに入れて送信する
            likedInfoDB.updateChildValues(likedInfo)
            let cell = tableView.cellForRow(at:indexPath)
            // チェックマークを入れる
            cell?.accessoryType = .checkmark
            //お気に入りアラートを表示する
            LikedAlert()
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
    //一度ShopInfoに送信されたデータを削除する
    func delete(){
        //インスタンスを作成
        let DBRef = Database.database().reference()
        //データを削除
        DBRef.child("ShopInfo").removeValue()
    }
    //YOLPのAPIに送信し地図を表示する
    //そしてfirebaseにデータを送信する
    func getApiAndSendToDB(){
        
        let urlString = "https://map.yahooapis.jp/search/local/V1/localSearch?"+"&lat="+latitudeNow+"&lon=" + longitudeNow+"&gc="+selectedShoppingDetail+randomShoppingGc+"&maxprice=" + maxMoney+"&sort="+selectedShowType+"&parking="+parking+"&results=30&appid=dj00aiZpPVBHOVBCb0daWTZXRSZzPWNvbnN1bWVyc2VjcmV0Jng9Y2M-&output=json"
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
                    
                    
                    //firebase
                    let infoDB = Database.database().reference().child("ShopInfo").childByAutoId()
                    
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
        let ref = Database.database().reference().child("ShopInfo").observe(.value) { (snapShot) in
            self.ShopInfoArray.removeAll()
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot{
                    if let postData = snap.value as? [String:Any]{
                        
                        let shopName = postData["shopName"] as? String
                        let address = postData["address"] as? String
                        let telNumber = postData["telNumber"] as? String
                        let station = postData["station"] as? String
                        let time = postData["time"] as? String
                        self.ShopInfoArray.append(Info(shopName: shopName!, address: address!, telNumber: telNumber!, station: station!, time: time!))
                    }
                }
                self.tableView.reloadData()
                let indexPath = IndexPath(row:self.ShopInfoArray.count - 1,section:0)
                if self.ShopInfoArray.count >= 5 {
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
