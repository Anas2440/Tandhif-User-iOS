//
//  DeletePHIAlertview.swift
//  Intuitive
//
//  Created by mac004 on 02/12/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class DeletePHIAlertview: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
     */
    @IBOutlet weak var messageDescriptionLbl: UILabel!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var message_titleLb: UILabel!
    @IBOutlet weak var PHI_DeleteYesBtn: PrimaryButton!
    @IBOutlet weak var PHI_DeleteNoBtn: SecondaryButton!
    @IBOutlet weak var deletePHI_popupTwoOption: UIView!
    @IBOutlet weak var deletePHI_popupOneOption: UIView!
    @IBOutlet weak var PHI_FinalMessage_OK: PrimaryButton!
    @IBOutlet weak var imageWidhtConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.PHI_DeleteNoBtn.cornerRadius = 10
        self.PHI_DeleteNoBtn.elevate(2)
        self.PHI_DeleteYesBtn.cornerRadius = 10
        self.PHI_FinalMessage_OK.cornerRadius = 10
    }
}


//protocol CommonAlertProtocol {
//    func commonOkAlertAction()
//    func commonFailureAlertAction()
//    func commonSuccessAlertAction()
//
//}
//
//
//typealias MethodHandler2 = ()->Void
class CommonAlert:NSObject {
   
    
   
    override init() {
        super.init()
    }
    
