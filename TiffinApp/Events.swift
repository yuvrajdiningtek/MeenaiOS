//
//  Events.swift
//  TiffinApp
//
//  Created by NMX MacBook on 10/12/19.
//  Copyright © 2019 YAY. All rights reserved.
//

import UIKit

class Events: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var moreinfoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventImage.layer.cornerRadius = 20
        eventImage.layer.cornerRadius = 20
        eventImage.layer.cornerRadius = 10
        mainView.layer.cornerRadius = 20
        mainView.layer.cornerRadius = 20
        mainView.layer.cornerRadius = 10
        mainView.layer.borderWidth = 0.7
        mainView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
