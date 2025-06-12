//
//  ConnectionHandler.swift
//  GoferHandy
//
//  Created by trioangle on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
import PaymentHelper
import Alamofire

final class ConnectionHandler : NSObject {
    static let shared = ConnectionHandler()
    private let alamofireManager : Session
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var preference = UserDefaults.standard
    let strDeviceType = "1"
    let strDeviceToken = Utilities.sharedInstance.getDeviceToken()
    var support = UberSupport()
    var handler = LocalCacheHandler()
    
    override init() {
        print("Singleton initialized")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300 // seconds
        configuration.timeoutIntervalForResource = 500
        alamofireManager = Session.init(configuration: configuration,
                                        serverTrustManager: .none)//Alamofire.SessionManager(configuration: configuration)
    }
    func getRequest(for api : APIEnums,
                    params : Parameters) -> APIResponseProtocol{
        if api.method == .get {
            return self.getRequest(forAPI: "https://tandhif.fr/api/"/*APIUrl*/ + api.rawValue,
                                   params: params,
                                   CacheAttribute: api.cacheAttribute ? api : .none)
        } else {
            return self.postRequest(forAPI: "https://tandhif.fr/api/"/*APIUrl*/ + api.rawValue,
                                    params: params)
        }
    }
    
    func networkChecker(with StartTime:Date,
                        EndTime: Date,
                        ContentData: Data?) {
        
        let dataInByte = ContentData?.count
        
        if let dataInByte = dataInByte {
            
            // Standard Values
            let standardMinContentSize : Float = 3
            let standardKbps : Float = 2
            
            // Kb Conversion
            let dataInKb : Float = Float(dataInByte / 1000)
            
            // Time Interval Calculation
            let milSec  = EndTime.timeIntervalSince(StartTime)
            let duration = String(format: "%.01f", milSec)
            let dur: Float = Float(duration) ?? 0
            
            // Kbps Calculation
            let Kbps = dataInKb / dur
            
            if dataInKb > standardMinContentSize {
                if Kbps < standardKbps {
                    print("å:::: Low Network Kbps : \(Kbps)")
                    self.appDelegate.createToastMessage("LOW NETWORK")
                } else {
                    print("å:::: Normal NetWork Kbps : \(Kbps)")
                }
            } else {
                print("å:::: Small Content : \(Kbps)")
            }
            
        }
    }
    
    func postRequest(forAPI api: String, params: JSON) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var parameters = params
        let startTime = Date()
        parameters["token"] = preference.string(forKey: "access_token")
        parameters["user_type"] = "User"//Global_UserType
        parameters["device_id"] = strDeviceToken
        parameters["device_type"] = strDeviceType
        alamofireManager.request(api,
                                 method: .post,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: nil)
            .responseJSON { (response) in
                print("Å api : ",response.request?.url ?? ("\(api)\(parameters)"))
                
                let endTime = Date()
                
                self.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
                
                guard response.response?.statusCode != 401 else{//Unauthorized
                    if response.request?.url?.description.contains(APIUrl) ?? false{
                        self.doLogoutActions()
                    }
                    return
                }
                
                guard response.response?.statusCode != 503 else { // Web Under Maintenance
                    self.webServiceUnderMaintenance()
                    return
                }
                switch response.result{
                case .success(let value):
                    let json = value as! JSON
                        print(json,"response of json")
                    let error = json.string("error")
                    guard error.isEmpty else{
                        if error == "user_not_found"
                            && response.request?.url?.description.contains(APIUrl) ?? false{
                            self.doLogoutActions()
                        }
                        return
                    }
                    if json.isSuccess
                        || !api.contains(APIUrl)
                        || response.response?.statusCode == 200{
                        
                        responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                    }else{
                        responseHandler.handleFailure(value: json.status_message)
                    }
                case .failure(let error):
                    if error._code == 13 {
                        responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                    } else {
                        responseHandler.handleFailure(value: error.localizedDescription)
                    }
                }
            }
        
        
        return responseHandler
    }
   
    func getRequest(forAPI api: String,
                    params: JSON,
                    CacheAttribute: APIEnums) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var parameters = params
        let startTime = Date()
