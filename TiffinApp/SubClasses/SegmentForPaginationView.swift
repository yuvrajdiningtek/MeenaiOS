


import Foundation
import UIKit
class SegmentForPaginationView : UIView{
    
    @IBOutlet weak  private var contentV: UIView!

    
    @IBOutlet weak private var pNoIncbtn: UIButton!
    @IBOutlet weak private var pNoDecbtn: UIButton!
    @IBOutlet weak private var pNolbl: UILabel!
    var pageNumber = 0{
        didSet{
            pNolbl.text = "Page No. "+"\(pageNumber+1)"
            if pageNumber == 0{
                pNoDecbtn.isUserInteractionEnabled = false
                pNoDecbtn.backgroundColor = btnDiableColor
            }
            else if pageNumber == (maxLimitOfPageNumber-1){
                pNoIncbtn.isUserInteractionEnabled = false
                pNoIncbtn.backgroundColor = btnDiableColor
            }
        }
    }
    var maxLimitOfPageNumber = 0{
        didSet{
            if maxLimitOfPageNumber == pageNumber{
                pNoIncbtn.isUserInteractionEnabled = false
                pNoIncbtn.backgroundColor = btnDiableColor
            }
            
        }
    }
    var valueChanged : ((Int)->())?
    let btnEnableColor = UIColor(hex: 0xF29328)
    let btnDiableColor = UIColor(hex: 0xAAAAAA)
    @IBAction func pageIncremntbtn (_ sender : UIButton)
    {
        sender.isUserInteractionEnabled = true
        sender.backgroundColor = btnEnableColor
        if pageNumber < maxLimitOfPageNumber{
            pageNumber += 1
            valueChanged?(pageNumber)
            pNoDecbtn.isUserInteractionEnabled = true
            pNoDecbtn.backgroundColor = btnEnableColor
        }
    }
    
    @IBAction func pageDecrementbtn (_ sender : UIButton)
    {
        sender.isUserInteractionEnabled = true
        sender.backgroundColor = btnEnableColor
        if pageNumber > 0{
            pageNumber -= 1
            valueChanged?(pageNumber)
            pNoIncbtn.isUserInteractionEnabled = true
            pNoIncbtn.backgroundColor = btnEnableColor
        }
        
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commoninit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commoninit()
    }
    func commoninit(){
       
        
        Bundle.main.loadNibNamed("SegmentForPaginationView", owner: self, options: nil)
        addSubview(contentV)
        contentV.frame = self.bounds
        contentV.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        pNoIncbtn.layer.cornerRadius = 5
        pNoDecbtn.layer.cornerRadius = 5
        pNolbl.layer.cornerRadius = 5
    }
}
