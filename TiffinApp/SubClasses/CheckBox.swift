//
//  CheckBox.swift
//  TiffinApp
//
//  Created by netmobix on 09/09/19.
//  Copyright © 2019 YAY. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private var uncheckImg = UIImage(named: "emptyBox")!
    private var checkImg = UIImage(named: "checkBox")!
    
    @IBInspectable var isChecked : Bool = false{
        didSet{
            changeButtonSate()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        changeButtonSate()
    }
    private func commonInit(){
        self.addTarget(self, action: #selector(checkBoxDidClick), for: .touchUpInside)
        
    }
    @objc private func checkBoxDidClick(_ sender : UIButton){
        isChecked = !isChecked
        changeButtonSate()
    }
    private func changeButtonSate(){
        let img = isChecked ? checkImg : uncheckImg
        self.setImage(img, for: .normal)
    }
}
