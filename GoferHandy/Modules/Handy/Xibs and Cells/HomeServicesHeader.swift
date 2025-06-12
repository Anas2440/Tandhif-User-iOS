//
//  HomeServicesHeader.swift
//  GoferHandy
//
//  Created by Trioangle on 13/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class HomeServicesHeader: UICollectionReusableView {

  @IBOutlet weak var serviceHeadingLbl: InactiveRegularLabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      self.serviceHeadingLbl.text = LangCommon.services
    }
  
    
}
