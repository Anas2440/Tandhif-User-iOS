//
//  AVVideo + Extension.swift
//  GoferHandy
//
//  Created by trioangle on 04/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
extension PHPhotoLibrary {
    enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizePhotoLibrary(completion: ((AuthorizationStatus) -> Void)?) {
        let authorizeStatus = PHPhotoLibrary.authorizationStatus()
            switch authorizeStatus{
            case .denied:
                authorizationImagePickerAlert(title: appName,
                                              message: LangCommon.pleaseGivePermission)
                completion?(.alreadyDenied)
                break
            case .authorized:
                 completion?(.alreadyAuthorized)
                break
            case .restricted:
                completion?(.restricted)
                break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) in
                    switch status{
                    case .authorized:
                        completion?(.justAuthorized)
                    case .denied:
                        completion?(.justDenied)
                        break
                    default:
                        break
                    }
                })
                break
            default:
                break
            }
    }
}

//
//MARK: - Image picker authorization alert
//
func authorizationImagePickerAlert(title:String, message:String) -> Void {
    //TRVicky
    let commonAlert = CommonAlert()
    
    commonAlert.setupAlert(alert: title,alertDescription: message,  okAction: LangCommon.ok, cancelAction: LangCommon.cancel)
    commonAlert.addAdditionalOkAction(isForSingleOption: false) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
}



extension AVCaptureDevice {
    enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizeVideo(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.video, completion: completion)
    }
    
    class func authorizeAudio(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.audio, completion: completion)
    }
    
    private class func authorize(mediaType: AVMediaType, completion: ((AuthorizationStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .authorized:
            completion?(.alreadyAuthorized)
        case .denied:
            authorizationImagePickerAlert(title: LangCommon.allowCamera, message: LangCommon.toAccessCamera)
            completion?(.alreadyDenied)
        case .restricted:
            completion?(.restricted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if(granted) {
                        completion?(.justAuthorized)
                    }
                    else {
                        completion?(.justDenied)
                    }
                }
            })
        @unknown default:
            print("å:: Not Handled this permission in camera or video")
        }
    }
}
