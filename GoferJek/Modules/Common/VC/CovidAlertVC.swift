//
//  CovidAlertVC.swift
//  Gofer
//
//  Created by trioangle on 21/04/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit
import GoogleMaps
class CovidAlertVC: BaseViewController {

    //--------------------------------------
    //MARK:- Outlets
    //--------------------------------------
    
    @IBOutlet var covidAlertView: CovidAlertView!
    
    //--------------------------------------
    //MARK:- Local Variables
    //--------------------------------------
    
    var delegate: CovidDelegate!
    var bookingType : BookingType!
    
    //--------------------------------------
    //MARK:- View Controller Cycle
    //--------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //--------------------------------------
    //MARK: - Init with story
    //--------------------------------------
    
    class func initWithStory(_ delegate: CovidDelegate,
                             bookingType: BookingType) -> CovidAlertVC {
        let covid : CovidAlertVC = UIStoryboard.gojekCommon.instantiateViewController()
        covid.delegate = delegate
        covid.bookingType = bookingType
        covid.modalPresentationStyle = .overCurrentContext
        return covid
    }
    
}

protocol CovidDelegate {
    func wsToBookNow()
    func wsToBookLater()
    func covidAlertCancelled()
}

enum BookingType {
    case bookNow
    case bookLater
}
