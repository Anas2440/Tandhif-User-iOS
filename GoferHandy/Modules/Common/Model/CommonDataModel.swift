//
//  CommonDataModel.swift
//  Goferjek
//
//  Created by trioangle on 28/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let commonDataModel = try? newJSONDecoder().decode(CommonDataModel.self, from: jsonData)

import Foundation

// MARK: - CommonDataModel
class CommonDataModel: Codable {
    let statusCode, statusMessage, firebaseToken, sinchKey: String
    let sinchSecretKey: String
    let applyJobExtraFee: Bool
    let status, googleMapKey, paypalClient: String
    let paypalMode: Int
    let stripePublishKey, brand, last4, updateLOCInterval: String
    let requestSecond, adminContact: String
    let covidFuture, isWebPayment: Bool
    let heatMap: Int
    let driverKm : Int
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case firebaseToken = "firebase_token"
        case sinchKey = "sinch_key"
        case sinchSecretKey = "sinch_secret_key"
        case applyJobExtraFee = "apply_job_extra_fee"
        case status
        case googleMapKey = "google_map_key"
        case paypalClient = "paypal_client"
        case paypalMode = "paypal_mode"
        case stripePublishKey = "stripe_publish_key"
        case brand, last4
        case updateLOCInterval = "update_loc_interval"
        case requestSecond = "request_second"
        case adminContact = "admin_contact"
        case covidFuture = "covid_future"
        case isWebPayment = "is_web_payment"
        case heatMap = "heat_map"
        case driverKm = "driver_km"
    }
    required init(from decoder : Decoder) throws{
             let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.firebaseToken = container.safeDecodeValue(forKey: .firebaseToken)
        self.sinchKey = container.safeDecodeValue(forKey: .sinchKey)
        self.sinchSecretKey = container.safeDecodeValue(forKey: .sinchSecretKey)
        self.applyJobExtraFee = container.safeDecodeValue(forKey: .applyJobExtraFee)
        self.status = container.safeDecodeValue(forKey: .status)
        self.googleMapKey = container.safeDecodeValue(forKey: .googleMapKey)
        self.paypalClient = container.safeDecodeValue(forKey: .paypalClient)
        self.paypalMode = container.safeDecodeValue(forKey: .paypalMode)
        self.stripePublishKey = container.safeDecodeValue(forKey: .stripePublishKey)
        self.brand = container.safeDecodeValue(forKey: .brand)
        self.last4 = container.safeDecodeValue(forKey: .last4)
        self.updateLOCInterval = container.safeDecodeValue(forKey: .updateLOCInterval)
        self.requestSecond = container.safeDecodeValue(forKey: .requestSecond)
        self.adminContact = container.safeDecodeValue(forKey: .adminContact)
        self.covidFuture = container.safeDecodeValue(forKey: .covidFuture)
        self.isWebPayment = container.safeDecodeValue(forKey: .isWebPayment)
        self.heatMap = container.safeDecodeValue(forKey: .heatMap)
        self.driverKm = container.safeDecodeValue(forKey: .driverKm)
    }
    init () {
        self.statusCode = ""
        self.statusMessage = ""
        self.firebaseToken = ""
        self.sinchKey = ""
        self.sinchSecretKey = ""
        self.applyJobExtraFee = false
        self.status = ""
        self.googleMapKey = ""
        self.paypalClient = ""
        self.paypalMode = 0
        self.stripePublishKey = ""
        self.brand = ""
        self.last4 = ""
        self.updateLOCInterval = ""
        self.requestSecond = ""
        self.adminContact = ""
        self.covidFuture = false
        self.isWebPayment = false
        self.heatMap = 0
        self.driverKm = 0 
    }
}

