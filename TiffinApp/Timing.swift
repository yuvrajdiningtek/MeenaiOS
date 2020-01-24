//
//  Timing.swift
//  TiffinApp
//
//  Created by netmobix on 24/09/19.
//  Copyright © 2019 YAY. All rights reserved.
//

import UIKit

class Timing: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var closingDayLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var closingTimeLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var timingTypeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
