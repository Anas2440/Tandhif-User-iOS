//
//  SOSViewController.swift
//  MyRideCiti
//
//  Created by Trioangle Technologies on 03/04/18.
//  Copyright © 2018 Trioangle Technologies. All rights reserved.
//

import UIKit

class SOSViewController: UIViewController {

    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var alertIndicatingView: UIView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertLabel: ErrorLabel!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var descriptionLabel : SecondarySmallLabel!
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var btnBack: SecondaryBackButton!
    
    @IBOutlet weak var lblTitleSOS: UILabel!
    
    @IBOutlet weak var viewHeader: HeaderView!
    
    @IBOutlet weak var imgViewAlert: UIImageView!
    
    @IBOutlet weak var contentBGView: TopCurvedView!
    
    @IBOutlet weak var closeBtn: PrimaryTextTintButton!
    var appDelegate = AppDelegate()
    
    func ThemeChange() {
        self.view.backgroundColor = self.view.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.viewHeader.backgroundColor = self.view.isDarkStyle ? .DarkModeBackground : .white
        self.btnBack.customColorsUpdate()
        self.lblTitleSOS.textColor = self.view.isDarkStyle ? .white : .black
        self.alertIndicatingView.backgroundColor = self.view.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.alertIndicatingView.layer.cornerRadius = 15.0
        self.alertIndicatingView.clipsToBounds = true
        self.alertIndicatingView.elevate(4,shadowColor: self.view.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
        self.titleLbl.customColorsUpdate()
        self.descriptionLabel.customColorsUpdate()
        self.alertLabel.customColorsUpdate()
        self.closeBtn.customColorsUpdate()
        self.contentBGView.customColorsUpdate()
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.ThemeChange()
    }
    
    lazy var commonAlert :CommonAlert =  {
        let alert = CommonAlert()
        return alert
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertIndicatingView.clipsToBounds = true
        alertIndicatingView.layer.borderWidth = 1.0
        alertIndicatingView.layer.borderColor = UIColor.lightGray.cgColor
        let tapOnAlert = UITapGestureRecognizer(target: self, action: #selector(SOSViewController.alertSelected))
        alertIndicatingView.addGestureRecognizer(tapOnAlert)
        
        let url = Bundle.main.url(forResource: "loading", withExtension: "gif")
        DispatchQueue.main.async {
            self.loadingImageView.sd_setImage(with: url)
        }
        self.btnBack.addTap {
            self.dismiss(animated: true, completion: nil)
        }
        loadingImageView.isHidden = true

            self.descriptionLabel.text = appName
                + " \(LangCommon.locationCollectData)"
                + " \(LangCommon.locationEnsure)"
                + " \(LangCommon.appName)"
                + " \(LangHandy.locationSmooth)"
        self.ThemeChange()
    }
    
    @objc
    func alertSelected(_sender:UITapGestureRecognizer) {
        self.commonAlert.setupAlert(alert: LangCommon.continueSendAlert,
                                    okAction: LangCommon.common1Continue,
                                    cancelAction: LangCommon.cancel)
        self.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            self.alertImageView.image = UIImage(named:"warning (4)")
            self.alertLabel.text = LangCommon.sendingAlert
            self.alertLabel.textColor = UIColor.gray
            self.loadingImageView.isHidden = false
            self.wsToCallSOS()
        }
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func wsToCallSOS() {
        
        let paramDict = ["token" : Constants().GETVALUE(keyname: "access_token"),
                         "latitude" : Constants().GETVALUE(keyname: "user_latitude"),
                         "longitude" : Constants().GETVALUE(keyname: "user_longitude")] as [String : Any]
        
        WebServiceHandler.sharedInstance.getWebService(wsMethod:"sosalert", paramDict: paramDict, viewController:self, isToShowProgress:false, isToStopInteraction:true,complete:  { (response) in
            let responseJson = response
            DispatchQueue.main.async {
                if (responseJson["status_code"] as? String == "1") || (responseJson["status_code"] as? String == "2") {
                    self.alertLabel.text = LangCommon.alertSent
                    self.alertLabel.textColor = UIColor.black
                    self.loadingImageView.isHidden = true
                    self.alertImageView.image = UIImage(named:"check-symbol")
                }
                else {
                    self.appDelegate.createToastMessageForAlamofire(responseJson["status_message"] as? String ?? String(), bgColor: UIColor.black, textColor: UIColor.white, forView:self.view)
                }
                
            }
        }){(error) in
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    class func initWithStory() -> SOSViewController{
        return UIStoryboard.gojekCommon.instantiateViewController()
    }

}
