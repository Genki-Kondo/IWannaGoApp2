//
//  CustumTableViewCell.swift
//  IWannaGo
//
//  Created by 近藤元気 on 2020/05/16.
//  Copyright © 2020 genkikondo. All rights reserved.
//

import UIKit

class CustumTableViewCell: UITableViewCell {
    
    
    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var telNumberLabel: UILabel!
    @IBOutlet var StationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(dataShopName: [String], dataAddress: [String],datatelNumber: [String],dataStation:[String],timeLabel:[String]) {
        
    }
}
