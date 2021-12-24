

import UIKit
import MapKit
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}
class RestrauntInfoVC: UIViewController {

    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var addressLbl : UILabel!
    @IBOutlet weak var distancelbl : UILabel!
    @IBOutlet weak var stackView : UIStackView!
    @IBOutlet weak var backbtn : PopBtn!

    var addressname = "913 Broadway,New York,New York"
    
//    var sourceLocation :CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:40.7394308338052 , longitude: -73.9899413670696 )
    var sourceLocation :CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:28.5691 , longitude: 77.1857 )
    
    var destinationLocation : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var fromSideMenu : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressname = getRestrauntAddress()
        self.setResstaurantLocation()
        self.setmapView()
        self.setUI()
        self.appPinAtLocation()
        self.backbtn.fromSideMenu  = fromSideMenu
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    func setResstaurantLocation(){
        
        guard let merchantDetail = DBManager.sharedInstance.database.objects(MerchantDetail.self).first else{return}
        
        
        let lonitude = merchantDetail.object?.location_longitude ?? 77.1857
        let latitude = merchantDetail.object?.location_latitude ?? 28.5691
        
        sourceLocation = CLLocationCoordinate2D(latitude: latitude, longitude: lonitude)
        
    }
//    func getRestrauntAddress()->String{
//        var shop_address = ""
//        var name = ""
//        if  DBManager.sharedInstance.get_merchntdetail_DataFromDB().count != 0 {
//            let MD  = DBManager.sharedInstance.get_merchntdetail_DataFromDB()[0] as MerchantDetail
//            shop_address = (MD.object?.description_point) ?? ""
//            name = MD.object?.name ?? ""
//            let addressPostalCode = (MD.object?.address_postal_code) ?? "80302"
//
//            let addressState = (MD.object?.address_state) ?? "Colorado"
//            let fullNameArr : [String] = shop_address.components(separatedBy: " ")
//
//
//
//             var Name1 : String = fullNameArr[0]
//             var Name2 : String = fullNameArr[1]
//             var Name3 : String = fullNameArr[2]
//             var Name4 : String = fullNameArr[3]
//             var Name5 : String = fullNameArr[4]
//
//            shop_address = name + "\n" + Name2 + " " + Name4 + " " + Name5 + "\n"  + "" + "Boulder" + Name3 + " " + addressState + ", " + Name1
//
//            let phonenumber = "\nPhone: " + (MD.object?.MERCHANT_CONTACT ?? "Not available")
//            shop_address.append(phonenumber)
//
//        }else { }
//        return shop_address
//    }
    
    func getRestrauntAddress()->String{
             var shop_address = ""
                   var name = ""
                   var address_city = ""
                   var address_address = ""
                   if  DBManager.sharedInstance.get_merchntdetail_DataFromDB().count != 0 {
                       let MD  = DBManager.sharedInstance.get_merchntdetail_DataFromDB()[0] as MerchantDetail
                       shop_address = (MD.object?.description_point) ?? ""
                       
                       name = MD.object?.name ?? ""
                       address_city = MD.object?.address_city ?? ""
                       address_address = MD.object?.address_address ?? ""
           //            let addressPostalCode = (MD.object?.address_postal_code) ?? "80302"
           //
                       let addressState = (MD.object?.address_state) ?? "CO"
                       let namepoint = (MD.object?.name_point) ?? "80111"
                       let fullNameArr : [String] = shop_address.components(separatedBy: " ")



           //            var Name1 : String = fullNameArr[0]
           //            var Name2 : String = fullNameArr[1]
           //            var Name3 : String = fullNameArr[2]
           //            var Name4 : String = fullNameArr[3]
           //            var Name5 : String = fullNameArr[4]

                       shop_address = name + "\n" + address_address + "\n" + address_city + ", " + addressState + ", " + namepoint

                       
                       let phonenumber = "\nPhone: " + (MD.object?.MERCHANT_CONTACT ?? "Not available")
                       shop_address.append(phonenumber)
                       
               
           }else { }
           return shop_address
       }
}

extension RestrauntInfoVC{
    func setUI(){
        addressLbl.text = getRestrauntAddress()
        
        // get timings
       GetData.getTimingOfRestrauntV2 { (_, tupleArr) in
        
            for i in tupleArr{
                print(i)
                let headerlabel = self.getLabel( .black, i.0)
                self.stackView.addArrangedSubview(headerlabel)
                
                let detaillabel = self.getLabel( .lightGray, i.1)
                self.stackView.addArrangedSubview(detaillabel)
                
            }
        }
        
    }
    
    func getLabel(_ color : UIColor , _ text : String)->UILabel{
        let label = UILabel()
        label.textColor = color
        label.text = text
        label.font = UIFont(name: "GlacialIndifference-Regular", size: 16)
        label.widthAnchor.constraint(equalToConstant: self.stackView.frame.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        return label
    }
}

extension RestrauntInfoVC{
    func setmapView(){
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    func appPinAtLocation(){
        let sourcePin = customPin(pinTitle: addressname, pinSubTitle: "", location: sourceLocation)
        self.mapView.addAnnotation(sourcePin)
        let viewRegion = MKCoordinateRegion(center: sourceLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    
    
    
    func getDirections(destinationLocation : CLLocationCoordinate2D){
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            for i in directionResonse.routes{
                //add rout to our mapview
                self.mapView.addOverlay(i.polyline, level: .aboveRoads)
                
            }
            //get route and assign to our route variable
            let route = directionResonse.routes[0]
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            
            let distance = route.distance / 1000
            let dis = formatter.string(from: NSNumber(value: distance))! + " km"
            
            self.distancelbl.text = dis
            //setting rect of our mapview to fit the two locations
            let rect = route.polyline.boundingMapRect
            
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
    }
}


extension RestrauntInfoVC : MKMapViewDelegate , CLLocationManagerDelegate{
    //MARK:- MapKit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        if mapView.overlays.count == 1{
            renderer.strokeColor = UIColor.blue
        }else if mapView.overlays.count == 2{
            renderer.strokeColor = UIColor.red
        }
        renderer.lineWidth = 4.0
        return renderer
    }
   
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if destinationLocation == nil{
            destinationLocation = userLocation.coordinate
            self.appPinAtLocation()
            self.getDirections(destinationLocation: destinationLocation!)
        }
    }
}
