//
//  OwnLikedTableViewController.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/06/15.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit

class OwnLikedTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //LikedViewControllerlから受け取る為の配列
    var shopName :[String] = []
    var address :[String] = []
    var telNumber :[String] = []
    var station :[String] = []
    var time :[String] = []
    var ownlikedArray :[Info] = []
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ownLikedCell", for: indexPath)
        
        UserDefaults.standard.set(shopName, forKey: "shopName")
        UserDefaults.standard.set(address, forKey: "address")
        UserDefaults.standard.set(telNumber, forKey: "telNumber")
        UserDefaults.standard.set(station, forKey: "station")
        UserDefaults.standard.set(time, forKey: "time")
        var shopName:[String] = UserDefaults.standard.array(forKey: "shopName") as! [String]
        var address:[String] = UserDefaults.standard.array(forKey: "address") as! [String]
        var telNumber:[String] = UserDefaults.standard.array(forKey: "telNumber") as! [String]
        var station:[String] = UserDefaults.standard.array(forKey: "station") as! [String]
        var time:[String] = UserDefaults.standard.array(forKey: "time") as! [String]
        
        let shopNameLabel = cell.viewWithTag(1)as! UILabel
        shopNameLabel.text = shopName[1]
        let addressLabel = cell.viewWithTag(2)as! UILabel
        addressLabel.text = address[1]
        let telNumberLabel = cell.viewWithTag(3)as! UILabel
        telNumberLabel.text = telNumber[1]
        let stationLabel = cell.viewWithTag(4)as! UILabel
        stationLabel.text = station[1]
        let timeLabel = cell.viewWithTag(5)as! UILabel
        timeLabel.text = time[1]
        return cell
    }
    
    
}
