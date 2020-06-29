//
//  RandomShopViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/08.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import RetroTransition
class RandomShopViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var music = Music()
    @IBOutlet var circleImageView: UIImageView!
    
    var shoppingList = ShoppingList()
    //randomPickerViewの選択肢
    var dataSourceShopping = ["今日の気分を選択して下さい","今日は一気に買いのものするぞー！","ちょっと喉乾いたなー","最近からだの調子が悪いなー","外に買い足しに行く","お任せします"]
    
    @IBOutlet var randomPickerView: UIPickerView!
    @IBOutlet var test: UIButton!
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
            return String(dataSourceShopping[row])
        } else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return dataSourceShopping.count
        } else {
            return 0
        }
    }
    //値をパス
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //ショッピングセンター検索
        if (segue.identifier == "ShoppingViewController"){
            let shopVC = segue.destination as! ShoppingViewController
            //1の時
            if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[1]{
                let randomInt1 = Int.random(in: 10..<15)   // 10から14の範囲で整数（Int型）乱数を生成
                shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt1]
            }
            //2の時
            if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[2]{
                let randomInt2 = Int.random(in: 15..<17)   // 15から16の範囲で整数（Int型）乱数を生成
                shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt2]
            }
            //3の時
            if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[3]{
                let randomInt3 = Int.random(in: 1..<6)   // 1から6の範囲で整数（Int型）乱数を生成
                shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt3]
            }
            //4の時
            if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[4]{
                let randomInt4 = Int.random(in: 55..<70)   // 55から70の範囲で整数（Int型）乱数を生成
                shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt4]
            }
            //5の時
            if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[5]{
                let randomInt5 = Int.random(in: 0..<70)   // 0から70の範囲で整数（Int型）乱数を生成
                shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt5]
            }
        }
        
    }
    //ShoppingViewControllerへ画面遷移
    @IBAction func toShoppingViewController(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        let shopSVC = self.storyboard?.instantiateViewController(identifier: "Shop") as! ShoppingViewController
        navigationController?.pushViewController(shopSVC,withRetroTransition: TiledFlipRetroTransition())
        //画面遷移しながら値を渡す
        // SecondViewController型のViewControllerを格納
        let shopVC: ShoppingViewController = shopSVC as! ShoppingViewController
        //1の時
        if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[1]{
            let randomInt1 = Int.random(in: 10..<15)   // 10から14の範囲で整数（Int型）乱数を生成
            shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt1]
        }
        //2の時
        if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[2]{
            let randomInt2 = Int.random(in: 15..<17)   // 15から16の範囲で整数（Int型）乱数を生成
            shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt2]
        }
        //3の時
        if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[3]{
            let randomInt3 = Int.random(in: 1..<6)   // 1から6の範囲で整数（Int型）乱数を生成
            shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt3]
        }
        //4の時
        if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[4]{
            let randomInt4 = Int.random(in: 55..<70)   // 55から70の範囲で整数（Int型）乱数を生成
            shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt4]
        }
        //5の時
        if dataSourceShopping[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceShopping[5]{
            let randomInt5 = Int.random(in: 0..<70)   // 0から70の範囲で整数（Int型）乱数を生成
            shopVC.randomShoppingGc = shoppingList.shoppingArray[randomInt5]
        }
    }
    
}
