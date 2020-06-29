//
//  InputShoppingViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/11.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import Alamofire
import RetroTransition
class InputShoppingViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    var music = Music()
    //駐車場の有無を判定するためのフラグ
    var parkingFlag = false
    
    //PickerView
    @IBOutlet var showTypePickerView: UIPickerView!
    @IBOutlet var shoppingDetailPickerView: UIPickerView!
    //UIButton
    @IBOutlet var diagnoseButton: UIButton!
    
    //TextField
    @IBOutlet var maxMoneyTextField: UITextField!
    //showTypeの選択肢
    var dataSourceForShowType = ["表示方法を選択","近い順","金額が安い順","金額が高い順","星の数順"]
    //ShoppingDetailの選択肢
    var dataSourceForShoppingDetail = ["お店の種類を選択して下さい","めがね；メガネ、コンタクト","ドラッグ；ドラッグストア","ドラッグ；漢方","ドラッグ；家庭用医療機器","ドラッグ；医療用品","ドラッグ；市販薬（その他）","家電；電化製品","家電；家電量販店","家電；携帯電話","家電；パソコン","百貨店；デパート、百貨店","百貨店；ショッピングセンター","百貨店；アウトレットショップ","百貨店；ホームセンター","百貨店；商店街","コンビニ；コンビニ","コンビニ；スーパー","リサイクル；リサイクルショップ","リサイクル；ディスカウントショップ","リサイクル；金券ショップ","生活用品；ふとん、寝具","生活用品；日用雑貨","生活用品；文房具、事務用品","生活用品；家具","生活用品；インテリア用品","生活用品；印鑑、印章","生活用品；フラワーショップ","生活用品；100円ショップ","生活用品；作業服","生活用品；インテリア（その他）","趣味；CD、DVD、ビデオ","趣味；書店","趣味；おもちゃ","趣味；たばこ","趣味；スポーツ用品","趣味；ゴルフ用品","趣味；武道具","趣味；趣味、スポーツ、工芸","ファッション；衣料品店","ファッション；婦人服、ブティック","ファッション；呉服、和装小物","ファッション；紳士服","ファッション；子ども服、ベビー服","ファッション；マタニティー","ファッション；学生服、制服","ファッション；ジーンズショップ","ファッション；フォーマルウエア","ファッション；下着、ランジェリー","ファッション；毛皮","ファッション；靴、履物","ファッション；かばん、ハンドバッグ","ファッション；古着、リサイクル","ファッション；宝石、貴金属、真珠","ファッション；アクセサリー","ファッション；時計","ファッション；アクセサリー、時計（その他）","食品、食料；酒店","食品、食料；米、米店","食品、食料；鮮魚店","食品、食料；果物、フルーツショップ","食品、食料；卵、食肉","食品、食料；健康食品","食品、食料；海産物","食品、食料；総菜","食品、食料；自然食品","食品、食料；コーヒー豆","食品、食料；中華食材","食品、食料；牛乳","食品、食料；食品、食材（その他）","通信販売；通信販売"]
    
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
        shoppingDetailPickerView.delegate = self
        shoppingDetailPickerView.dataSource = self
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
            return String(dataSourceForShoppingDetail[row])
        } else if pickerView.tag == 2{
            return String(dataSourceForShowType[row])
        } else {
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return dataSourceForShoppingDetail.count
        } else if pickerView.tag == 2{
            return dataSourceForShowType.count
        } else {
            return 0
        }
    }
    
    //ShoppingViewControllerへ画面遷移
    @IBAction func shoppingSeach(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        let shopSVC = self.storyboard?.instantiateViewController(identifier: "Shop") as! ShoppingViewController
        navigationController?.pushViewController(shopSVC,withRetroTransition: SwingInRetroTransition())
        //画面遷移しながら値を渡す
        
        // SecondViewController型のViewControllerを格納
        let shopVC: ShoppingViewController = shopSVC as! ShoppingViewController
        //showTypeの検索
        //近い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[1]{
            shopVC.selectedShowType = "dist"
        }
        //金額が安い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[2]{
            shopVC.selectedShowType = "price"
        }
        //金額が高い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[3]{
            shopVC.selectedShowType = "-price"
        }
        //星の数が多い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[4]{
            shopVC.selectedShowType = "-rating"
        }
        //shoppingDetailの検索
        //メガネ
        for i in 1..<2 {
            if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i]{
                shopVC.selectedShoppingDetail = "020100" + String(i)
            }
        }
        //ドラッグ
        for i in 1..<6 {
            if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+1]{
                shopVC.selectedShoppingDetail = "020200" + String(i)
            }
            //家電、携帯電話
            for i in 1..<5 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+6]{
                    shopVC.selectedShoppingDetail = "020300" + String(i)
                }
            }
            //百貨店、ショッピングセンター
            for i in 1..<6 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+10]{
                    shopVC.selectedShoppingDetail = "020400" + String(i)
                }
            }
            //コンビニ、スーパー
            for i in 1..<3 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+15]{
                    shopVC.selectedShoppingDetail = "020500" + String(i)
                }
            }
            //リサイクル、ディスカウントショップ
            for i in 1..<4 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+17]{
                    shopVC.selectedShoppingDetail = "020600" + String(i)
                }
            }
            
            //生活用品、インテリア
            for i in 1..<11 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+20]{
                    if i >= 10{
                        shopVC.selectedShoppingDetail = "02070" + String(i)
                    }else{
                        shopVC.selectedShoppingDetail = "020700" + String(i)
                    }
                }
            }
            
            
            //趣味、スポーツ、工芸
            for i in 1..<9 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+30]{
                    shopVC.selectedShoppingDetail = "020800" + String(i)
                }
            }
            //ファッション、アクセサリー、時計
            for i in 1..<19 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+38]{
                    if i >= 10{
                        shopVC.selectedShoppingDetail = "02090" + String(i)
                    }else{
                        shopVC.selectedShoppingDetail = "020900" + String(i)
                    }
                }
            }
            
            //食品、食材
            for i in 1..<14 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+56]{
                    if i >= 10{
                        shopVC.selectedShoppingDetail = "02100" + String(i)
                    }else{
                        shopVC.selectedShoppingDetail = "021000" + String(i)
                    }
                }
            }
            
            //通信販売
            for i in 1..<2 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+69]{
                    shopVC.selectedShoppingDetail = "021100" + String(i)
                }
            }
            
            //距離をshopVCに反映させる
            shopVC.maxMoney = maxMoneyTextField.text!
        }
        //switchParkingの結果を渡す
        if parkingFlag == true{
            shopVC.parking = "true"
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
        let shopTVC = self.storyboard?.instantiateViewController(identifier: "shopTableView") as! ShopTableViewController
        navigationController?.pushViewController(shopTVC,withRetroTransition: SwingInRetroTransition())
        //画面遷移しながら値を渡す
        
        // SecondViewController型のViewControllerを格納
        let shopTableVC: ShopTableViewController = shopTVC as! ShopTableViewController
        //showTypeの検索
        //近い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[1]{
            shopTableVC.selectedShowType = "dist"
        }
        //金額が安い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[2]{
            shopTableVC.selectedShowType = "price"
        }
        //金額が高い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[3]{
            shopTableVC.selectedShowType = "-price"
        }
        //星の数が多い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[4]{
            shopTableVC.selectedShowType = "-rating"
        }
        
        //shoppingDetailの検索
        for i in 1..<2 {
            if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i]{
                shopTableVC.selectedShoppingDetail = "020100" + String(i)
            }
        }
        //ドラッグ
        for i in 1..<6 {
            if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+1]{
                shopTableVC.selectedShoppingDetail = "020200" + String(i)
            }
            //家電、携帯電話
            for i in 1..<5 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+6]{
                    shopTableVC.selectedShoppingDetail = "020300" + String(i)
                }
            }
            //百貨店、ショッピングセンター
            for i in 1..<6 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+10]{
                    shopTableVC.selectedShoppingDetail = "020400" + String(i)
                }
            }
            //コンビニ、スーパー
            for i in 1..<3 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+15]{
                    shopTableVC.selectedShoppingDetail = "020500" + String(i)
                }
            }
            //リサイクル、ディスカウントショップ
            for i in 1..<4 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+17]{
                    shopTableVC.selectedShoppingDetail = "020600" + String(i)
                }
            }
            
            //生活用品、インテリア
            for i in 1..<11 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+20]{
                    if i >= 10{
                        shopTableVC.selectedShoppingDetail = "02070" + String(i)
                    }else{
                        shopTableVC.selectedShoppingDetail = "020700" + String(i)
                    }
                }
            }
            
            
            //趣味、スポーツ、工芸
            for i in 1..<9 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+30]{
                    shopTableVC.selectedShoppingDetail = "020800" + String(i)
                }
            }
            //ファッション、アクセサリー、時計
            for i in 1..<19 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+38]{
                    if i >= 10{
                        shopTableVC.selectedShoppingDetail = "02090" + String(i)
                    }else{
                        shopTableVC.selectedShoppingDetail = "020900" + String(i)
                    }
                }
            }
            
            //食品、食材
            for i in 1..<14 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+56]{
                    if i >= 10{
                        shopTableVC.selectedShoppingDetail = "02100" + String(i)
                    }else{
                        shopTableVC.selectedShoppingDetail = "021000" + String(i)
                    }
                }
            }
            
            //通信販売
            for i in 1..<2 {
                if dataSourceForShoppingDetail[self.shoppingDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForShoppingDetail[i+69]{
                    if i >= 10{
                        shopTableVC.selectedShoppingDetail = "02110" + String(i)
                    }
                    shopTableVC.selectedShoppingDetail = "021100" + String(i)
                }
            }
            
            //距離をshopVCに反映させる
            shopTableVC.maxMoney = maxMoneyTextField.text!
        }
        //switchParkingの結果を渡す
        if parkingFlag == true{
            shopTableVC.parking = "true"
        }
    }
    @IBAction func toRandomShop(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        performSegue(withIdentifier: "RandomShop", sender: nil)
    }
}
