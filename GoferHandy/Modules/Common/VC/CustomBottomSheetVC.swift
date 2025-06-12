//
//  CustomBottomSheetVC.swift
//  GoferHandy
//
//  Created by Trioangle on 05/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class CustomBottomSheetVC : BaseViewController {
    
    var delegate : CustomBottomSheetDelegate!
    var pageTitle: String?
    var detailsArray : [String]?
    var ImageArray: [String]?
    var isImageUrl: Bool?
    var selectedItem : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    class func initWithStory(_ delegate: CustomBottomSheetDelegate,
                             pageTitle: String?,
                             selectedItem : String?,
                             detailsArray: [String]?,
                             ImageArray: [String]? = nil,
                             isImageUrl: Bool? = false) -> CustomBottomSheetVC {
        
        let vc : CustomBottomSheetVC = UIStoryboard.gojekCommon.instantiateViewController()
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = delegate
        
        if let pageTitle = pageTitle {
            vc.pageTitle = pageTitle
        } else {
            print("Page Title is Missing")
        }
        
        if let selectedItem = selectedItem {
            vc.selectedItem = selectedItem
        } else {
            print("Selected Item is Missing")
        }
        
        if let detailsArray = detailsArray {
            vc.detailsArray = detailsArray
        } else {
            print("details Array is Missing")
        }
        
        if let ImageArray = ImageArray {
            vc.ImageArray = ImageArray
        } else {
            print("Image Array is Missing")
        }
        
        if let isImageUrl = isImageUrl {
            vc.isImageUrl = isImageUrl
        } else {
            print("is ImageUrl is Missing")
        }
        
        return vc
    }
    
}