//        print(api,"̛̦̄̈‰")
        parameters["token"] = preference.string(forKey: "access_token")
        parameters["user_type"] = "User"//Global_UserType
        parameters["device_id"] =  strDeviceToken//Constants().GETVALUE(keyname: "device_token") //strDeviceToken
        parameters["device_type"] = strDeviceType
        if parameters["language"] == nil,
           let language : String =  UserDefaults.value(for: .default_language_option){
            parameters["language"] = language
        }
        
        if CacheAttribute != .none  {
            if CacheAttribute == .getUpCommingJobs ||
                CacheAttribute == .getPastJobs,
               let page = params["page"] as? Int,
               let cache = params["cache"] as? Int,
               let businessID = params["business_id"] as? Int,
               page == 1 && cache == 1 {
                let key = CacheAttribute.rawValue + businessID.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .getServiceCategory,
                      let serviceId = params["service_id"] as? Int,
                      let page = params["page"] as? Int,
                      serviceId != 0 && page == 1 {
                let key = CacheAttribute.rawValue + serviceId.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .getProviderDetail,
                      let providerId = params["provider_id"] as? Int,
                      let categoryID = params["category_id"] as? String,
                      providerId != 0 {
                let key = CacheAttribute.rawValue + providerId.description + categoryID.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .getJobDetail,
                      let tripId = params["job_id"] as? Int,
                      let cache = params["cache"] as? Int,
                      tripId != 0 && cache == 1 {
                let key = CacheAttribute.rawValue + tripId.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .sos ||
                        CacheAttribute == .getServices ||
                        CacheAttribute == .getPromoDetails ,
                      let cache = params["cache"] as? Int,
                      cache == 1 {
                handler.getData(key: CacheAttribute.rawValue) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .serviceType {
                handler.getData(key: CacheAttribute.rawValue) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .home,
                      let page = params["page"] as? String,
                      let service_type = params["service_type"] as? String,
                      let cache = params["cache"] as? Int,
                      cache == 1 &&
                      page == "1" {
                let key = CacheAttribute.rawValue + "S\(service_type)" + "P\(page)"
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .categories,
                      let service_type = params["service_type"] as? Int {
                let key = CacheAttribute.rawValue + "S\(service_type)"
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .newStoreDetails,
                      let store_id = params["store_id"] as? String {
                let key = CacheAttribute.rawValue + "R\(store_id)"
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .getMenuAddon,
                      let menu_item_id = params["menu_item_id"] as? Int {
                let key = CacheAttribute.rawValue + "M\(menu_item_id)"
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .wishlist,
                      let page = params["page"] as? Int,
                      page == 1 {
                let key = CacheAttribute.rawValue + "P\(page)"
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .infoWindow,
                      let ResID = params["id"] as? String {
                let key = CacheAttribute.rawValue + "R\(ResID)"
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            } else if CacheAttribute == .search,
                      let keyword = params["keyword"] as? String,
                      let service_type = params["service_type"] as? Int,
                      let page = params["page"] as? Int,
                      page == 1 {
                let key = CacheAttribute.rawValue + "K\(keyword)" + "S\(service_type)" + "P\(page)"
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    } else { }
                }
            }  else {
                //                handler.getData(key: CacheAttribute.rawValue) { (result) in
                //                    if result.compactMap({$0}).count > 0{
                //                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                //                                                      data: (result.first!)?.model ?? Data() )
                //                    } else { }
                //                }
            }
        }
        alamofireManager.request(api,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: nil)
            .responseJSON { (response) in
                print("\(api)\(params)")
                print("Å api : ",response.request?.url ?? ("\(api)\(params)"))
                let endTime = Date()
                print(response.response?.statusCode,"ßþ¯þ¨ß")
                
                self.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
                
                guard response.response?.statusCode != 503 else { // Web Under Maintenance
                    self.webServiceUnderMaintenance()
                    Shared.instance.removeLoaderInWindow()
                    return
                }
                
                guard response.response?.statusCode != 401 else{//Unauthorized
                    if response.request?.url?.description.contains(APIUrl) ?? false{
                        self.doLogoutActions()
                    }
                    return
                }
                switch response.result {
                    case .success(let value):
                        guard let json = value as? NSDictionary as? JSON else {
                            responseHandler.handleFailure(value: "Invalid response format")
                            return
                        }

                        print(json,"response of json")
                        if CacheAttribute != .none,
                           let key = self.cacheKey(for: CacheAttribute, with: params) {
                            self.handler.store(data: response.data ?? Data(), apiName: key, json: json)
                        }
                        
                            //                    if CacheAttribute != .none {
                            //                        if CacheAttribute == .getUpCommingJobs ||
                            //                            CacheAttribute == .getPastJobs,
                            //                           let businessID = params["business_id"] as? Int,
                            //                           let page = params["page"] as? Int,
                            //                           page == 1 {
                            //                            let key = CacheAttribute.rawValue + businessID.description
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .getServiceCategory,
                            //                                  let serviceId = params["service_id"] as? Int,
                            //                                  let page = params["page"] as? Int,
                            //                                  serviceId != 0 && page == 1 {
                            //                            let key = CacheAttribute.rawValue + serviceId.description
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .getProviderDetail,
                            //                                  let providerId = params["provider_id"] as? Int,
                            //                                  let categoryID = params["category_id"] as? String,
                            //                                  providerId != 0 {
                            //                            let key = CacheAttribute.rawValue + providerId.description + categoryID.description
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .getJobDetail,
                            //                                  let tripId = params["job_id"] as? Int,
                            //                                  let cache = params["cache"] as? Int,
                            //                                  tripId != 0 && cache == 1 {
                            //                            let key = CacheAttribute.rawValue + tripId.description
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        }
                            //                        else if CacheAttribute == .sos ||
                            //                                    CacheAttribute == .getServices ||
                            //                                    CacheAttribute == .getPromoDetails,
                            //                                let cache = params["cache"] as? Int,
                            //                                cache == 1 {
                            //                            let key = CacheAttribute.rawValue
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //
                            //                        } else if CacheAttribute == .serviceType {
                            //                            let key = CacheAttribute.rawValue
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .home,
                            //                                  let page = params["page"] as? String,
                            //                                  let service_type = params["service_type"] as? String,
                            //                                  let cache = params["cache"] as? Int,
                            //                                  cache == 1 &&
                            //                                  page == "1" {
                            //                            let key = CacheAttribute.rawValue + "S\(service_type)" + "P\(page)"
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .categories,
                            //                                  let service_type = params["service_type"] as? Int {
                            //                            let key = CacheAttribute.rawValue + "S\(service_type)"
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .newStoreDetails,
                            //                                  let store_id = params["store_id"] as? String {
                            //                            let key = CacheAttribute.rawValue + "R\(store_id)"
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .getMenuAddon,
                            //                                  let menu_item_id = params["menu_item_id"] as? Int {
                            //                            let key = CacheAttribute.rawValue + "M\(menu_item_id)"
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .wishlist,
                            //                                  let page = params["page"] as? Int,
                            //                                  page == 1 {
                            //                            let key = CacheAttribute.rawValue + "P\(page)"
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .infoWindow,
                            //                                  let ResID = params["id"] as? String {
                            //                            let key = CacheAttribute.rawValue + "R\(ResID)"
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else if CacheAttribute == .search,
                            //                                  let keyword = params["keyword"] as? String,
                            //                                  let service_type = params["service_type"] as? Int,
                            //                                  let page = params["page"] as? Int,
                            //                                  page == 1 {
                            //                            let key = CacheAttribute.rawValue + "K\(keyword)" + "S\(service_type)" + "P\(page)"
                            //                            self.handler.store(data: response.data ?? Data(),
                            //                                               apiName: key,
                            //                                               json: json)
                            //                        } else {
                            //                            //                            self.handler.store(data: response.data ?? Data(),
                            //                            //                                               apiName: CacheAttribute.rawValue,
                            //                            //                                               json: json)
                            //                        }
                            //                    }
                        let error = json.string("error")
                        guard error.isEmpty else{
                            if error == "user_not_found"
                                && response.request?.url?.description.contains(APIUrl) ?? false{
                                self.doLogoutActions()
                            }
                            return
                        }
                        if json.isSuccess
                            || !api.contains(APIUrl)
                            || response.response?.statusCode == 200 {
                            print("Status Code:", response.response?.statusCode ?? 0)
                            print("Raw response data:", String(data: response.data ?? Data(), encoding: .utf8) ?? "nil")
                            print("Parsed value:", value)
                            print("Type of value:", type(of: value))

                            
                            responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                        }else{
                            responseHandler.handleFailure(value: json.status_message)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        if error._code == 13 {
                            responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                        } else {
                            responseHandler.handleFailure(value: error.localizedDescription)
                        }
                }
            }
        
        
        return responseHandler
    }
    
    private func cacheKey(for attribute: APIEnums, with params: JSON) -> String? {
        switch attribute {
        case .getUpCommingJobs, .getPastJobs:
            guard let page = params["page"] as? Int,
                  let cache = params["cache"] as? Int,
                  let businessID = params["business_id"] as? Int,
                  page == 1, cache == 1 else { return nil }
            return attribute.rawValue + businessID.description

        case .getServiceCategory:
            guard let serviceId = params["service_id"] as? Int,
                  let page = params["page"] as? Int,
                  serviceId != 0, page == 1 else { return nil }
            return attribute.rawValue + serviceId.description

        case .getProviderDetail:
            guard let providerId = params["provider_id"] as? Int,
                  let categoryID = params["category_id"] as? String else { return nil }
            return attribute.rawValue + providerId.description + categoryID

        case .getJobDetail:
            guard let tripId = params["job_id"] as? Int,
                  let cache = params["cache"] as? Int,
                  tripId != 0, cache == 1 else { return nil }
            return attribute.rawValue + tripId.description

        case .sos, .getServices, .getPromoDetails, .serviceType:
            guard let cache = params["cache"] as? Int, cache == 1 else { return nil }
            return attribute.rawValue

        case .home:
            guard let page = params["page"] as? String,
                  let service_type = params["service_type"] as? String,
                  let cache = params["cache"] as? Int,
                  cache == 1, page == "1" else { return nil }
            return attribute.rawValue + "S\(service_type)" + "P\(page)"

        case .categories:
            guard let service_type = params["service_type"] as? Int else { return nil }
            return attribute.rawValue + "S\(service_type)"

        case .newStoreDetails:
            guard let store_id = params["store_id"] as? String else { return nil }
            return attribute.rawValue + "R\(store_id)"

        case .getMenuAddon:
            guard let menu_item_id = params["menu_item_id"] as? Int else { return nil }
            return attribute.rawValue + "M\(menu_item_id)"

        case .wishlist:
            guard let page = params["page"] as? Int, page == 1 else { return nil }
            return attribute.rawValue + "P\(page)"

        case .infoWindow:
            guard let resID = params["id"] as? String else { return nil }
            return attribute.rawValue + "R\(resID)"

        case .search:
            guard let keyword = params["keyword"] as? String,
                  let service_type = params["service_type"] as? Int,
                  let page = params["page"] as? Int,
                  page == 1 else { return nil }
            return attribute.rawValue + "K\(keyword)" + "S\(service_type)" + "P\(page)"

        default:
            return nil
        }
    }

    
    func uploadRequest(for api : APIEnums,
                       params : Parameters,
                       data:Data, imageName:String = "image")-> APIResponseProtocol {
        let startTime = Date()
        let responseHandler = APIResponseHandler()
        var param = params
        param["token"] = preference.string(forKey: "access_token")
        param["user_type"] = "User"//Global_UserType
        
        //uberSupport.showProgressInWindow(showAnimation: true)
        print(params)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            let fileName = String(Date().timeIntervalSince1970 * 1000) + "Image.jpg"
            if data != Data(){
                multipartFormData.append(data, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
            }
        }, to: "\(APIUrl)\(api.rawValue)").response { results in
            
            let endTime = Date()
            
            self.networkChecker(with: startTime, EndTime: endTime, ContentData: results.data)
            
            switch results.result{
                
            case .success(let anyData):
                print("Succesfully uploaded")
                print(results.request?.url as Any)
                if let err = results.error{
                    responseHandler.handleFailure(value: err.localizedDescription)
                    //                                       self.appDelegate.createToastMessage(err.localizedDescription, bgColor: .black, textColor: .white)
                    return
                }
                if let data = anyData,
                   let json = JSON(data){
                    if json.status_code == 1{
                        
                        responseHandler.handleSuccess(value: json, data: data)
                    }else{
                        //                                           self.appDelegate.createToastMessage(json.status_message,
                        //                                                                               bgColor: .black,
                        //                                                                               textColor: .white)
                        responseHandler.handleFailure(value: json.status_message)
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                //                               self.appDelegate.createToastMessage(error.localizedDescription, bgColor: .black, textColor: .white)
                if error._code == 13 {
                    responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        
        
        return responseHandler
    }
    
    func uploadPost(wsMethod:String,
                    paramDict: [String:Any],
                    fileName:String="image",
                    imgData:Data?,
                    viewController:UIViewController,
                    isToShowProgress:Bool,
                    isToStopInteraction:Bool,
                    complete:@escaping (_ response: [String:Any]) -> Void) {
        let startTime = Date()
        if isToShowProgress {
            UberSupport().showProgress(viewCtrl: viewController, showAnimation: true)
        }
        if isToStopInteraction {
            // UIApplication.shared.beginIgnoringInteractionEvents()
            UIApplication.shared.windows.last?.isUserInteractionEnabled = false
        }
        
        let goferDelUrl = APIUrl
        //AppWebConstants.APIBaseUrl
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict {
                multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
            }
            let fileName1 =  String(Date().timeIntervalSince1970 * 1000) + "\(fileName).jpg"
            if let data = imgData {
                multipartFormData.append(data,
                                         withName: fileName,
                                         fileName: fileName1,
                                         mimeType: "image/jpeg")
            }
            //Optional for extra parameters
        },to:"\(goferDelUrl)\(wsMethod)") .response { resp in
            
            //
            let endTime = Date()
            
            self.networkChecker(with: startTime, EndTime: endTime, ContentData: resp.data)
            
            switch resp.result {
            case .success(let data):
                if isToShowProgress {
                    UberSupport().removeProgress(viewCtrl: viewController)
                }
                if isToStopInteraction {
                    //UIApplication.shared.endIgnoringInteractionEvents()
                    UIApplication.shared.windows.last?.isUserInteractionEnabled = true
                }
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String:Any] {
                        guard responseDict["error"] == nil else {
                            self.appDelegate.createToastMessageForAlamofire(responseDict.string("error"), bgColor: .black, textColor: .white, forView: viewController.view)
                            return
                        }
                        
                        guard responseDict.count > 0 else {
                            self.appDelegate.createToastMessageForAlamofire("Image upload failed",
                                                                            bgColor: .black,
                                                                            textColor: .white,
                                                                            forView: viewController.view)
                            return
                        }
                        
                        if (responseDict["status_code"] as? String ?? "" ) == "0" &&
                            ((responseDict["success_message"] as? String ?? "" ) == "Inactive User" ||
                             (responseDict["success_message"] as? String ?? "" ) == "The token has been blacklisted" ||
                             responseDict["success_message"] as? String ?? ""  == "User not found") {
                            //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "k_LogoutUser"), object: nil)
                            self.appDelegate.createToastMessageForAlamofire("We are having trouble fetching the menu. Please try again.", bgColor: .black, textColor: .white, forView: viewController.view)
                        }
                        else {
                            complete(responseDict as [String : Any] )
                        }
                    }
                } catch {
                    print("Error")
                    self.appDelegate.createToastMessageForAlamofire("We are having trouble fetching the menu. Please try again.", bgColor: .black, textColor: .white, forView: viewController.view)
                }
                
            case .failure(let encodingError):
                print(encodingError)
                //                if encodingError._code == 4 {
                //                    self.appDelegate.createToastMessageForAlamofire("We are having trouble fetching the menu. Please try again.", bgColor: .black, textColor: .white, forView: viewController.view)
                //
                //                }
                //                else  if encodingError._code == 13 {
                //                    self.appDelegate.createToastMessageForAlamofire("No internet connection.".localizedCapitalized, bgColor: .black, textColor: .white, forView: viewController.view)
                //                } else {
                //                    self.appDelegate.createToastMessageForAlamofire(encodingError.localizedDescription, bgColor: .black, textColor: .white, forView: viewController.view)
                //                }
            }
        }
    }
    func doLogoutActions(){
        Shared.instance.resetUserData()
        UserDefaults.clearAllKeyValues()
        self.appDelegate.option = ""
        self.appDelegate.amount = ""
        self.appDelegate.showAuthenticationScreen()
        Global_UserProfile = nil
        // Delivery Splitup Start
        Shared.instance.currentBookingType = .bookNow
        // Delivery Splitup End
        PushNotificationManager.shared?.stopObservingUser()
        
    }
}

extension ConnectionHandler{
    /**
     function that convet json to respective model of parsed API
     - Author: Abishek Robin
     - Parameters:
     - api: APIEnum
     - json: API json data
     - Returns: ResponseEnum
     */
    //MARK: extension
    func webServiceUnderMaintenance() {
        print("WEB UNDER MAINTENANCEEEEEEEEEEEEEEEEEEEE::::::::::::::")
        let webMainVC = WebUnderMaintenanceVC.initWithStory()
        webMainVC.hidesBottomBarWhenPushed = true
        self.appDelegate.topMostViewController().tabBarController?.tabBar.isHidden = true
        webMainVC.modalPresentationStyle = .fullScreen
        //        self.appDelegate.topMostViewController().navigationController?.pushViewController(webMainVC,animated: false)
        self.appDelegate.topMostViewController().present(webMainVC, animated: true, completion: nil)
    }
    
    //    private func handleResponse(forAPI api : APIEnums, json : JSON)-> ResponseEnum{
    //        switch api {
    //        case .socialSignup:
    //            switch json.status_code {
    //            case 1://ExistingUser
    //                let loginData = RiderDataModel(json)
    //                loginData.storeRiderBasicDetail()
    //                loginData.storeRiderImprotantData()
    //                return ResponseEnum.onAuthenticate(loginData)
    //            case 2://newUser
    //                return .newUserNotAuthenticatedYet
    //            default:
    //                return .success
    //                
    //            }
    //        case .validateNumber:
    //            let isValid = json.isSuccess
    //            let otp = json.string("otp")
    //            let message = json.status_message
    //            return ResponseEnum.number(isValid: isValid,
    //                                       OTP: otp,
    //                                       message: message)
    //            
    //            
    //        case .getReferals:
    //            let referalCode = json.string("referral_code")
    //            let refAppLink = json.string("referral_link")
    //            let total_earning = json.string("total_earning")
    //            let max_referal = json.string("referral_amount")
    //            let inCompleteReferals = json.array("pending_referrals")
    //                .compactMap({ReferalModel.init(withJSON: $0)})
    //            let completedReferals = json.array("completed_referrals")
    //                .compactMap({ReferalModel.init(withJSON: $0)})
    //            return ResponseEnum.onReferalSuccess(referal: referalCode,
    //                                                 totalEarning: total_earning,
    //                                                 maxReferal: max_referal,
    //                                                 incomplete: inCompleteReferals,
    //                                                 complete: completedReferals,
    //                                                 appLink: refAppLink)
    //        case .getEssetntials:
    //            
    //            self.handleEssentials(json)
    //            return .essentialDataReceived
    //            
    //        case .currencyConversion:
    //            let amount = json.double("amount")
    //            let brainTreeClientID = json.string("braintree_clientToken")
    //            let currency = json.string("currency_code")
    //            return .onCurrencyConvert(amount: amount,
    //                                      brainTreeClientID: brainTreeClientID,
    //                                      currency: currency)
    //            
    //        case .addAmountToWallet:
    //            if json.status_code == 2{
    //                let intent = json.string("two_step_id")
    //                return .requires3DSecureValidation(forIntent: intent)
    //            }else{
    //                return .amountAddedToWallet(json.status_message)
    //            }
    //        case .getTripDetail:
    //            let detail = TripDetailDataModel(json)
    //            return ResponseEnum.tripDetailData(detail)
    //            
    //        case .getInvoice:
    //            var customizedJSON = JSON()
    //            customizedJSON["riders"] = [json]
    //            
    //            let detail = TripDetailDataModel(customizedJSON)
    //            return ResponseEnum.tripDetailData(detail)
    //            
    //        case .afterPayment:
    //            if json.status_code == 2{
    //                let intent = json.string("two_step_id")
    //                return .requires3DSecureValidation(forIntent: intent)
    //            }else{
    //                let detail = TripDetailDataModel(json)
    //                return ResponseEnum.tripDetailData(detail)
    //            }
    //        case .getPastTrips:
    //            let totalPages = json.int("total_pages")
    //            let currentPage = json.int("current_page")
    //            let data = json.array("data").compactMap({TripDataModel($0)})
    //            return ResponseEnum.pastTrip(data: data,
    //                                         totalPages: totalPages,
    //                                         currentPage: currentPage)
    //        case .getUpcomingTrips:
    //            
    //            let totalPages = json.int("total_pages")
    //            let currentPage = json.int("current_page")
    //            let data = json.array("data").compactMap({TripDataModel($0)})
    //            return ResponseEnum.upCommingTrip(data: data,
    //                                              totalPages: totalPages,
    //                                              currentPage: currentPage)
    //            
    //            
    //            
    //        case .giveRating:
    //            return ResponseEnum.RatingGiven
    //        case .cancel_reasons:
    //            let reasons = json.array("cancel_reasons").compactMap({CancelReason($0)})
    //            return ResponseEnum.cancelReason(reasons)
    //        case .force_update:
    //            let shouldForceUpdate = json.string("force_update")
    //            let should = ForceUpdate(rawValue: shouldForceUpdate) ?? .noUpdate
    //            let enableReferral = json.bool("enable_referral")
    //            Shared.instance.enableReferral(enableReferral)
    //            return ResponseEnum.forceUpdate(should)
    //        case .logout:
    //            self.self.doLogoutActions()
    //            return ResponseEnum.LoggedOut
    //            
    //            
    //        case .getCallerDetails:
    //            let name = json.string("first_name") + " " + json.string("last_name")
    //            let image = json.string("profile_image")
    //            
    //            return ResponseEnum.callerDetails(callerName: name,
    //                                              image: image)
    //            
    //        case .getNearByDrivers:
    //            let cars = json.array("data").compactMap({LiveCar($0)})
    //            return .liveCars(cars)
    //        default:
    //            return ResponseEnum.success
    //        }
    //    }
    func handleEssentials(_ model : CommonDataModel){
        //Google key
        _ = model.googleMapKey
        //        UserDefaults.set(googleKey, for: .google_api_key)
        let driverRadiusKM = model.driverKm
        Shared.instance.driverRadiusKM = driverRadiusKM
        
        // firebase Token Storeing
        
        let firebase_token = model.firebaseToken
        if !firebase_token.isEmpty{
            Constants().STOREVALUE(value: firebase_token, keyname: "firebase_token")
        }
        
        
        //Sinch key handling
        let sinchKey = model.sinchKey
        let sinchSecret = model.sinchSecretKey
        let requestSecond = model.requestSecond
        UserDefaults.set(requestSecond, for: .job_requesting_duration)
        if !sinchKey.isEmpty{
            UserDefaults.set(sinchKey, for: .sinch_key)
            UserDefaults.set(sinchSecret, for: .sinch_secret_key)
        }
        
        let paypalClient = model.paypalClient
        let paypalMode = model.paypalMode
        if !paypalClient.isEmpty{
            UserDefaults.set(paypalClient, for: .paypal_client_key)
            UserDefaults.set(paypalMode, for: .paypal_mode)
            //            PayPalHandler.initPaypalModule()
        }
        let stripe = model.stripePublishKey
        if !stripe.isEmpty{
            UserDefaults.set(stripe, for: .stripe_publish_key)
            StripeHandler.initStripeModule(key: stripe)
        }
        let last4 = model.last4
        let brand = model.brand
        if !last4.isEmpty,!brand.isEmpty{
            UserDefaults.set(last4, for: .card_last_4)
            UserDefaults.set(brand, for: .card_brand_name)
        }
        UserDefaults.set(model.adminContact, for: .admin_mobile_number)
        
        Shared.instance.isCovidEnabled = model.covidFuture
        Shared.instance.isWebPayment = model.isWebPayment
        
        //initializing sinch manager
        if !CallManager.instance.isInitialized,     //(Manger is not initialized)
           !sinchKey.isEmpty,                      //(Key is available to call)
           let accessToken : String = UserDefaults.value(for: .access_token),
           !accessToken.isEmpty,                   //User is Still logged in
           let userID : String = UserDefaults.value(for: .user_id) {
            do{
                try CallManager
                    .instance
                    .initialize(environment: CallManager.Environment.live,//Initialize call manger
                                for: userID)
            }catch let error{debug(print: error.localizedDescription)}
        }
    }
    func getAPI ( url : String , completionHandler : @escaping( _ result : [String : Any]? , _ error : Error?,_ status : Int? ) -> Void ) {
        print("API URL :\(url)")
        //        guard checkNetwork() else { return }        //check network
        //        showProgress()
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // hideProgress()
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    let status = (response as! HTTPURLResponse).statusCode
                    print("response status: \(status)")
                    print("URL :\(url) Response :\(String(describing: json))")
                    completionHandler( json , error , status)
                } catch {
                    completionHandler(nil, error , nil)
                }
            }
        }.resume()
        
    }
    func postAPI( url : String , post params : [String : Any] , completionHandler:@escaping (_ result : [String : Any]? , _ error : Error?,_ status : Int?) -> Void) {
        print("API Url :\(url) - Params:\(params)")
        var parameters = params
        _ = Date()
        parameters["token"] = preference.string(forKey: "access_token")
        parameters["user_type"] = "User"//Global_UserType
        parameters["device_id"] = strDeviceToken
        parameters["device_type"] = strDeviceType
        if parameters["language"] == nil,
           let language : String =  UserDefaults.value(for: .default_language_option){
            parameters["language"] = language
        }
        
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print("response :\(json)")
                    let status = (response as! HTTPURLResponse).statusCode
                    let _: HTTPURLResponse = response as! HTTPURLResponse
                    // Session will be saved only for login api.
                    completionHandler( json , error ,status)
                } catch {
                    completionHandler(nil, error,nil)
                }
            }
        }.resume()
    }
}
//MARK:- response handlers



