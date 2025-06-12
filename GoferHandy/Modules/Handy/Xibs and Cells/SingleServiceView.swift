//
//  SingleServiceView.swift
//  Goferjek
//
//  Created by Trioangle on 06/01/22.
//  Copyright © 2022 Vignesh Palanivel. All rights reserved.
//

import UIKit
import StripeUICore

class SingleServiceView: UIView {
    
    enum ImageType {
        case web
        case local
    }

    @IBOutlet weak var serviceIV: UIImageView!
    @IBOutlet weak var serviceNameLbl: SecondaryHeaderLabel!
    @IBOutlet weak var startNowBtn: PrimaryButton!
    @IBOutlet weak var serviceDescriptionLbl: commonTextView!
    
    var service: Service!
    var imageType : ImageType!
    var delegate : SingleServiceDelegate!
   
    override
    func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupDetails() {
        self.startNowBtn.setTitle(LangHandy.getServiceNow, for: .normal)
        self.serviceNameLbl.text = self.service.serviceName
        self.serviceDescriptionLbl.text = self.service.serviceDescription
        self.serviceNameLbl.setTextAlignment(aligned: .center)
        self.serviceDescriptionLbl.setTextAlignment(aligned: .center)
        switch self.imageType {
        case .web:
            if let url = URL(string: service.imageIcon) {
                self.serviceIV.sd_setImage(with: url) { image, error, _, _ in
                    self.serviceIV.image = image
                }
            }
        case .local:
            self.serviceIV.image = UIImage(named: service.imageIcon)
        case .none:
            debug(print: "Not Handled Image Type")
        }
    }
    
    func darkThemeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.serviceNameLbl.customColorsUpdate()
        self.startNowBtn.customColorsUpdate()
        DispatchQueue.main.async {
            self.startNowBtn.cornerRadius = 10
        }
        self.serviceDescriptionLbl.customColorsUpdate()
        self.serviceDescriptionLbl.font = AppTheme.Fontmedium(size: 16).font
        self.serviceDescriptionLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .TertiaryColor
    }
    
    class func initWithNib(_ delegate: SingleServiceDelegate,
                           service : Service,
                           imageType : ImageType = .web) -> SingleServiceView {
        let nib = UINib(nibName: "SingleServiceView",
                        bundle: nil)
        let view = nib.instantiate(withOwner: nil,
                               options: nil)[0] as! SingleServiceView
        view.delegate = delegate
        view.service = service
        view.imageType = imageType
        view.setupDetails()
        return view
    }
    
    @IBAction
    func startNowBtnClicked(_ sender: Any) {
        self.delegate.startBtnCliked(service: self.service)
    }
    
}

protocol SingleServiceDelegate {
    func startBtnCliked(service: Service)
}
