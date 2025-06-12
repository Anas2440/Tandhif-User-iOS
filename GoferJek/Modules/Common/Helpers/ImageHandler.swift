//
//  ImageHandler.swift
//  Goferjek
//
//  Created by Trioangle on 17/01/22.
//  Copyright © 2022 Vignesh Palanivel. All rights reserved.
//

import Foundation
import Photos
import AVFoundation
import UIKit

class ImageHandler : NSObject {
    
    enum ImageHandlingType {
        case camera
        case gallery
    }
    
    static let shared = ImageHandler()
    
    typealias ImageHandlerResult = (_ imagePicker: UIImagePickerController?, _ error : String?) -> Void
    
    func open(typeOfMedia: ImageHandlingType,
              completion: @escaping(ImageHandlerResult)) {
        if UIImagePickerController.isSourceTypeAvailable(typeOfMedia == .camera ? .camera : .photoLibrary) {
            let imagePicker = UIImagePickerController()
            completion(imagePicker, nil)
        } else {
            switch typeOfMedia {
            case .camera:
                completion(nil, LangCommon.deviceHasNoCamera)
            case .gallery:
                completion(nil, "No Gallery")
            }
        }
    }
}

