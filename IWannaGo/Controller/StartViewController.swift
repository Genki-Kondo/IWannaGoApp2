//
//  StartViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/06/16.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit
import RetroTransition
import Lottie
class StartViewController: UIViewController,UITextFieldDelegate{
    
    
    
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var passwordTextField: UITextField!
    var music = Music()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showAnimation()
        
        passwordTextField.delegate = self
        startButton.isHidden = true
        
        if startButton.isHidden == false{
            startButton.layer.cornerRadius = 30
        }
    }
    //画面タップで波紋を出すメソッドを呼び出す
    override func awakeFromNib() {
        super.awakeFromNib()

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapContentView(touch:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func tapContentView(touch: UITapGestureRecognizer) {

        self.view.波紋(touch: touch)
    }
    //textFieldを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
    }
    
    //textFieldを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.passwordTextField.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if passwordTextField.text == "" {
            startButton.isHidden = true
        }else{
            startButton.isHidden = false
        }
    }
    
    //スタートボタンクリックで画面遷移
    @IBAction func toMenu(_ sender: Any) {
        //クリック時に音声を鳴らす
        music.playSound(fileName: "スタート音", extentionName: "mp3")
        //ボタンの色えを変える
        startButton.backgroundColor = .black
        //アプリにユーザーのパスワードを保存する
        var userPassWord = passwordTextField.text
        UserDefaults.standard.set(userPassWord, forKey: "userPassWord")
        
        //画面遷移
        let menuVC = self.storyboard?.instantiateViewController(identifier: "menuView") as! MenuViewController
        navigationController?.pushViewController(menuVC,withRetroTransition: SwingInRetroTransition())
        
    }
    //一回再生したらアニメーションを消す
    func showAnimation() {
        let animationView = AnimationView(name: "mapAnim")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        view.addSubview(animationView)
        
        animationView.play { finished in
            if finished {
                animationView.removeFromSuperview()
            }
        }
    }
    
    
    
}
//画面タップで波紋を出す為のクラス
extension UIView {
    func 波紋(touch: UITapGestureRecognizer) {

        
        // ①: タップされた場所にlayerを置き、半径200の円を描画
        let location = touch.location(in: self)
        let layer = CAShapeLayer.init()
        self.layer.addSublayer(layer)
        layer.frame = CGRect.init(x: location.x, y: location.y, width: 100, height: 100)
        layer.position = CGPoint.init(x: location.x, y: location.y)
        layer.contents = {
            let size: CGFloat = 200.0
            UIGraphicsBeginImageContext(CGSize.init(width: size, height: size))
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(self.frame)
            let r = CGFloat.init(size/2-10)
            let center = CGPoint.init(x: size/2, y: size/2)
            let path : CGMutablePath = CGMutablePath()
            path.addArc(center: center, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
            context.addPath(path)
            context.setFillColor(UIColor.lightGray.cgColor)
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.drawPath(using: .fillStroke)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context.restoreGState()
            return image!.cgImage
        }()

        // ②: 円を拡大しつつ透明化するAnimationを用意
        let animationGroup: CAAnimationGroup = {
            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
                animation.duration = 0.9
                animation.isRemovedOnCompletion = false
                animation.fillMode = CAMediaTimingFillMode.forwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 5.0)
                return animation
            }()

            let animation2: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = CAMediaTimingFillMode.forwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 0.0)
                return animation
            }()

            let group = CAAnimationGroup()
            group.beginTime = CACurrentMediaTime()
            group.animations = [animation, animation2]
            group.isRemovedOnCompletion = false
            group.fillMode = CAMediaTimingFillMode.backwards
            return group
        }()

        // ③: layerにAnimationを適用
        CATransaction.setAnimationDuration(5.0)
        CATransaction.setCompletionBlock({
            layer.removeFromSuperlayer()
        })
        CATransaction.begin()
        layer.add(animationGroup, forKey: nil)
        layer.opacity = 0.0
        CATransaction.commit()
    }
}
