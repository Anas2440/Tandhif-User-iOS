//
//  SupportVC.swift
//  Gofer
//
//  Created by trioangle on 16/11/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SupportVC: BaseViewController {

    @IBOutlet var supportView: SupportView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    class func initWithStory()-> SupportVC{
        let view : SupportVC = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.supportView.ThemeChange()
    }
}

