//
//  closure.swift
//  Gofer
//
//  Created by trioangle on 31/01/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

typealias Closure<T> = (T)->()

extension JSONDecoder{
//    func decode<T : Decodable>(_ model : T.Type,
//                               result : @escaping Closure<T>) ->Closure<Data>{
//        return { data in
//            do{
//                let value = try self.decode(model.self, from: data)
//                result(value)
//                
//            }catch{
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func decode<T : Decodable>(_ model : T.Type,
                                   result : @escaping Closure<T>) -> Closure<Data> {
            return { data in
                print(data,"data...ferwed")
                do {
                    print("🔍 JSON String: \(String(data: data, encoding: .utf8) ?? "Unable to decode data to string")")
                    let value = try self.decode(model.self, from: data)
                    result(value)
                } catch {
                    print("❌ JSON Decoding Failed: \(error.localizedDescription)")
                    print("Raw JSON String:", String(data: data, encoding: .utf8) ?? "nil")
                }
            }
        }
}
