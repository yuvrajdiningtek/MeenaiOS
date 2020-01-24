
import UIKit
import FSPagerView
import Hero

class SlidingDataVC: UIViewController {

    @IBOutlet weak var pagerView : FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    var images = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        self.setUpPagerView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func setUpPagerView(){
        pagerView.transformer = FSPagerViewTransformer(type: .depth)
        pagerView.hero.id = "galleryImages"
        pagerView.dataSource = self
        self.setDataSource()
        pagerView.reloadData()
    }
    func setDataSource(){
        images.removeAll()
        images = GetData.getImagesFromDataBase()
        
    }
    
}

extension SlidingDataVC : FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
         let url = URL(string: images[index].html2String)
            cell.imageView?.sd_setImage(with: url, placeholderImage: GlobalVariables.placeholderImg)
        
//            cell.textLabel?.text = ...
        
        return cell
    }
    
    
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
