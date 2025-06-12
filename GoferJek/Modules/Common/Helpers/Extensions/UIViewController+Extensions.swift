//
//  UIViewController+Extensions.swift
//  GoferHandy
//
//  Created by trioangle on 10/11/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation


extension UIViewController {
    
    func getJsonFormattedString(_ params: Any)-> String {
        var jsonParamString = String()
        var jsonParamDict = [String:Any]()
        print("params \(jsonParamDict)")
        do {
            if #available(iOS 11.0, *) {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
                // here "jsonData" is the dictionary encoded in JSON data
                
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                // here "decoded" is of type `Any`, decoded from JSON data
                
                // you can now cast it with the right type
                if let dictFromJSON = decoded as? [String:Any] {
                    // use dictFromJSON
                    print(dictFromJSON)
                    jsonParamString = "\(decoded)"
                    jsonParamDict = decoded as! [String : Any]
                    
                }
                do {
                    let data1 =  try JSONSerialization.data(withJSONObject: decoded, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                    jsonParamString = String(data: data1, encoding: String.Encoding.utf8)! // the data will be converted to the string
                    print(jsonParamString)
                } catch let myJSONError {
                    print(myJSONError)
                }
            } else {
                // Fallback on earlier versions
            }
            
            
        }
        catch {
            print(error.localizedDescription)
        }
        let test = String(jsonParamString.filter { !" \n\t\r".contains($0) })
        return test
    }
    
}
