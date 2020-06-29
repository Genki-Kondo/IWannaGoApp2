//
//  Music.swift
//  Swift5NewsChat
//
//  Created by 近藤元気 on 2020/04/29.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import Foundation
import AVFoundation
class Music{
    var  player:AVAudioPlayer?
    func playSound(fileName:String, extentionName:String){
    //再生する
    let  soundURL1  =  Bundle.main.url(forResource: fileName,withExtension: extentionName)
        do {
            player = try AVAudioPlayer(contentsOf: soundURL1!)
            player?.play()
        } catch  {
            print("エラーです")
        }
    }
    func stopSound(fileName:String, extentionName:String){
    //再生する
    let  soundURL2  =  Bundle.main.url(forResource: fileName,withExtension: extentionName)
        do {
            player = try AVAudioPlayer(contentsOf: soundURL2!)
            player?.stop()
        } catch  {
            print("エラーです")
        }
    }
    func loopSound(fileName:String, extentionName:String){
    //再生する
    let  soundURL3  =  Bundle.main.url(forResource: fileName,withExtension: extentionName)
        do {
            player = try AVAudioPlayer(contentsOf: soundURL3!)
            player?.numberOfLoops = -1
            player?.play()
        } catch  {
            print("エラーです")
        }
    }
}
