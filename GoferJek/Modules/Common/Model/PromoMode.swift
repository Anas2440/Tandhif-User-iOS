//
//  PromoMode.swift
//  Gofer
//
//  Created by Trioangle on 25/11/17.
//  Copyright © 2017 Trioangle Technologies. All rights reserved.
//

import UIKit

class PromoContainerModel : Codable{
    var promos : [PromoMode]
    var walletAmount : String
    enum CodingKeys : String, CodingKey{
        case promos = "promo_details"
        case walletAmount = "wallet_amount"
    }
    required init(from decoder : Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
        self.promos = try container.decodeIfPresent([PromoMode].self, forKey: .promos) ?? [PromoMode]()
        self.walletAmount = container.safeDecodeValue(forKey: .walletAmount)
        if !self.walletAmount.isEmpty{
            UserDefaults.set(self.walletAmount, for: .wallet_amount)
        }
//        if let first = self.promos.first,!first.amount.isEmpty{
//
//            UserDefaults.set(first.amount, for: .promo_applied_amount)
//            UserDefaults.set(first.code, for: .promo_applied_code)
//            UserDefaults.set(first.expire_date, for: .promo_expirey_date)
//        }else{
//            UserDefaults.removeValue(for: .promo_applied_amount)
//            UserDefaults.removeValue(for: .promo_applied_code)
//            UserDefaults.removeValue(for: .promo_expirey_date)
//        }
        Constants().STOREVALUE(value: self.promos.count.description, keyname: USER_PROMO_CODE)
    }
}

class PromoMode : Codable, Equatable{
    static func == (lhs: PromoMode, rhs: PromoMode) -> Bool {
        lhs.amount == rhs.amount &&
        lhs.code == rhs.code &&
        lhs.expire_date == rhs.expire_date 
    }
    
    
    var amount : String = ""
    var code : String = ""
    var expire_date : String = ""
    var id:Int = 0
    
    enum CodingKeys: String, CodingKey {
        case amount
        case code
        case expire_date
        case id
    }
    init() {}
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = container.safeDecodeValue(forKey: .amount)
        self.code = container.safeDecodeValue(forKey: .code)
        self.expire_date = container.safeDecodeValue(forKey: .expire_date)
        self.id = container.safeDecodeValue(forKey: .id)

    }

    //GET THE VALUE FOR JSON
    func initPromoData(responseDict: NSDictionary) -> Any
    {
        amount = responseDict["amount"] as? String ?? String()
        code = responseDict["code"] as? String ?? String()
        expire_date = responseDict["expire_date"] as? String ?? String()
        id = responseDict["id"] as? Int ?? Int()

        return self
    }
    init(_ json : JSON) {
        self.amount = json.string("amount")
        self.code = json.string("code")
        self.expire_date = json.string("expire_date")
        self.id = json.int("id")


    }

}

