//
//  Offers.swift
//  TiffinApp
//
//  Created by NMX MacBook on 09/03/22.
//  Copyright © 2022 YAY. All rights reserved.
//

import UIKit

class Offers: UICollectionViewCell {
    @IBOutlet weak var offerNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.init(named: "MaroonTheme")?.cgColor
        contentView.layer.cornerRadius = 7
        contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

    }

}
