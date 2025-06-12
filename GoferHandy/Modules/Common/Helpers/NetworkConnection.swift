//
//  NetworkConnection.swift
//  Goferjek
//
//  Created by Trioangle on 28/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import Network
//import grpc
import SystemConfiguration
import CoreTelephony

enum NetWorkType {
    case wifi
    case _2g
    case _3g
    case _4g
    case undified
    case unknown
}


var isNetworkConnected : Bool = false

var typeOfNetwork : NetWorkType = .undified

class NetworkConnection : NSObject {
    
    static let shared = NetworkConnection()
    
    var isMonitoring = false
    
    private let monitor = NWPathMonitor()
    
    func startNetworkMoniter() {
        monitor.pathUpdateHandler = { pathUpdateHandler in
            isNetworkConnected = pathUpdateHandler.status == .satisfied
        }
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        self.monitor.start(queue: queue)
        self.isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        monitor.cancel()
        isMonitoring = false
    }
    
}




