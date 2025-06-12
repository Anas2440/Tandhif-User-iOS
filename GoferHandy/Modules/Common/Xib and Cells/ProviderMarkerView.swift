//
//  ProviderMarkerView.swift
//  GoferHandy
//
//  Created by trioangle on 12/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class ProviderMarkerView: UIView {

    @IBOutlet weak var markerIV : PrimaryImageView!
    @IBOutlet weak var providerIV : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // Delivery Splitup Start
    static func getView(forProvider provider : Provider,using frame : CGRect) -> ProviderMarkerView{
        let nib = UINib(nibName: "ProviderMarkerView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! ProviderMarkerView
        view.frame = frame
        view.setImage(provider.profilePicture)
        return view
    }
    // Delivery Splitup Start
    static func getCarView(forProvider provider : Provider,using frame : CGRect) -> ProviderMarkerView{
        let nib = UINib(nibName: "ProviderMarkerView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[1] as! ProviderMarkerView
        view.frame = frame
        return view
    }
    // Delivery Splitup End
    static func getView(withUserImage image : String,using frame : CGRect) -> ProviderMarkerView{
          let nib = UINib(nibName: "ProviderMarkerView", bundle: nil)
          let view = nib.instantiate(withOwner: nil, options: nil)[0] as! ProviderMarkerView
          view.frame = frame
          view.setImage(image)
          return view
      }
    func setImage(_ strURL : String){
        self.providerIV.sd_setImage(with: URL(string: strURL), completed: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.markerIV.layer.cornerRadius = self.markerIV.bounds.width * 0.5
            self.markerIV.clipsToBounds = true
            self.markerIV.contentMode = .scaleAspectFill
            self.backgroundColor = .clear
            self.layoutIfNeeded()
        }
    }
}
