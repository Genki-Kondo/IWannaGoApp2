//
//  InputLeisureViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/11.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import Alamofire
import RetroTransition
class InputLeisureViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    var music = Music()
    //駐車場の有無を判定するためのフラグ
    var parkingFlag = false
    //UIButton
    @IBOutlet var diagnoseButton: UIButton!
    //PickerView
    @IBOutlet var showTypePickerView: UIPickerView!
    @IBOutlet var LeisureDetailPickerView: UIPickerView!
    
    //TextField
    @IBOutlet var maxMoneyTextField: UITextField!
    //showTypeの選択肢
    var dataSourceForShowType = ["表示方法を選択","近い順","金額が安い順","金額が高い順","星の数順"]
    var dataSourceForLeisureDetail = ["お店の種類を選択して下さい","スポーツ；スポーツ施設","スポーツ；野球場","スポーツ；サッカー場","スポーツ；ゴルフ場","スポーツ；ゴルフ練習場","スポーツ；テニスコート","スポーツ；ボウリング場","スポーツ；ダイビングショップ","スポーツ；サーフショップ","スポーツ；モータースポーツ","スポーツ；スキー、スノーボード","スポーツ；レンタルスキー、スノーボード","スポーツ；スポーツ（その他）","ゲームセンター；麻雀","ゲームセンター；ゲームセンター","レジャー；テーマパーク","レジャー；動物園","レジャー；水族館","レジャー；植物園","レジャー；海水浴場","レジャー；キャンプ場","レジャー；アウトドア","レジャー；ボート、ヨット","レジャー；釣り堀、釣り船","レジャー；プール","レジャー観；光農園","レジャー；ビリヤード","レジャー；趣味（その他）","ホテル；ホテル","ホテル；旅館","ホテル；民宿","ホテル；ビジネスホテル","ホテル；ペンション","ホテル；保養所","ホテル；公共の宿","ホテル；貸別荘","ホテル；ラブホテル","ホテル；宿泊施設（その他）","エンタ；メ映画館","エンタメ；美術館","エンタメ；博物館、科学館","エンタメ；コンサートホール","エンタメ；ライブハウス","エンタメ；画廊","エンタメ；公園","交通；タクシー","交通；レンタカー","交通；運転代行サービス","交通；バス","交通；駐車場","交通；鉄道、駅","交通；海運、遊覧船","交通；航空会社","交通；交通、レンタカー（その他）","交通；駐輪場","旅行；代理店","旅行；観光案内","旅行；道の駅","旅行；パーキングエリア","旅行；ドライブイン","旅行；旅行サービス（その他）","パチンコ；パチンコ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //diagnoseButtonを丸くする
        diagnoseButton.layer.cornerRadius = 30
        //キーボードをタイプを変える
        maxMoneyTextField.keyboardType = .numberPad
        // ナビゲーションバーの透明化
        
        // 半透明の指定（デフォルト値）
        self.navigationController?.navigationBar.isTranslucent = true
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()
        //delegateの宣言
        LeisureDetailPickerView.delegate = self
        LeisureDetailPickerView.dataSource = self
        showTypePickerView.delegate = self
        showTypePickerView.dataSource = self
        maxMoneyTextField.delegate = self
        
        
    }
    //タッチで閉じるため
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        maxMoneyTextField.resignFirstResponder()
    }
    //returnで閉じるため
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        maxMoneyTextField.resignFirstResponder()
        return true
    }
    
    //ひとつのPickerViewに対して、横にいくつドラムロールを並べるかを指定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return String(dataSourceForLeisureDetail[row])
        } else if pickerView.tag == 2{
            return String(dataSourceForShowType[row])
        } else {
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return dataSourceForLeisureDetail.count
        } else if pickerView.tag == 2{
            return dataSourceForShowType.count
        } else {
            return 0
        }
    }
    
    //LeisureViewControllerへ画面遷移
    @IBAction func leisureSeach(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        let leisureSVC = self.storyboard?.instantiateViewController(identifier: "Leisure") as! LeisureViewController
        navigationController?.pushViewController(leisureSVC,withRetroTransition: SwingInRetroTransition())
        //画面遷移しながら値を渡す
        
        // SecondViewController型のViewControllerを格納
        let leisureVC: LeisureViewController = leisureSVC as! LeisureViewController
        //showTypeの検索
        //近い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[1]{
            leisureVC.selectedShowType = "dist"
        }
        //金額が安い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[2]{
            leisureVC.selectedShowType = "price"
        }
        //金額が高い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[3]{
            leisureVC.selectedShowType = "-price"
        }
        //星の数が多い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[4]{
            leisureVC.selectedShowType = "-rating"
        }
        //leisureDetailの検索
        //スポーツ
        for i in 1..<14 {
            if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i]{
                if i >= 10{
                    leisureVC.selectedLeisureDetail = "03010" + String(i)
                }else{
                    leisureVC.selectedLeisureDetail = "030100" + String(i)
                }
            }
        }
        //麻雀、ゲームセンター
        for i in 2..<4 {
            if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+12]{
                leisureVC.selectedLeisureDetail = "030200" + String(i)
            }
            //レジャー、趣味
            for i in 1..<14 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+15]{
                    if i >= 10{
                        leisureVC.selectedLeisureDetail = "03030" + String(i)
                    }else{
                        leisureVC.selectedLeisureDetail = "030300" + String(i)
                    }
                }
            }
            //ホテル、旅館
            for i in 1..<11 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+28]{
                    if i >= 10{
                        leisureVC.selectedLeisureDetail = "03040" + String(i)
                    }else{
                        leisureVC.selectedLeisureDetail = "030400" + String(i)
                    }
                }
            }
            //エンタメ、映画館、美術館
            for i in 1..<8 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+38]{
                    leisureVC.selectedLeisureDetail = "030500" + String(i)
                }
            }
            //交通、レンタカー
            for i in 1..<11 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+45]{
                    if i >= 10{
                        leisureVC.selectedLeisureDetail = "03060" + String(i)
                    }else{
                        leisureVC.selectedLeisureDetail = "030600" + String(i)
                    }
                }
            }
            
            //旅行サービス
            for i in 1..<7 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+55]{
                    if i >= 10{
                        leisureVC.selectedLeisureDetail = "03070" + String(i)
                    }else{
                        leisureVC.selectedLeisureDetail = "030700" + String(i)
                    }
                }
            }
            
            
            //パチンコ、パチスロ
            for i in 1..<2 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+61]{
                    leisureVC.selectedLeisureDetail = "030800" + String(i)
                }
            }
            
            
            //距離をshopVCに反映させる
            leisureVC.maxMoney = maxMoneyTextField.text!
        }
        //switchParkingの結果を渡す
        if parkingFlag == true{
            leisureVC.parking = "true"
        }
    }
    //Switchbutton
    @IBAction func switchParking(_ sender: UISwitch) {
        if sender.isOn == true {
            parkingFlag = true
            print(sender.isOn)
        } else {
            parkingFlag = false
        }
    }
    //ShopTableViewControllerに画面遷移
    @IBAction func showTableView(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        let leisureTVC = self.storyboard?.instantiateViewController(identifier: "leisureTableView") as! LeisureTableViewController
        navigationController?.pushViewController(leisureTVC,withRetroTransition: SwingInRetroTransition())
        //画面遷移しながら値を渡す
        
        // SecondViewController型のViewControllerを格納
        let leisureTableVC: LeisureTableViewController = leisureTVC as! LeisureTableViewController
        //showTypeの検索
        //近い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[1]{
            leisureTableVC.selectedShowType = "dist"
        }
        //金額が安い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[2]{
            leisureTableVC.selectedShowType = "price"
        }
        //金額が高い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[3]{
            leisureTableVC.selectedShowType = "-price"
        }
        //星の数が多い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[4]{
            leisureTableVC.selectedShowType = "-rating"
        }
        
        //leisureDetailの検索
        //スポーツ
        for i in 1..<14 {
            if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i]{
                if i >= 10{
                    leisureTableVC.selectedLeisureDetail = "03010" + String(i)
                }else{
                    leisureTableVC.selectedLeisureDetail = "030100" + String(i)
                }
            }
        }
        //麻雀、ゲームセンター
        for i in 2..<4 {
            if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+12]{
                leisureTableVC.selectedLeisureDetail = "030200" + String(i)
            }
            //レジャー、趣味
            for i in 1..<14 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+15]{
                    if i >= 10{
                        leisureTableVC.selectedLeisureDetail = "03030" + String(i)
                    }else{
                        leisureTableVC.selectedLeisureDetail = "030300" + String(i)
                    }
                }
            }
            //ホテル、旅館
            for i in 1..<11 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+28]{
                    if i >= 10{
                        leisureTableVC.selectedLeisureDetail = "03040" + String(i)
                    }else{
                        leisureTableVC.selectedLeisureDetail = "030400" + String(i)
                    }
                }
            }
            //エンタメ、映画館、美術館
            for i in 1..<8 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+38]{
                    leisureTableVC.selectedLeisureDetail = "030500" + String(i)
                }
            }
            //交通、レンタカー
            for i in 1..<11 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+45]{
                    if i >= 10{
                        leisureTableVC.selectedLeisureDetail = "03060" + String(i)
                    }else{
                        leisureTableVC.selectedLeisureDetail = "030600" + String(i)
                    }
                }
            }
            
            //旅行サービス
            for i in 1..<7 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+55]{
                    if i >= 10{
                        leisureTableVC.selectedLeisureDetail = "03070" + String(i)
                    }else{
                        leisureTableVC.selectedLeisureDetail = "030700" + String(i)
                    }
                }
            }
            
            
            //パチンコ、パチスロ
            for i in 1..<2 {
                if dataSourceForLeisureDetail[self.LeisureDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLeisureDetail[i+61]{
                    leisureTableVC.selectedLeisureDetail = "030800" + String(i)
                }
            }
            
            //距離をshopVCに反映させる
            leisureTableVC.maxMoney = maxMoneyTextField.text!
        }
        //switchParkingの結果を渡す
        if parkingFlag == true{
            leisureTableVC.parking = "true"
        }
    }
    @IBAction func toRandomLeisure(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        performSegue(withIdentifier: "RandomLeisure", sender: nil)
    }
}