    fileprivate func addAlert()->DeletePHIAlertview {
     
        let commonAlertView: DeletePHIAlertview = Bundle.main.loadNibNamed("DeletePHIAlertview", owner: nil, options: nil)?.first as! DeletePHIAlertview
       
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if let oldAlertView = window?.viewWithTag(963258741) {
            oldAlertView.removeFromSuperview()
        }
        commonAlertView.tag = 963258741
       
        commonAlertView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        window?.addSubview(commonAlertView)
        window?.bringSubviewToFront(commonAlertView)
        return commonAlertView
    }
    
    
    public func removeAlert() {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if let commonAlertView = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            window?.subviews[commonAlertView].removeFromSuperview()
//            commonAlertView.removeFromSuperview()
        }
    }
    
    
    

    
    func setupAlert(alert title:String,alertDescription message:String? = nil,okAction:String,cancelAction:String? = nil, userImage:String? = nil)
    {
    
        let alertView = self.addAlert()
        self.ThemeChange()
        alertView.message_titleLb.font = AlertTheme.Title.font
        alertView.messageDescriptionLbl.font = AlertTheme.Message.font
        alertView.userImageView.tintColor = AlertTheme.StatusImage.color
        alertView.message_titleLb.text = title
        
        if let description = message {
            alertView.messageDescriptionLbl.text = description
        }else {
            alertView.messageDescriptionLbl.text = ""
        }
        
        // MARK: cancelAction title will be change to alert box UI

        if cancelAction != nil {
            //        MARK: set for single Button UI
            alertView.deletePHI_popupOneOption.isHidden = true
            alertView.deletePHI_popupTwoOption.isHidden = false
            alertView.PHI_DeleteYesBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            alertView.PHI_DeleteYesBtn.customColorsUpdate()
            alertView.PHI_DeleteYesBtn.cornerRadius = 10
            alertView.PHI_DeleteNoBtn.setTitle(cancelAction, for: .normal)
            alertView.PHI_DeleteNoBtn.customColorsUpdate()
            alertView.PHI_DeleteNoBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            alertView.PHI_DeleteYesBtn.setTitle(okAction, for: .normal)
//            alertView.PHI_DeleteNoBtn.addTarget(self, action: #selector(self.failureBtnPressed(_:)), for: .touchUpInside)
//            alertView.PHI_DeleteYesBtn.addTarget(self, action: #selector(self.successBtnPressed(_:)), for: .touchUpInside)
            alertView.PHI_DeleteNoBtn.addTap {
                self.removeAlert()
            }
            alertView.PHI_DeleteYesBtn.addTap {
                self.removeAlert()
            }
        }
        else {
            //        MARK: set for dual Button UI
            alertView.deletePHI_popupOneOption.isHidden = false
            alertView.deletePHI_popupTwoOption.isHidden = true
            alertView.PHI_FinalMessage_OK.setTitleColor(AlertTheme.ButtonTitle.color, for: .normal)
            alertView.PHI_FinalMessage_OK.customColorsUpdate()
            alertView.PHI_FinalMessage_OK.cornerRadius = 10
            alertView.PHI_FinalMessage_OK.setTitle(okAction, for: .normal)
            alertView.PHI_FinalMessage_OK.addTap {
                self.removeAlert()
            }
//            alertView.PHI_FinalMessage_OK.addTarget(self, action: #selector(self.okBtnPressed(_:)), for: .touchUpInside)
            
        }
       
        
        
        
        //        MARK: userimage is optional for alert
        if let url = userImage  {
            if url == "no_resturant" {
                alertView.userImageView.image = UIImage(named: url)
                alertView.imageWidhtConstraint.constant = 200
                alertView.contentMode = .scaleToFill
                alertView.cornerRadius = 10
                alertView.clipsToBounds = true
            } else {
                alertView.userImageView.image = UIImage(named: url)
                alertView.imageWidhtConstraint.constant = 60
            }
        }else {
            alertView.imageWidhtConstraint.constant = 0
        }
        alertView.centerView = self.getViewExactHeight(view: alertView.centerView)
        
    }
    
    func ThemeChange() {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if #available(iOS 12.0, *) {
            
            if let alertView : DeletePHIAlertview  = window?.subviews.filter({$0 is DeletePHIAlertview}).last as? DeletePHIAlertview {
//            window?.subviews[alertView]
            let isdarkStyle = alertView.traitCollection.userInterfaceStyle == .dark
            alertView.centerView.backgroundColor = isdarkStyle ?  .DarkModeBackground : AlertTheme.Background.color
            alertView.message_titleLb.textColor = isdarkStyle ?  .DarkModeTextColor : AlertTheme.Title.color
            alertView.messageDescriptionLbl.textColor = isdarkStyle ?  .DarkModeTextColor : AlertTheme.Message.color
            alertView.deletePHI_popupTwoOption.backgroundColor = isdarkStyle ?  .DarkModeBackground : AlertTheme.Background.color
            alertView.deletePHI_popupOneOption.backgroundColor = isdarkStyle ?  .DarkModeBackground : AlertTheme.Background.color
                alertView.PHI_DeleteNoBtn.customColorsUpdate()
//            commonAlertView.removeFromSuperview()
        }
       
           
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: actions for ok buttons first setupAlert
     
    func addAdditionalOkAction(isForSingleOption:Bool, customAction:@escaping()->Void) {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if let index = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            
            if let commonAlertView = window?.subviews[index] as? DeletePHIAlertview {
                        if isForSingleOption {
                            commonAlertView.PHI_FinalMessage_OK.addTap {
                                self.removeAlert()
                                customAction()
                            }
                        }else {
                            commonAlertView.PHI_DeleteYesBtn.addTap {
                                self.removeAlert()
                                customAction()
                            }
                        }
                    }
        }
        
    }
    
    func addAdditionalCancelAction( customAction:@escaping()->Void) {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if let index = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            
            if let commonAlertView = window?.subviews[index] as? DeletePHIAlertview {
                commonAlertView.PHI_DeleteNoBtn.addTap {
                                   self.removeAlert()
                                   customAction()
                               }
                    }
        }
        
    }
    
//    @objc fileprivate func okBtnPressed(_ sender:UIButton) {
//
//        self.delegate.commonOkAlertAction()
//        self.removeAlert()
//    }
//
//    @objc fileprivate func successBtnPressed(_ sender:UIButton) {
//
//        self.delegate.commonSuccessAlertAction()
//        self.removeAlert()
//    }
//
//    @objc fileprivate func failureBtnPressed(_ sender:UIButton) {
//        self.delegate.commonFailureAlertAction()
//        self.removeAlert()
//    }
    
    fileprivate func getViewExactHeight(view:UIView)->UIView {
       
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = view.frame
        if height != frame.size.height {
            frame.size.height = height
            view.frame = frame
        }
        return view
    }
    
    
    
}






