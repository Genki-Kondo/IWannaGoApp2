//
//  MenuViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/11.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import RetroTransition
import Firebase
import FirebaseAuth
class MenuViewController: UIViewController {
    
    var music = Music()
    override func viewDidLoad() {
        super.viewDidLoad()
        //AnonymousLoginをfirebaseでする
        AnonymousLogin()
        // ナビゲーションバーの透明化
        
        // 半透明の指定（デフォルト値）
        self.navigationController?.navigationBar.isTranslucent = true
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
    }
    //画面遷移
    @IBAction func toShop(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        
        let inputShopVC = self.storyboard?.instantiateViewController(identifier: "toInputShop") as! InputShoppingViewController
        navigationController?.pushViewController(inputShopVC,withRetroTransition: ShrinkingGrowingDiamondsRetroTransition())
    }
    //画面遷移
    @IBAction func toFood(_ sender: Any) {
        music.playSound(fileName: "フードタップ音", extentionName: "mp3")
        let inputFoodVC = self.storyboard?.instantiateViewController(identifier: "toInputFood") as! InputFoodViewController
        navigationController?.pushViewController(inputFoodVC,withRetroTransition: CollidingDiamondsRetroTransition())
    }
    //画面遷移
    @IBAction func toLeisure(_ sender: Any) {
        music.playSound(fileName: "フードタップ音", extentionName: "mp3")
        let inputLeisureVC = self.storyboard?.instantiateViewController(identifier: "toInputLeisure") as! InputLeisureViewController
        navigationController?.pushViewController(inputLeisureVC,withRetroTransition: CollidingDiamondsRetroTransition())
    }
    //画面遷移
    @IBAction func toLife(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        
        let inputLifeVC = self.storyboard?.instantiateViewController(identifier: "toInputLife") as! InputLifeViewController
        navigationController?.pushViewController(inputLifeVC,withRetroTransition: ShrinkingGrowingDiamondsRetroTransition())
    }
    //AnonymousLoginをfirebaseでする
    func AnonymousLogin(){
        Auth.auth().signInAnonymously { (authResult, error) in
            let user = authResult?.user
            print(user)
        }
    }
    
    @IBAction func toLikedTableView(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        performSegue(withIdentifier: "likedTableView", sender: nil)
    }
    
}
