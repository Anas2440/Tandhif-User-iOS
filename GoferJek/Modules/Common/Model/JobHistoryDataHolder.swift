//
//  JobHistoryListHolder.swift
//  GoferHandy
//
//  Created by trioangle on 22/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
class JobHistoryDataHolder: Codable , Equatable {
    
    // Adding This Model comparing the Details
    static func == (lhs: JobHistoryDataHolder, rhs: JobHistoryDataHolder) -> Bool {
        lhs.statusCode == rhs.statusCode &&
        lhs.statusMessage == rhs.statusMessage &&
        lhs.currentPage == rhs.currentPage &&
        lhs.totalPages == rhs.totalPages &&
        lhs.data == rhs.data
    }
    
    let statusCode, statusMessage: String
    var currentPage: Int
    let totalPages: Int
    var data: [HandyJobDetailModel]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case data
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
        self.totalPages = container.safeDecodeValue(forKey: .totalPages)
        self.data = try container.decodeIfPresent([HandyJobDetailModel].self,
                                                  forKey: .data) ?? []
    }

    func updateWithNewData(_ newData : JobHistoryDataHolder){
        self.currentPage = newData.currentPage
        self.data.append(contentsOf: newData.data)
    }
    
}
