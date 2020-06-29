//
//  Info.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/16.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import Foundation
class Info {
   
    var shopName :String = ""
    var address :String = ""
    var telNumber :String = ""
    var station :String = ""
    var time :String = ""
    init(shopName:String,address:String,telNumber:String,station:String,time:String) {
        self.shopName = shopName
        self.address = address
        self.telNumber = telNumber
        self.station = station
        self.time = time
    }
    
}
