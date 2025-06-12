//
//  PendingTripTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class PendingTripTVC: BaseTableViewCell {

    @IBOutlet weak var jobId: UILabel!
    @IBOutlet weak var jobDateTime: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var jobLocationText: UILabel!
    @IBOutlet weak var jobLocation: UILabel!
    @IBOutlet weak var pickupImg: UIImageView!
    
    @IBOutlet weak var dropImg: UIImageView!
    @IBOutlet weak var dropLocationText: UILabel!
    @IBOutlet weak var acceptedJobBtn: UIButton!
    @IBOutlet weak var requestedServicesBtn: UIButton!
    @IBOutlet weak var declinedServicesBtn: UIButton!
    @IBOutlet weak var dropLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func getNib() -> UINib{
        return UINib(nibName: "PendingTripTVC", bundle: nil)
    }
}

