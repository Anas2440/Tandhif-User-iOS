//
//  Closures.swift
//  Gofer
//
//  Created by Trioangle Technologies on 04/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//


import Foundation
import UIKit





public extension UIView{
    
    
    func addTap(Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
}

