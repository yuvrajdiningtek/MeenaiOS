

import Foundation
extension Int {
    static func parse(from string: String) -> String? {
        return (string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
//    static func parse(from string:String )->String?{
//
//        let charArray = Array(string)
//        var intergers = ""
//
//        for char in charArray {
//            if let i = Int(String(char)){
//                intergers.append(String(i))
//            }
//        }
//
//        return (intergers)
//    }
}
