

import Foundation
import Alamofire

class PlaceApi {
    
    //MARK: - GET PLACE LIST
    class public func get_List_of_places(keyword : String,  callback :@escaping ((Bool,PlacesListModel?)->()) ){
        var apiurl = URLComponents(string: ApiKeys.searchPlaces)
        let accessToken = "Bearer " + ApiKeys().accessToken()
        
        apiurl?.queryItems = [
            URLQueryItem(name: "input", value: keyword)
            
        ]
        let headers = ["authorization":accessToken]
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default,headers : headers).responseJSON { (respose) in
            
            guard let rst = respose.result.value as? NSDictionary else {
                callback(false,nil)
                return
            }
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else { callback(false,nil)
                return
            }
            let model = PlacesListModel(value: rst)
            
            callback(true,model)
        }
    }
    
    
    class public func placeDetail(place id : String,  callback :@escaping ((Bool,Double?,Double?)->()) ){
        var apiurl = URLComponents(string: ApiKeys.placeDetail)
        let accessToken = "Bearer " + ApiKeys().accessToken()
        
        apiurl?.queryItems = [
            URLQueryItem(name: "place_id", value: id),
            URLQueryItem(name: "fields", value: "geometry,formatted_address,utc_offset")
        ]
        let headers = ["authorization":accessToken]
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default,headers : headers).responseJSON { (respose) in
            
            guard let rst = respose.result.value as? NSDictionary else {
                callback(false,nil,nil)
                return
            }
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else { callback(false,nil,nil)
                return
            }
            
            guard let object = rst.value(forKey: "object") as? NSDictionary else{callback(false,nil,nil);return}
            guard let geometry = object.value(forKey: "geometry") as? NSDictionary else{callback(false,nil,nil);return}
            guard let location = geometry.value(forKey: "location") as? NSDictionary else{callback(false,nil,nil);return}
            
            let lat  = location.value(forKey: "lat") as? Double  ?? 0.0
            let lng  = location.value(forKey: "lng") as? Double  ?? 0.0
            callback(true,lat,lng)
        }
        
    }
}
