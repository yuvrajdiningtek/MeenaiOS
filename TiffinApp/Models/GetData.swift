
import Foundation

class GetData: NSObject {

     private let database = DBManager.sharedInstance.database
    
    func todaysWeekday()->String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateFormatter.dateFormat = "EEEE"
        let currentDateString: String = dateFormatter.string(from: date)
        return currentDateString.uppercased(with: nil)
        
    }
    
    func getAllProductsList( completion : (( _ products : [String:[Products]],_ categories : [String] )->())?  ){
        var productArr = [String:[Products]]()
        var titles : [String] = [String]()
        
       
        func mapData(rst : ProductCatData){
            let dataKey  = rst.data
            for d in dataKey{
                
                if let cat = d.category{
                    let title = cat.categoryName
                    titles.append(title)
                    let prod = Array(d.products)
                    
                    productArr[title] = prod
                }
                
            }
            completion?(productArr,titles)
        }
        
        if let rst = getAllProductsFromDataBase(){
            mapData(rst: rst)
        }else{
            
            ProductsApi.ProductCat { (succ, rst) in
                if let rst = self.getAllProductsFromDataBase(){
                    mapData(rst: rst)
                    return
                }else{
                    completion?(productArr,titles)
                    return
                }
            }
        }
        
        
    }
    
     func getAllProductsFromDataBase()->ProductCatData?{
        if DBManager.sharedInstance.database.objects(ProductCatData.self).count != 0{
            
            let rst =  DBManager.sharedInstance.database.objects(ProductCatData.self) [0] as  ProductCatData
            return rst
        }
        return nil
    }
    
    
    func getProductFromDataBase( productId : String)->Products?{
        
        guard let productCatData = database.objects(ProductCatData.self).first else{return nil}
        for i in productCatData.data{
            for j in i.products{
                if j.productId == productId{
                    return j
                }
            }
        }
        return nil
        
    }
    
    static func getImagesUrlArr(data : NSDictionary)->[String]{
        // send nsdictionary of gallery api response
        var imagesurlArr = [String]()

        guard let dataobjarr = data.value(forKey: "data") as? [NSDictionary] else{return imagesurlArr}
        for i in dataobjarr{
            if let dataStr = i.value(forKey: "data") as? String{
                imagesurlArr.append(dataStr)
            }
        }
        return imagesurlArr
    }
    static func  getImagesFromDataBase()->[String]{
        if DBManager.sharedInstance.database.objects(GalleryImages.self).count != 0{
            
           let a = DBManager.sharedInstance.database.objects(GalleryImages.self)[0] as GalleryImages
            return Array(a.image)
        }
        return [String]()
    }
    
    static func getTimingOfRestrauntV2(callback : @escaping (OpenTimingVsec?,[(String,String)])->()){
    
        guard let dd = getTimingDataOfRestFromdatabaseV2() else{
            self.getTimingOfRestrauntV2FromApi { (rst) in
//                print("getTimingOfRestrauntV2FromApi \(rst)");
                let arr = GetData().getTimingString(oTV: rst)
                
                callback(rst,arr)
            }
            return
        }
        let arr = GetData().getTimingString(oTV: dd)
        callback(dd,arr)
        
    }
    
    private func getTimingString(oTV : OpenTimingVsec? )->[(String,String)]{
        var returndata = [(String,String)]()
        if oTV == nil{return returndata}
        for i in oTV!.data{
            let openDay = i.openingDay.firstCapitalized
            let closeDay = i.closingDay.firstCapitalized
            let weekday = openDay + " - " + closeDay
            
            let openingTime = i.openingTime ?? ""
            let closingTime = i.closingTime ?? ""
            let timing = i.name + " : "+openingTime + " - " + closingTime
            
            let tuple = (weekday,timing)
            returndata.append(tuple)
        }
        return returndata
    }
    
    static func getTimingOfRestrauntV2FromApi(callback : @escaping (OpenTimingVsec?)->()){
        
        SomeInformationApi.restraunt_timing(secVersion: true) { (succ, rst) in
            callback( rst as? OpenTimingVsec)
        }
        
    }
    static func getTimingDataOfRestFromdatabaseV2()->OpenTimingVsec?{
        if DBManager.sharedInstance.database.objects(OpenTimingVsec.self).count != 0{
            return DBManager.sharedInstance.database.objects(OpenTimingVsec.self)[0] as OpenTimingVsec            
        }
        return nil
    }
    

    static func getTodaysTimingOfRestraunt(callback : @escaping (RestrauntTiming?,String?)->()){
        
        guard let dd = getTimingDataOfRestFromdatabase() else{
            SomeInformationApi.restraunt_timing(secVersion: false) { (_, rst) in
                guard let _ = rst as? RestrauntTiming else{
                    callback(nil,nil)
                    return
                }
                let timing = GetData().getTheTimingofTodayWeekdays(rst: (rst as! RestrauntTiming))
                callback((rst as! RestrauntTiming),timing)
            }
            return
        }
        let timing = GetData().getTheTimingofTodayWeekdays(rst: dd)
        callback(dd,timing)
        
    }
    private func getTheTimingofTodayWeekdays(rst :RestrauntTiming? )->(String)?{
        
        if rst == nil{return nil}
        for data in rst!.data{
            let weekday = data.name
            let time = data.time
            if weekday == todaysWeekday(){
                return time
            }
        }
        return nil
    }
    static func getTimingDataOfRestFromdatabase()->RestrauntTiming?{
        if DBManager.sharedInstance.database.objects(RestrauntTiming.self).count != 0{
            return DBManager.sharedInstance.database.objects(RestrauntTiming.self)[0] as RestrauntTiming
        }
        return nil
    }

}
