//
//  CellProtocol.swift
//  Gofer
//
//  Created by trioangle on 10/05/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

protocol ProjectCell {
    associatedtype myCell
    var identifier : String{get}
}
extension UICollectionView{
    func generate<T:ProjectCell>(_ cell : T,forIndex index : IndexPath) -> T.myCell{
        return self.dequeueReusableCell(withReuseIdentifier: cell.identifier, for: index) as! T.myCell
    }
}
extension UITableView{
    func generate<T:ProjectCell>(_ cell : T,forIndex index : IndexPath) -> T.myCell{
        return self.dequeueReusableCell(withIdentifier: cell.identifier, for: index) as! T.myCell
    }
}
