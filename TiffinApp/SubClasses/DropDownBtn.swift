

import UIKit
import DropDown

class DropDownBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    var dropDownAction : ((String,Int)->())?
    var dropDown : DropDown = DropDown()
    var selection : (Int,String)?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    var dataSource : [String] = [String](){
        didSet{
            refresh()
        }
    }
    func commonInit(){
        self.addTarget(self, action: #selector(touchupInside), for: .touchUpInside)
    }
    @objc func touchupInside(_ sender : UIButton){
        dropDown.show()
    }
    
    func refresh(){
        setDropDown()
    }
    
    private func setDropDown(){
        
        dropDown.anchorView = self
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.dataSource = dataSource
//        dropDown.cancelAction = { [unowned self] in
//
//        }
//
//        dropDown.willShowAction = { [unowned self] in
//
//        }
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if let action = self.dropDownAction{
                action(item,index)
            }
            else{
                self.selection = (index,item)
                self.setTitle(item, for: .normal)
            }
            
        }
    }
}
