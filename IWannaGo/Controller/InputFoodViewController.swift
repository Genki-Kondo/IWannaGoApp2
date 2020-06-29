//
//  InputFoodViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/11.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import Alamofire
import RetroTransition
class InputFoodViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    var music = Music()
    //駐車場の有無を判定するためのフラグ
    var parkingFlag = false
    //PickerView
    @IBOutlet var showTypePickerView: UIPickerView!
    @IBOutlet var foodDetailPickerView: UIPickerView!
    
    //UIButton
    @IBOutlet var diagnoseButton: UIButton!
    //showTypeの選択肢
    var dataSourceForShowType = ["表示方法を選択","近い順","金額が安い順","金額が高い順","星の数順"]
    //TextField
    @IBOutlet var maxMoneyTextField: UITextField!
    
    //FoodDetailの選択肢
    var dataSourceForFoodDetail = ["料理の種類を選択して下さい","和食；懐石料理","和食；会席料理","和食；割ぽう","和食；料亭","和食；小料理","和食；精進料理","和食；京料理","和食；豆腐料理","和食；ゆば料理","和食；おばんざい","和食；日本料理","和食；握り寿司","和食；回転寿司","和食；天ぷら、揚げ物","和食；とんかつ","和食；フライ","和食；そば","和食；うどん","和食；味噌煮込みうどん","和食；沖縄そば","和食；すき焼き","和食；しゃぶしゃぶ","和食；うなぎ","和食；どじょう","和食；焼き鳥","和食；串焼き","和食；鳥料理","和食：おでん","和食：お好み焼き、たこ焼き","和食：もんじゃ焼き","和食：丼もの、牛丼","和食；沖縄料理","和食；郷土料理","和食；海鮮料理","和食；ふぐ料理","和食；かに料理","和食；すっぽん料理","和食；あんこう料理","和食；川魚料理","和食；牡蠣料理","和食；豚肉料理","和食；牛肉料理","和食；馬肉料理","和食；炭火焼き","和食；鉄板焼き","和食；牛タン料理","和食；もつ料理","和食；釜飯","和食；くじら料理","和食；炉端焼き","和食；野菜料理","和食；にんにく料理","和食；和食（その他）","洋食；ステーキ、ハンバーグ","洋食；パスタ、ピザ","洋食；ハンバーガー","洋食；洋食（その他）","洋食；フランス料理（フレンチ）","洋食；イタリア料理（イタリアン）","洋食；スペイン料理","洋食；ポルトガル料理","洋食；地中海料理","洋食；ドイツ料理","洋食；ロシア料理","洋食；スイス料理","洋食；ベルギー料理","洋食；アメリカ料理","洋食；カリフォルニア料理","洋食；ケイジャン料理","洋食；オセアニア料理","洋食；パシフィックリム料理","洋食；ハワイ料理","洋食；西洋各国料理","洋食；シーフード","洋食；バーベキュー","バイキング；バイキング","中華；中華料理","中華；北京料理","中華；上海料理","中華；広東料理","中華；四川料理","中華；台湾料理","中華；香港料理","中華；餃子","中華；飲茶、点心","アジア料理；韓国料理、朝鮮料理","アジア料理；アフリカ料理","アジア料理；タイ料理","アジア料理；ベトナム料理","アジア料理；インドネシア料理","アジア料理；インド料理","アジア料理；ネパール料理","アジア料理；パキスタン料理","アジア料理；スリランカ料理","アジア料理；トルコ料理","アジア料理；アラビア料理","アジア料理；メキシコ料理","アジア料理；ブラジル料理","アジア料理；アジア料理、エスニック（その他）","ラーメン；ラーメン","ラーメン；つけ麺","カレー；カレー","カレー；スープカレー","カレー；欧風カレー","カレー；インドカレー","カレー；タイカレー","焼肉；焼肉","焼肉；ジンギスカン","焼肉；ホルモン","鍋；鍋料理","居酒屋；和風居酒屋","居酒屋；洋風居酒屋","居酒屋；アジア居酒屋","居酒屋；立ち飲み居酒屋","居酒屋；ビアホール","居酒屋；ビアレストラン","定食；定食、食堂","創作料理；創作料理","創作料理；無国籍料理","自然食；自然食","自然食；薬膳","自然食；オーガニック","持ち帰り；持ち帰り専門、弁当","持ち帰り；配達専門、宅配ピザ","持ち帰り；仕出し料理","カフェ；カフェ","カフェ；喫茶店","カフェ；カフェバー","カフェ；インターネットカフェ","カフェ；シアトルカフェ","カフェ；複合カフェ","カフェ；ドッグカフェ","カフェ；猫カフェ","カフェ；ギャラリーカフェ","カフェ；ブックカフェ","カフェ；マンガ喫茶","カフェ；軽食","カフェ；和風喫茶","カフェ；カラオケ喫茶","コーヒー；コーヒー専門店","コーヒー；紅茶専門店","コーヒー；中国茶専門店","コーヒー；日本茶専門店","パン、サンドウィッチ；ベーカリー","パン、サンドウィッチ；サンドイッチ","パン、サンドウィッチ；ベーグル","パン、サンドウィッチ；ホットドッグ","パン、サンドウィッチ；サンドイッチ（その他）","スイーツ；洋菓子、ケーキ","スイーツ；和菓子、たい焼き","スイーツ；中華菓子","スイーツ；アイス、クレープ、パフェ","バー；バー","バー；ショットバー","バー；アイリッシュパブ","バー；ダイニングバー","バー；バル、バール","バー；バービアバー","バー；ワインバー","バー；焼酎バー","バー；レストランバー","バー；ダーツバー","バー；ゴルフバー","スナック；パブ","スナック；スナック","スナック；クラブ","スナック；ラウンジ","ディスコ；ディスコ","ディスコ；クラブハウス","ビアガーデン；ビアガーデン","ファミレス；ファミレス","ファミレス；ファストフード","ファミレス；ファストカジュアル","パーティー；パーティー、宴会場","パーティー；カラオケボックス","屋形船；屋形船","屋形船；クルージング","テーマパーク；テーマパークレストラン","テーマパーク；アミューズメントレストラン","オーベルジュ；オーベルジュ","その他；その他"]
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
        
        foodDetailPickerView.delegate = self
        foodDetailPickerView.dataSource = self
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
            return String(dataSourceForFoodDetail[row])
        } else if pickerView.tag == 2{
            return String(dataSourceForShowType[row])
        } else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return dataSourceForFoodDetail.count
        } else if pickerView.tag == 2{
            return dataSourceForShowType.count
        } else{
            return 0
        }
    }
    
    //FoodViewControllerへ画面遷移
    @IBAction func foodSeach(_ sender: Any) {
        music.playSound(fileName: "フードタップ音", extentionName: "mp3")
        let foodSVC = self.storyboard?.instantiateViewController(identifier: "Food") as! FoodViewController
        navigationController?.pushViewController(foodSVC,withRetroTransition: SwingInRetroTransition())
        //画面遷移しながら値を渡す
        // SecondViewController型のViewControllerを格納
        let foodVC: FoodViewController = foodSVC as! FoodViewController
        //showTypeの検索
        //近い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[1]{
            foodVC.selectedShowType = "dist"
        }
        //金額が安い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[2]{
            foodVC.selectedShowType = "price"
        }
        //金額が高い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[3]{
            foodVC.selectedShowType = "-price"
        }
        //星の数が多い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[4]{
            foodVC.selectedShowType = "-rating"
        }
        
        //foodDetailの検索
        //和食
        for i in 1..<54 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i]{
                if i >= 10{
                    foodVC.selectedFoodDetail = "01010" + String(i)
                }else {
                    foodVC.selectedFoodDetail = "010100" + String(i)
                }
                
                
            }
        }
        //洋食
        for i in 1..<23 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+53]{
                if i >= 10{
                    foodVC.selectedFoodDetail = "01020" + String(i)
                }else{
                    foodVC.selectedFoodDetail = "010200" + String(i)
                }
            }
        }
        //バイキいぐ
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+75]{
                foodVC.selectedFoodDetail = "010300" + String(i)
            }
        }
        //中華
        for i in 1..<10 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+76]{
                foodVC.selectedFoodDetail = "010400" + String(i)
            }
        }
        //アジア料理
        for i in 1..<15 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+85]{
                if i >= 10{
                    foodVC.selectedFoodDetail = "01050" + String(i)
                }
                foodVC.selectedFoodDetail = "010500" + String(i)
            }
        }
        //ラーメン
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+99]{
                foodVC.selectedFoodDetail = "010600" + String(i)
            }
        }
        //カレー
        for i in 1..<6 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+101]{
                foodVC.selectedFoodDetail = "010700" + String(i)
            }
        }
        //焼肉
        for i in 1..<4 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+106]{
                foodVC.selectedFoodDetail = "010800" + String(i)
            }
        }
        //鍋
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+109]{
                foodVC.selectedFoodDetail = "010900" + String(i)
            }
        }
        //居酒屋
        for i in 1..<7 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+110]{
                foodVC.selectedFoodDetail = "011000" + String(i)
            }
        }
        //定食
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+116]{
                foodVC.selectedFoodDetail = "011100" + String(i)
            }
        }
        //創作料理
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+117]{
                foodVC.selectedFoodDetail = "011200" + String(i)
            }
        }
        //自然食
        for i in 1..<4 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+119]{
                foodVC.selectedFoodDetail = "011300" + String(i)
            }
        }
        //持ち帰り
        for i in 1..<4 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+122]{
                foodVC.selectedFoodDetail = "011400" + String(i)
            }
        }
        //カフェ
        for i in 1..<15 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+125]{
                if i >= 10{
                    foodVC.selectedFoodDetail = "01150" + String(i)
                }else{
                    foodVC.selectedFoodDetail = "011500" + String(i)
                }
                
            }
        }
        //コーヒー
        for i in 1..<5 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+139]{
                foodVC.selectedFoodDetail = "011600" + String(i - 1)
            }
        }
        //パン、サンドウィッチ
        for i in 1..<6 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+143]{
                foodVC.selectedFoodDetail = "011700" + String(i)
            }
        }
        //スイーツ
        for i in 1..<5 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+148]{
                foodVC.selectedFoodDetail = "011800" + String(i)
            }
        }
        //バー
        for i in 1..<12 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+152]{
                if i >= 10{
                    foodVC.selectedFoodDetail = "01190" + String(i)
                }else{
                    foodVC.selectedFoodDetail = "012000" + String(i)
                }
            }
        }
        //スナック
        for i in 1..<5 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+163]{
                foodVC.selectedFoodDetail = "012000" + String(i)
            }
        }
        //ディスコ
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+167]{
                foodVC.selectedFoodDetail = "012100" + String(i)
            }
        }
        //ビアガーデン
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+169]{
                foodVC.selectedFoodDetail = "012200" + String(i)
            }
        }
        //ファミレス
        for i in 1..<4 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+170]{
                foodVC.selectedFoodDetail = "012300" + String(i)
            }
        }
        //パーティ
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+173]{
                foodVC.selectedFoodDetail = "012400" + String(i)
            }
        }
        //屋形船
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+175]{
                foodVC.selectedFoodDetail = "012500" + String(i)
            }
        }
        //テーマパーク
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+177]{
                foodVC.selectedFoodDetail = "012600" + String(i)
            }
        }
        //オーベルジュ
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+179]{
                foodVC.selectedFoodDetail = "012700" + String(i)
            }
        }
        //その他
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+180]{
                foodVC.selectedFoodDetail = "012800" + String(i)
            }
        }
        //switchParkingの結果を渡す
        if parkingFlag == true{
            foodVC.parking = "true"
        }
        //最大支払い額をfoodVCに反映させる
        foodVC.maxMoney = maxMoneyTextField.text!
        
        
    }
    
    @IBAction func switchParking(_ sender: UISwitch) {
        if sender.isOn == true {
            parkingFlag = true
            print(sender.isOn)
        } else {
            parkingFlag = false
        }
    }
    @IBAction func showTableView(_ sender: Any) {
        music.playSound(fileName: "フードタップ音", extentionName: "mp3")
        let foodTVC = self.storyboard?.instantiateViewController(identifier: "foodTableView") as! FoodTableViewController
        navigationController?.pushViewController(foodTVC,withRetroTransition: SwingInRetroTransition())
        //画面遷移しながら値を渡す
        // SecondViewController型のViewControllerを格納
        let foodTableVC: FoodTableViewController = foodTVC as! FoodTableViewController
        //showTypeの検索
        //近い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[1]{
            foodTableVC.selectedShowType = "dist"
        }
        //金額が安い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[2]{
            foodTableVC.selectedShowType = "price"
        }
        //金額が高い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[3]{
            foodTableVC.selectedShowType = "-price"
        }
        //星の数が多い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[4]{
            foodTableVC.selectedShowType = "-rating"
        }
        //
        
        //foodDetailの検索
        //和食
        for i in 1..<54 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i]{
                if i >= 10{
                    foodTableVC.selectedFoodDetail = "01010" + String(i)
                }else{
                    foodTableVC.selectedFoodDetail = "010100" + String(i)
                }
                
            }
        }
        //洋食
        for i in 1..<23 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+53]{
                if i >= 10{
                    foodTableVC.selectedFoodDetail = "01020" + String(i)
                }else{
                    foodTableVC.selectedFoodDetail = "010200" + String(i)
                }
            }
        }
        //バイキいぐ
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+75]{
                foodTableVC.selectedFoodDetail = "010300" + String(i)
            }
        }
        //中華
        for i in 1..<10 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+76]{
                foodTableVC.selectedFoodDetail = "010400" + String(i)
            }
        }
        //アジア料理
        for i in 1..<15 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+85]{
                if i >= 10{
                    foodTableVC.selectedFoodDetail = "01050" + String(i)
                }else{
                    foodTableVC.selectedFoodDetail = "010500" + String(i)
                }
            }
        }
        //ラーメン
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+99]{
                foodTableVC.selectedFoodDetail = "010600" + String(i)
            }
        }
        //カレー
        for i in 1..<6 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+101]{
                foodTableVC.selectedFoodDetail = "010700" + String(i)
            }
        }
        //焼肉
        for i in 1..<4 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+106]{
                foodTableVC.selectedFoodDetail = "010800" + String(i)
            }
        }
        //鍋
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+109]{
                foodTableVC.selectedFoodDetail = "010900" + String(i)
            }
        }
        //居酒屋
        for i in 1..<7 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+110]{
                foodTableVC.selectedFoodDetail = "011000" + String(i)
            }
        }
        //定食
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+116]{
                foodTableVC.selectedFoodDetail = "011100" + String(i)
            }
        }
        //創作料理
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+117]{
                foodTableVC.selectedFoodDetail = "011200" + String(i)
            }
        }
        //自然食
        for i in 1..<4 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+119]{
                foodTableVC.selectedFoodDetail = "011300" + String(i)
            }
        }
        //持ち帰り
        for i in 1..<4 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+122]{
                foodTableVC.selectedFoodDetail = "011400" + String(i)
            }
        }
        //カフェ
        for i in 1..<15 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+125]{
                if i >= 10{
                    foodTableVC.selectedFoodDetail = "0" + String(i)
                }else{
                    foodTableVC.selectedFoodDetail = "011500" + String(i)
                }
            }
        }
        //コーヒー
        for i in 1..<5 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+139]{
                foodTableVC.selectedFoodDetail = "011600" + String(i - 1)
            }
        }
        //パン、サンドウィッチ
        for i in 1..<6 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+143]{
                foodTableVC.selectedFoodDetail = "011700" + String(i)
            }
        }
        //スイーツ
        for i in 1..<5 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+148]{
                foodTableVC.selectedFoodDetail = "011800" + String(i)
            }
        }
        //バー
        for i in 1..<12 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+152]{
                if i >= 10{
                    foodTableVC.selectedFoodDetail = "01190" + String(i)
                }else{
                    foodTableVC.selectedFoodDetail = "012000" + String(i)
                }
            }
        }
        //スナック
        for i in 1..<5 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+163]{
                foodTableVC.selectedFoodDetail = "012000" + String(i)
            }
        }
        //ディスコ
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+167]{
                foodTableVC.selectedFoodDetail = "012100" + String(i)
            }
        }
        //ビアガーデン
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+169]{
                foodTableVC.selectedFoodDetail = "012200" + String(i)
            }
        }
        //ファミレス
        for i in 1..<4 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+170]{
                foodTableVC.selectedFoodDetail = "012300" + String(i)
            }
        }
        //パーティ
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+173]{
                foodTableVC.selectedFoodDetail = "012400" + String(i)
            }
        }
        //屋形船
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+175]{
                foodTableVC.selectedFoodDetail = "012500" + String(i)
            }
        }
        //テーマパーク
        for i in 1..<3 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+177]{
                foodTableVC.selectedFoodDetail = "012600" + String(i)
            }
        }
        //オーベルジュ
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+179]{
                foodTableVC.selectedFoodDetail = "012700" + String(i)
            }
        }
        //その他
        for i in 1..<2 {
            if dataSourceForFoodDetail[self.foodDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForFoodDetail[i+180]{
                foodTableVC.selectedFoodDetail = "012800" + String(i)
            }
        }
        //switchParkingの結果を渡す
        if parkingFlag == true{
            foodTableVC.parking = "true"
        }
        //最大支払い額をfoodVCに反映させる
        foodTableVC.maxMoney = maxMoneyTextField.text!
    }
    @IBAction func toRandomView(_ sender: Any) {
        music.playSound(fileName: "フードタップ音", extentionName: "mp3")
        performSegue(withIdentifier: "RandomFood", sender: nil)
    }
}
