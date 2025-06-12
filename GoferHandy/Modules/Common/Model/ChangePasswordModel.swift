//
//  ChangePasswordModel.swift
//  GoferHandy
//
//  Created by Trioangle on 11/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

class ChangePasswordModel: NSObject {
  //MARK:- Properties
  var status_message : String = ""
  var status_code : String = ""
  init(json:JSON) {
    super.init()
    self.status_code = "\(json.status_code)"
    self.status_message = json.status_message
  }
}
