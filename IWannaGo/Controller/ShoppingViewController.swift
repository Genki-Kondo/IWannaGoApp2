//
//  ShoppingViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/07.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
import SwiftyJSON
import GooglePlaces
import RetroTransition
class ShoppingViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    
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
    //ロケーションマネージャーの初期化
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーの透明化
        
        // 半透明の指定（デフォルト値）
        self.navigationController?.navigationBar.isTranslucent = true
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        }else if status == .authorizedWhenInUse {
            // ロケーションマネージャのセットアップ
            setupLocationManager()
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
    // アラートを表示する
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
    //APIからJSON形式でデータを持ってきて地図に表示する
    func showMap(){
        //地図を表示する
        let camera = GMSCameraPosition.camera(withLatitude: Double(latitudeNow) as! CLLocationDegrees, longitude: Double(longitudeNow) as! CLLocationDegrees, zoom: 12.0)
        var mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        //現在位置
        let nowMarker = GMSMarker()
        nowMarker.position = CLLocationCoordinate2D(latitude: Double(latitudeNow)!, longitude: Double(longitudeNow)!)
        
        //変更を可能にする
        nowMarker.tracksViewChanges = true
        nowMarker.title = "現在位置"
        nowMarker.snippet = "今自分が立っている場所"
        //現在位置のアイコンを変更
        nowMarker.icon = self.imageWithImage(image: UIImage(named: "foot")!, scaledToSize: CGSize(width: 50.0, height: 50.0))
        
        nowMarker.map = mapView
        //YOLPのAPIを送信し地図を表示する
        let urlString = "https://map.yahooapis.jp/search/local/V1/localSearch?"+"&lat="+latitudeNow+"&lon=" + longitudeNow+"&gc="+selectedShoppingDetail+randomShoppingGc+"&maxprice=" + maxMoney+"&sort="+selectedShowType+"&parking="+parking+"&results=30&appid=dj00aiZpPVBHOVBCb0daWTZXRSZzPWNvbnN1bWVyc2VjcmV0Jng9Y2M-&output=json"
        AF.request(urlString).responseJSON { response in
            debugPrint(response)
            if let jsonObject = response.value{
                let json = JSON(jsonObject)
                let features = json["Feature"]
                //Featureに入ってる分繰り返す
                for (_,subJson):(String, JSON) in features{
                    //jsonで取得してきた情報をそれぞれ変数に格納する
                    let name = subJson["Name"].stringValue
                    let address = subJson["Property"]["Address"].stringValue
                    let coordinates = subJson["Geometry"]["Coordinates"].stringValue
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
                    //吹き出し
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latDouble!, longitude: lonDouble!)
                    marker.title = name
                    marker.snippet = address
                    marker.map = mapView
                    
                    
                }
            }
        }
    }
    //ピンの縮尺を変更する
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
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
        showMap()
        
        
        
    }
    
}


