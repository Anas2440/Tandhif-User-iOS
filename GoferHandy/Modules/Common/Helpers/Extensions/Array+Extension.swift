//
//  Array+Extension.swift
//  Gofer
//
//  Created by trioangle on 27/01/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    func anySatisfy(_ condition: @escaping (Element)-> Bool) -> Bool{
        for item in self{
            if condition(item){return true}
        }
        return false
    }
}
