//
//  APIResponseHandler.swift
//  Gofer
//
//  Created by trioangle on 31/01/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation


class APIResponseHandler : APIResponseProtocol{
  
    init(){
    }
    var jsonSeq : Closure<JSON>?
    var dataSeq : Closure<Data>?
    var errorSeq : Closure<String>?
    
    func responseDecode<T>(to modal: T.Type, _ result: @escaping Closure<T>) -> APIResponseProtocol where T : Decodable {
        
        let decoder = JSONDecoder()
        self.dataSeq =  decoder.decode(modal, result: result)
        return self
    }
    
    func responseJSON(_ result: @escaping Closure<JSON>) -> APIResponseProtocol {
        self.jsonSeq = result
        return self
    }
    func responseFailure(_ error: @escaping Closure<String>) {
        self.errorSeq = error
        
    }
      

    

//    func handleSuccess(value : Any,data : Data){
//        print("jsonSeq is nil:", self.jsonSeq == nil)
//        print("dataSeq is nil:", dataSeq == nil)
//        print("Value type:", type(of: value))  // ← THIS will help you see what the actual type is
//        if let jsonEscaping = self.jsonSeq{
//            jsonEscaping(value as! JSON)
//        }
//        if let dataEscaping = dataSeq{
//            dataEscaping(data)
//        }
//    }
    
    func handleSuccess(value: Any, data: Data) {
        print("jsonSeq is nil:", self.jsonSeq == nil)
        print("dataSeq is nil:", dataSeq == nil)
        print("Value type:", type(of: value))

        // Safely cast or convert to JSON
        if let dict = value as? [String: Any] {
            self.jsonSeq?(dict)
        } else if let nsDict = value as? NSDictionary as? [String: Any] {
            self.jsonSeq?(nsDict)
        } else {
            print("❌ Could not convert value to [String: Any]")
            self.errorSeq?("Invalid response format")
        }

        // ✅ Ensure this always runs
        self.dataSeq?(data)
    }



    
    func handleFailure(value : String){
        self.errorSeq?(value)
     }
   
}
