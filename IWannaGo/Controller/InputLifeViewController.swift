//
//  InputLifeViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/11.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import Alamofire
import RetroTransition
class InputLifeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    var music = Music()
    //駐車場の有無を判定するためのフラグ
    var parkingFlag = false
    //UIButton
    @IBOutlet var diagnoseButton: UIButton!
    //PickerView
    @IBOutlet var showTypePickerView: UIPickerView!
    @IBOutlet var lifeDetailPickerView: UIPickerView!
    
    //TextField
    @IBOutlet var maxMoneyTextField: UITextField!
    //showTypeの選択肢
    var dataSourceForShowType = ["表示方法を選択","近い順","金額が安い順","金額が高い順","星の数順"]
    //ShoppingDetailの選択肢
    var dataSourceForLifeDetail = ["お店の種類を選択して下さい","病院；歯科","病院；内科","病院；小児科","病院；整形外科","病院；胃腸科","病院；外科","病院；眼科","病院；皮膚科","病院；耳鼻咽喉科","病院；産婦人科","病院；循環器科","病院；神経科","病院；リハビリテーション科","病院；歯科口腔外科","病院；泌尿器科","病院；肛門科","病院；呼吸器科","病院；心療内科","病院；アレルギー科","病院；脳神経外科","病院；美容外科","病院；リウマチ科","病院；神経内科","病院；形成外科","病院；放射線科","病院；麻酔科","病院；性病科","病院；消化器科","病院；精神科","病院；呼吸器外科","病院；心臓血管外科","病院；小児外科","病院；産科","病院；婦人科","病院；気管食道科","病院；矯正歯科","病院；小児歯科","病院；血液内科","病院；消化器外科","病院；腎臓内科","病院；肝臓科","病院；内視鏡科","病院；腹部外科","病院；胸部外科","病院；内分泌科","病院；人工透析科","病院；人間ドック施設","病院；大学病院","病院；総合病院","薬局；薬局","マッサージ；接骨、整骨、整復","マッサージ；はり、きゅう","マッサージ；整体","マッサージ；カイロプラクティック","マッサージ；視力回復センター","マッサージ；（その他）","介護、福祉；福祉施設","介護、福祉；有料老人ホーム","介護、福祉；在宅介護サービス","介護、福祉；介護施設","介護、福祉；グループホーム","介護、福祉；介護、福祉（その他）","趣味、習い事；カルチャーセンター","趣味、習い事；スポーツ教室","趣味、習い事；スポーツクラブ","趣味、習い事；ダイビングスクール","趣味、習い事；スイミングスクール","趣味、習い事；テニススクール","趣味、習い事；空手道場","趣味、習い事；陶芸教室","趣味、習い事；絵画教室","趣味、習い事；ガラス工芸教室","趣味、習い事；華道教室","趣味、習い事；茶道教室","趣味、習い事；編み物教室","趣味、習い事；ダンス","趣味、習い事；音楽教室","趣味、習い事；ピアノ教室","趣味、習い事；パソコン教室","趣味、習い事；そろばん教室","趣味、習い事；書道教室","趣味、習い事；料理教室","趣味、習い事；着付け教室","趣味、習い事：バレエ教室","趣味、習い事：写真、カメラ","趣味、習い事；釣り","趣味、習い事；楽器","趣味、習い事；占い","趣味、習い事；ダンス、舞踊","趣味、習い事；囲碁、将棋","趣味、習い事；模型","趣味、習い事；（その他）","学校；小学校","学校；中学校","学校；高等学校","学校；高等専門学校","学校；大学","学校；専修学校、専門学校","学校；特別支援学校","学校；大学院","学校；短期大学","学校；通信制大学","学校；その他","予備校；学習塾","予備校；予備校","予備校；家庭教師","予備校；英語学校","予備校；英語以外の外国語学校","予備校；日本語学校","予備校；ビジネススクール","予備校；通信教育","予備校；フリースクール","予備校；（その他）","育児；保育園","育児；幼稚園","育児；学童保育所","育児；託児所","育児；幼児教室","育児；児童福祉施設","育児；児童館","育児；ベビーシッター","育児；幼児教材","育児；ベビー用品","育児；その他","不動産；不動産取引","不動産；不動産鑑定","不動産；マンション","不動産；住宅展示場","不動産；住宅販売","不動産；アパート、マンション管理","不動産；貸家","不動産；住宅、不動産（その他）","不動産；新築マンション","不動産；新築一戸建て","住宅設備；外構、造園業","住宅設備；リフォーム工事","住宅設備；水道、配水管","住宅設備；風呂釜、浴槽","住宅設備；畳","住宅設備；建築工事","住宅設備；（その他）","郵便局；郵便、郵便局","郵便局；宅配便","生活；電話","生活；インターネット","生活；テレビ、ラジオ","生活；新聞","生活；引越し","生活；ハウスクリーニング","生活；家電修理、取り付け","生活；便利業、代行サービス","生活；ごみ処理","生活；コインランドリー","生活；家具修理、再生","生活；ピアノ運送","生活；いす張り替え","生活；ピアノ調律","生活；白アリ駆除","生活；セキュリティー、防犯","生活；DVD、ビデオ","生活；レンタルショップ","生活；ケーブルテレビ","生活；レンタルサイクル","生活；ガソリンスタンド","生活；鍵","生活；電気","生活；ガス","生活；靴修理","生活；リフォーム","生活；クリーニング","生活；質店","生活；着付け","生活；貸衣装","生活；警備","生活；その他","自動車；自動車整備","自動車；板金、塗装","自動車；レッカー","自動車；ロードサービス","自動車；電装品販売、修理","自動車；自動車解体","自動車；教習所","自動車；洗車場","自動車；車検代行","自動車；新車販売","自動車；中古車販売","自動車；中古車買い取り","自動車；カー用品","自動車；中古部品","自動車；オートバイ販売","自動車；オートバイ修理","自動車；その他","結婚；結婚式場","結婚；結婚相談所","結婚；ブライダルプロデュース","葬祭；葬祭業","葬祭；霊園","葬祭；墓石","葬祭；仏壇、仏具","葬祭；（その他）","保険、金融；保険業","保険、金融；銀行","保険、金融；信用金庫","保険、金融；貸金業","保険、金融；証券業","保険、金融；労働金庫","保険、金融；ゴルフ会員権","保険、金融；（その他）","ペット；動物病院","ペット；ペットサロン","ペット；ペットショップ","ペット；ペットホテル","ペット；ペット葬儀、ペット霊園","ペット；調教師、ペットしつけ","ペット；（その他）","銭湯；銭湯","銭湯；スーパー銭湯","銭湯；健康ランド","銭湯；温泉浴場","銭湯；岩盤浴","銭湯；サウナ","美容；美容院","美容；理容店","美容；かつら、毛髪業","美容；ヘアデザイナー","美容；エステティックサロン","美容；アロマセラピー","美容；ネイルサロン","美容；リフレクソロジー","美容；美容アドバイザー","美容；日焼けサロン","美容；まつげ、アイラッシュ","美容；リラクゼーション","美容；メイク","美容；（その他）","専門職；税理士","専門職；公認会計士","専門職；司法書士","専門職；行政書士","専門職；弁護士","専門職；社会保険労務士","専門職；弁理士","専門職；公証人","専門職；経営コンサルタント","専門職；ファイナンシャルプランナー","専門職；信用調査、探偵","専門職；翻訳、通訳","専門職；（その他）","人材派遣；人材派遣","人材派遣；人材紹介所","人材派遣；看護師、家政婦紹介所","人材派遣；（その他）","官公庁；国の機関","官公庁；都道府県機関","官公庁；市区町村機関","官公庁；（その他）","公共サービス；消防機関","公共サービス；警察機関","公共サービス；裁判所","公共サービス；保健所","公共サービス；職業安定所","公共サービス；社会保険事務所","公共サービス；公民館、集会所","公共サービス；消費生活センター","公共サービス；（その他）","寺院、神社；寺院","寺院、神社；神社","寺院、神社；教会","寺院、神社；（その他）","避難所；避難所","避難所；一時滞在施設"]
    
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
        lifeDetailPickerView.delegate = self
        lifeDetailPickerView.dataSource = self
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
            return String(dataSourceForLifeDetail[row])
        } else if pickerView.tag == 2{
            return String(dataSourceForShowType[row])
        } else {
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return dataSourceForLifeDetail.count
        } else if pickerView.tag == 2{
            return dataSourceForShowType.count
        } else {
            return 0
        }
    }
    
    //LifeViewControllerへ画面遷移
    @IBAction func lifeSeach(_ sender: Any) {        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        let lifeSVC = self.storyboard?.instantiateViewController(identifier: "Life") as! LifeViewController
        navigationController?.pushViewController(lifeSVC,withRetroTransition: SwingInRetroTransition())
        //画面遷移しながら値を渡す
        
        // SecondViewController型のViewControllerを格納
        let lifeVC: LifeViewController = lifeSVC as! LifeViewController
        //showTypeの検索
        //近い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[1]{
            lifeVC.selectedShowType = "dist"
        }
        //金額が安い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[2]{
            lifeVC.selectedShowType = "price"
        }
        //金額が高い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[3]{
            lifeVC.selectedShowType = "-price"
        }
        //星の数が多い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[4]{
            lifeVC.selectedShowType = "-rating"
        }
        //lifeDetailの検索
        //病院、診療所
        for i in 1..<50 {
            if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i]{
                if i >= 10{
                    lifeVC.selectedLifeDetail = "04010" + String(i)
                }else{
                    lifeVC.selectedLifeDetail = "040100" + String(i)
                }
                
            }
        }
        //薬局
        for i in 1..<2 {
            if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+49]{
                lifeVC.selectedLifeDetail = "040200" + String(i)
            }
            //マッサージ、整体、治療院
            for i in 1..<7 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+50]{
                    lifeVC.selectedLifeDetail = "040300" + String(i)
                }
            }
            //介護、福祉
            for i in 1..<7 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+56]{
                    lifeVC.selectedLifeDetail = "040400" + String(i)
                }
            }
            //趣味、習い事
            for i in 1..<32 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+62]{
                    if i >= 14{
                        //APIに存在しない為ひとつ繰り上げ
                        lifeVC.selectedLifeDetail = "04050" + String(i+1)
                    }else if i >= 10{
                        lifeVC.selectedLifeDetail = "04050" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "040500" + String(i)
                    }
                    
                }
            }
            //学校、大学、専門学校
            for i in 1..<12 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+92]{
                    lifeVC.selectedLifeDetail = "040600" + String(i)
                }
            }
            
            //進学塾、予備校、各種学校
            for i in 1..<11 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+103]{
                    if i >= 10{
                        lifeVC.selectedLifeDetail = "04070" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "040700" + String(i)
                    }
                }
            }
            
            
            //保育園、幼稚園、育児
            for i in 1..<12 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+113]{
                    if i >= 10{
                        lifeVC.selectedLifeDetail = "04080" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "040800" + String(i)
                    }
                    
                }
            }
            //住宅、不動産
            for i in 1..<11 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+124]{
                    if i >= 10{
                        lifeVC.selectedLifeDetail = "04090" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "040900" + String(i)
                    }
                }
            }
            
            //住宅設備
            for i in 1..<8 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+134]{
                    if i >= 10{
                        lifeVC.selectedLifeDetail = "04100" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "041000" + String(i)
                    }
                }
            }
            
            //郵便局、宅配便
            for i in 1..<3 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+141]{
                    lifeVC.selectedLifeDetail = "041100" + String(i)
                }
            }
            //生活サービス
            for i in 1..<33 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+143]{
                    if i >= 10{
                        lifeVC.selectedLifeDetail = "04120" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "041200" + String(i)
                    }
                    
                }
            }
            //自動車、バイク
            for i in 1..<18 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+175]{
                    if i >= 10{
                        lifeVC.selectedLifeDetail = "04130" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "041300" + String(i)
                    }
                    
                }
            }
            //結婚式場、結婚相談所
            for i in 1..<4 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+192]{
                    lifeVC.selectedLifeDetail = "041400" + String(i)
                }
            }
            //葬祭、仏壇
            for i in 1..<6 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+195]{
                    lifeVC.selectedLifeDetail = "041500" + String(i)
                }
            }
            //銀行、保険、金融
            for i in 1..<9 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+200]{
                    lifeVC.selectedLifeDetail = "041600" + String(i)
                }
            }
            //ペット、動物病院
            for i in 1..<8 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+208]{
                    lifeVC.selectedLifeDetail = "041700" + String(i)
                }
            }
            //銭湯、浴場
            for i in 1..<7 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+215]{
                    lifeVC.selectedLifeDetail = "041800" + String(i)
                }
            }
            //美容、サロン
            for i in 1..<15 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+221]{
                    if i >= 10{
                        lifeVC.selectedLifeDetail = "04190" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "041900" + String(i)
                    }
                }
            }
            //専門職、弁護士、司法書士
            for i in 1..<14 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+235]{
                    if i >= 10{
                        lifeVC.selectedLifeDetail = "04200" + String(i)
                    }else{
                        lifeVC.selectedLifeDetail = "042000" + String(i)
                    }
                }
            }
            //人材派遣
            for i in 1..<5 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+248]{
                    lifeVC.selectedLifeDetail = "042100" + String(i)
                }
            }
            //官公庁
            for i in 1..<5 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+252]{
                    lifeVC.selectedLifeDetail = "042200" + String(i)
                }
            }
            //公共サービス、各種団体
            for i in 1..<10 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+256]{
                    lifeVC.selectedLifeDetail = "042300" + String(i)
                }
            }
            //寺院、神社
            for i in 1..<5 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+265]{
                    lifeVC.selectedLifeDetail = "042400" + String(i)
                }
            }
            //避難所、避難場所
            for i in 1..<3 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+269]{
                    lifeVC.selectedLifeDetail = "042500" + String(i)
                }
            }
            
            //距離をshopVCに反映させる
            lifeVC.maxMoney = maxMoneyTextField.text!
        }
        //switchParkingの結果を渡す
        if parkingFlag == true{
            lifeVC.parking = "true"
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
        let lifeTVC = self.storyboard?.instantiateViewController(identifier: "lifeTableView") as! LifeTableViewController
        navigationController?.pushViewController(lifeTVC,withRetroTransition: SwingInRetroTransition())
        //画面遷移しながら値を渡す
        
        // SecondViewController型のViewControllerを格納
        let lifeTableVC: LifeTableViewController = lifeTVC as! LifeTableViewController
        //showTypeの検索
        //近い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[1]{
            lifeTableVC.selectedShowType = "dist"
        }
        //金額が安い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[2]{
            lifeTableVC.selectedShowType = "price"
        }
        //金額が高い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[3]{
            lifeTableVC.selectedShowType = "-price"
        }
        //星の数が多い順
        if dataSourceForShowType[self.showTypePickerView.selectedRow(inComponent: 0)] == dataSourceForShowType[4]{
            lifeTableVC.selectedShowType = "-rating"
        }
        
        //lifeDetailの検索
        //病院、診療所
        for i in 1..<50 {
            if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i]{
                if i >= 10{
                    lifeTableVC.selectedLifeDetail = "04010" + String(i)
                }else{
                    lifeTableVC.selectedLifeDetail = "040100" + String(i)
                }
                
            }
        }
        //薬局
        for i in 1..<2 {
            if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+49]{
                lifeTableVC.selectedLifeDetail = "040200" + String(i)
            }
            //マッサージ、整体、治療院
            for i in 1..<7 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+50]{
                    lifeTableVC.selectedLifeDetail = "040300" + String(i)
                }
            }
            //介護、福祉
            for i in 1..<7 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+56]{
                    lifeTableVC.selectedLifeDetail = "040400" + String(i)
                }
            }
            //趣味、習い事
            for i in 1..<32 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+62]{
                    if i >= 14{
                        //APIに存在しない為ひとつ繰り上げ
                        lifeTableVC.selectedLifeDetail = "04050" + String(i+1)
                    }else if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04050" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "040500" + String(i)
                    }
                    
                }
            }
            //学校、大学、専門学校
            for i in 1..<12 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+92]{
                    lifeTableVC.selectedLifeDetail = "040600" + String(i)
                }
            }
            
            //進学塾、予備校、各種学校
            for i in 1..<11 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+103]{
                    if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04070" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "040700" + String(i)
                    }
                }
            }
            
            
            //保育園、幼稚園、育児
            for i in 1..<12 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+113]{
                    if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04080" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "040800" + String(i)
                    }
                    
                }
            }
            //住宅、不動産
            for i in 1..<11 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+124]{
                    if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04090" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "040900" + String(i)
                    }
                }
            }
            
            //住宅設備
            for i in 1..<8 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+134]{
                    if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04100" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "041000" + String(i)
                    }
                }
            }
            
            //郵便局、宅配便
            for i in 1..<3 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+141]{
                    lifeTableVC.selectedLifeDetail = "041100" + String(i)
                }
            }
            //生活サービス
            for i in 1..<33 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+143]{
                    if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04120" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "041200" + String(i)
                    }
                    
                }
            }
            //自動車、バイク
            for i in 1..<18 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+175]{
                    if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04130" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "041300" + String(i)
                    }
                    
                }
            }
            //結婚式場、結婚相談所
            for i in 1..<4 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+192]{
                    lifeTableVC.selectedLifeDetail = "041400" + String(i)
                }
            }
            //葬祭、仏壇
            for i in 1..<6 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+195]{
                    lifeTableVC.selectedLifeDetail = "041500" + String(i)
                }
            }
            //銀行、保険、金融
            for i in 1..<9 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+200]{
                    lifeTableVC.selectedLifeDetail = "041600" + String(i)
                }
            }
            //ペット、動物病院
            for i in 1..<8 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+208]{
                    lifeTableVC.selectedLifeDetail = "041700" + String(i)
                }
            }
            //銭湯、浴場
            for i in 1..<7 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+215]{
                    lifeTableVC.selectedLifeDetail = "041800" + String(i)
                }
            }
            //美容、サロン
            for i in 1..<15 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+221]{
                    if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04190" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "041900" + String(i)
                    }
                }
            }
            //専門職、弁護士、司法書士
            for i in 1..<14 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+235]{
                    if i >= 10{
                        lifeTableVC.selectedLifeDetail = "04200" + String(i)
                    }else{
                        lifeTableVC.selectedLifeDetail = "042000" + String(i)
                    }
                }
            }
            //人材派遣
            for i in 1..<5 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+248]{
                    lifeTableVC.selectedLifeDetail = "042100" + String(i)
                }
            }
            //官公庁
            for i in 1..<5 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+252]{
                    lifeTableVC.selectedLifeDetail = "042200" + String(i)
                }
            }
            //公共サービス、各種団体
            for i in 1..<10 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+256]{
                    lifeTableVC.selectedLifeDetail = "042300" + String(i)
                }
            }
            //寺院、神社
            for i in 1..<5 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+265]{
                    lifeTableVC.selectedLifeDetail = "042400" + String(i)
                }
            }
            //避難所、避難場所
            for i in 1..<3 {
                if dataSourceForLifeDetail[self.lifeDetailPickerView.selectedRow(inComponent: 0)] == dataSourceForLifeDetail[i+269]{
                    lifeTableVC.selectedLifeDetail = "042500" + String(i)
                }
            }
            
            //距離をlifeTableVCに反映させる
            lifeTableVC.maxMoney = maxMoneyTextField.text!
        }
        //switchParkingの結果を渡す
        if parkingFlag == true{
            lifeTableVC.parking = "true"
        }
    }
    
    @IBAction func toRandomLife(_ sender: Any) {
        music.playSound(fileName: "ショッピングタップ音", extentionName: "mp3")
        performSegue(withIdentifier: "RandomLeisure", sender: nil)
    }
}

