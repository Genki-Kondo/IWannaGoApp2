//
//  RandomLifeViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/08.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import RetroTransition
class RandomLifeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var music = Music()
    var lifeList = LifeList()
    //randomPickerViewの選択肢
    var dataSourceLife = ["今日の気分を選択して下さい","最近からだの調子が悪いなー","新たな趣味探し","何らかの勉強をする","生活サービス","車が大好き","冠婚葬祭","美意識高め","お任せします"]
    
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
            return String(dataSourceLife[row])
        } else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return dataSourceLife.count
        } else {
            return 0
        }
    }
    //値をパス
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //ショッピングセンター検索
        if (segue.identifier == "LifeViewController"){
            let lifeVC = segue.destination as! LifeViewController
            //1の時
            if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[1]{
                let randomInt1 = Int.random(in: 0..<49)   // 0から48の範囲で整数（Int型）乱数を生成
                lifeVC.randomLifeGc = lifeList.lifeArray[randomInt1]
            }
            //2の時
            if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[2]{
                let randomInt2 = Int.random(in: 61..<93)   // 61から92の範囲で整数（Int型）乱数を生成
                lifeVC.randomLifeGc = lifeList.lifeArray[randomInt2]
            }
            //3の時
            if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[3]{
                let randomInt3 = Int.random(in: 101..<112)   // 102から112の範囲で整数（Int型）乱数を生成
                lifeVC.randomLifeGc = lifeList.lifeArray[randomInt3]
            }
            //4の時
            if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[4]{
                let randomInt4 = Int.random(in: 141..<174)   // 141から173の範囲で整数（Int型）乱数を生成
                lifeVC.randomLifeGc = lifeList.lifeArray[randomInt4]
            }
            //5の時
            if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[5]{
                let randomInt5 = Int.random(in: 173..<191)   // 173から190の範囲で整数（Int型）乱数を生成
                lifeVC.randomLifeGc = lifeList.lifeArray[randomInt5]
            }
            //6の時
            if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[6]{
                let randomInt5 = Int.random(in: 190..<199)   // 190から198の範囲で整数（Int型）乱数を生成
                lifeVC.randomLifeGc = lifeList.lifeArray[randomInt5]
            }
            //7の時
            if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[7]{
                let randomInt5 = Int.random(in: 219..<234)   // 219から233の範囲で整数（Int型）乱数を生成
                lifeVC.randomLifeGc = lifeList.lifeArray[randomInt5]
            }
            //8の時
            if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[8]{
                let randomInt5 = Int.random(in: 0..<270)   // 190から198の範囲で整数（Int型）乱数を生成
                lifeVC.randomLifeGc = lifeList.lifeArray[randomInt5]
            }
        }
        
    }
    //LifeViewControllerへ画面遷移
    @IBAction func toLifeViewController(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        let lifeSVC = self.storyboard?.instantiateViewController(identifier: "Life") as! LifeViewController
        navigationController?.pushViewController(lifeSVC,withRetroTransition: TiledFlipRetroTransition())
        //画面遷移しながら値を渡す
        // SecondViewController型のViewControllerを格納
        let lifeVC: LifeViewController = lifeSVC as! LifeViewController
        //1の時
        if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[1]{
            let randomInt1 = Int.random(in: 0..<49)   // 0から48の範囲で整数（Int型）乱数を生成
            lifeVC.randomLifeGc = lifeList.lifeArray[randomInt1]
        }
        //2の時
        if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[2]{
            let randomInt2 = Int.random(in: 61..<93)   // 61から92の範囲で整数（Int型）乱数を生成
            lifeVC.randomLifeGc = lifeList.lifeArray[randomInt2]
        }
        //3の時
        if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[3]{
            let randomInt3 = Int.random(in: 101..<112)   // 102から112の範囲で整数（Int型）乱数を生成
            lifeVC.randomLifeGc = lifeList.lifeArray[randomInt3]
        }
        //4の時
        if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[4]{
            let randomInt4 = Int.random(in: 141..<174)   // 141から173の範囲で整数（Int型）乱数を生成
            lifeVC.randomLifeGc = lifeList.lifeArray[randomInt4]
        }
        //5の時
        if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[5]{
            let randomInt5 = Int.random(in: 173..<191)   // 173から190の範囲で整数（Int型）乱数を生成
            lifeVC.randomLifeGc = lifeList.lifeArray[randomInt5]
        }
        //6の時
        if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[6]{
            let randomInt5 = Int.random(in: 190..<199)   // 190から198の範囲で整数（Int型）乱数を生成
            lifeVC.randomLifeGc = lifeList.lifeArray[randomInt5]
        }
        //7の時
        if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[7]{
            let randomInt5 = Int.random(in: 219..<234)   // 219から233の範囲で整数（Int型）乱数を生成
            lifeVC.randomLifeGc = lifeList.lifeArray[randomInt5]
        }
        //8の時
        if dataSourceLife[self.randomPickerView.selectedRow(inComponent: 0)] == dataSourceLife[8]{
            let randomInt5 = Int.random(in: 0..<270)   // 190から198の範囲で整数（Int型）乱数を生成
            lifeVC.randomLifeGc = lifeList.lifeArray[randomInt5]
        }
    }
    
}

