//
//  Debug Printer.swift
//  Goferjek
//
//  Created by Trioangle on 03/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

public
func debug(print msg: String,
           file : String = #file,
           fun : String = #function,
           line : Int = #line){
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("∂:/ message: \(msg) -> file: \(fileName) -> function : \(fun) -> line : \(line.description)")
}
public
func debug(print msg: CustomStringConvertible,
           file : String = #file,
           fun : String = #function,
           line : Int = #line){
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("∂:/ message: \(msg.description) -> file: \(fileName) -> function : \(fun) -> line : \(line.description)")
}
public
func debug(print msg: CustomDebugStringConvertible,
           file : String = #file,
           fun : String = #function,
           line : Int = #line) {
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("∂:/ message: \(msg.debugDescription) -> file: \(fileName) -> function : \(fun) -> line : \(line.description)")
}
public
func debug(print msg: Error,
           file : String = #file,
           fun : String = #function,
           line : Int = #line){
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("∂:/ message: \(msg.localizedDescription) -> file: \(fileName) -> function : \(fun) -> line : \(line.description)")
}
