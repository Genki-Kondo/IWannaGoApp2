//
//  RandomLeisureViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/08.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import RetroTransition
class RandomLeisureViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var leisureList = LeisureList()
    var music = Music()
    @IBOutlet var circleImageView: UIImageView!
    
    
    //randomPickerViewの選択肢
    var dataSourceLeisure = ["今日の気分を選択して下さい","スポーツがしたい","ザ、レジャー","本日のお泊まり先","交通手段を検索","パチンコ打ちに行こうぜ","お任せします"]
    
    @IBOutlet var randomPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //delegateの宣言
        randomPickerView.delegate = self
        randomPickerView.dataSource = self
        // ナビゲーションバーの透明化
        
        // 半透明の指定（デフォルト値）
        self.navigationController?.navigationBar.isTranslucent = true
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return String(dataSourceLeisure[row])
        } else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return dataSourceLeisure.count
        } else {
            return 0
        }
    }
    //値をパス
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //ショッピングセンター検索
        if (segue.identifier == "LeisureViewController"){
            let leisureVC = segue.destination as! LeisureViewController
            //1の時
            if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[1]{
                let randomInt1 = Int.random(in: 0..<12)   // 0から13の範囲で整数（Int型）乱数を生成
                leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt1]
            }
            //2の時
            if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[2]{
                let randomInt2 = Int.random(in: 16..<31)   // 17から31の範囲で整数（Int型）乱数を生成
                leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt2]
            }
            //3の時
            if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[3]{
                let randomInt3 = Int.random(in: 31..<42)   // 32から42の範囲で整数（Int型）乱数を生成
                leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt3]
            }
            //4の時
            if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[4]{
                let randomInt4 = Int.random(in: 49..<60)   // 50から60の範囲で整数（Int型）乱数を生成
                leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt4]
            }
            //5の時
            if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[5]{
                leisureVC.randomLeisureGc = leisureList.leisureArray[61]
            }
            //6の時
            if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[6]{
                let randomInt5 = Int.random(in: 0..<61)   // 0から59の範囲で整数（Int型）乱数を生成
                leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt5]
            }
        }
        
    }
    //ShoppingViewControllerへ画面遷移
    @IBAction func toLeisureViewController(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        let leisureSVC = self.storyboard?.instantiateViewController(identifier: "Leisure") as! LeisureViewController
        navigationController?.pushViewController(leisureSVC,withRetroTransition: TiledFlipRetroTransition())
        //画面遷移しながら値を渡す
        // SecondViewController型のViewControllerを格納
        let leisureVC: LeisureViewController = leisureSVC as! LeisureViewController
        //1の時
        if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[1]{
            let randomInt1 = Int.random(in: 0..<12)   // 0から13の範囲で整数（Int型）乱数を生成
            leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt1]
        }
        //2の時
        if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[2]{
            let randomInt2 = Int.random(in: 16..<31)   // 17から31の範囲で整数（Int型）乱数を生成
            leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt2]
        }
        //3の時
        if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[3]{
            let randomInt3 = Int.random(in: 31..<42)   // 32から42の範囲で整数（Int型）乱数を生成
            leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt3]
        }
        //4の時
        if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[4]{
            let randomInt4 = Int.random(in: 49..<60)   // 50から60の範囲で整数（Int型）乱数を生成
            leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt4]
        }
        //5の時
        if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[5]{
            leisureVC.randomLeisureGc = leisureList.leisureArray[61]
        }
        //6の時
        if dataSourceLeisure[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLeisure[6]{
            let randomInt5 = Int.random(in: 0..<61)   // 0から59の範囲で整数（Int型）乱数を生成
            leisureVC.randomLeisureGc = leisureList.leisureArray[randomInt5]
        }
    }
    
}

