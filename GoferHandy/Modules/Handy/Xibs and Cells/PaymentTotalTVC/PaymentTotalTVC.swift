//
//  PaymentTotalTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 28/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class PaymentTotalTVC: BaseTableViewCell {

    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var serviceItem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
