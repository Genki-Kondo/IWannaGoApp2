//
//  RandomFoodViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/14.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import RetroTransition
class RandomFoodViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var music = Music()
    @IBOutlet var randomPickerView: UIPickerView!
    var foodList = FoodList()
    var dataSourceFood = ["今日の気分を選択して下さい","ガッツリ食べたいなー","ちょっと時間を潰したいな","とりあえず居酒屋","お任せで"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // ナビゲーションバーの透明化
        
        // 半透明の指定（デフォルト値）
        self.navigationController?.navigationBar.isTranslucent = true
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()
        //delegateの宣言
        randomPickerView.delegate = self
        randomPickerView.dataSource = self
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return String(dataSourceFood[row])
        } else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return dataSourceFood.count
        } else {
            return 0
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FoodViewController"){
            let foodVC = segue.destination as! FoodViewController
            //1の時
            if dataSourceFood[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceFood[1]{
                let randomInt1 = Int.random(in: 0..<109)   // 0から108の範囲で整数（Int型）乱数を生成
                foodVC.randomFoodGc = foodList.foodArray[randomInt1]
            }
            //2の時
            if dataSourceFood[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceFood[2]{
                let randomInt2 = Int.random(in: 135..<162)   // 135から161の範囲で整数（Int型）乱数を生成
                foodVC.randomFoodGc = foodList.foodArray[randomInt2]
            }
            //3の時
            if dataSourceFood[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceFood[3]{
                let randomInt3 = Int.random(in: 120..<126)   // 120から125の範囲で整数（Int型）乱数を生成
                foodVC.randomFoodGc = foodList.foodArray[randomInt3]
            }
            //4の時
            if dataSourceFood[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceFood[4]{
                let randomInt4 = Int.random(in: 0..<180)   // 0から181の範囲で整数（Int型）乱数を生成
                foodVC.randomFoodGc = foodList.foodArray[randomInt4]
            }
            
        }
    }
    @IBAction func toFoodViewController(_ sender: Any) {
        music.playSound(fileName: "フードタップ音", extentionName: "mp3")
        let foodSVC = self.storyboard?.instantiateViewController(identifier: "Food") as! FoodViewController
        navigationController?.pushViewController(foodSVC,withRetroTransition: MultiCircleRetroTransition())
        //画面遷移しながら値を渡す
        // SecondViewController型のViewControllerを格納
        let foodVC: FoodViewController = foodSVC as! FoodViewController
        //1の時
        if dataSourceFood[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceFood[1]{
            let randomInt1 = Int.random(in: 0..<109)   // 0から108の範囲で整数（Int型）乱数を生成
            foodVC.randomFoodGc = foodList.foodArray[randomInt1]
        }
        //2の時
        if dataSourceFood[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceFood[2]{
            let randomInt2 = Int.random(in: 135..<162)   // 135から161の範囲で整数（Int型）乱数を生成
            foodVC.randomFoodGc = foodList.foodArray[randomInt2]
        }
        //3の時
        if dataSourceFood[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceFood[3]{
            let randomInt3 = Int.random(in: 120..<126)   // 120から125の範囲で整数（Int型）乱数を生成
            foodVC.randomFoodGc = foodList.foodArray[randomInt3]
        }
        //4の時
        if dataSourceFood[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceFood[4]{
            let randomInt4 = Int.random(in: 0..<180)   // 0から181の範囲で整数（Int型）乱数を生成
            foodVC.randomFoodGc = foodList.foodArray[randomInt4]
        }
        
    }
}
