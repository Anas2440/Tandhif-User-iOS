//
//  ProfilePromoCodeViewController.swift
//  GoferEats
//
//  Created by trioangle on 15/11/18.
//  Copyright © 2018 Balajibabu. All rights reserved.
//

import UIKit

class PromoDetailTVC: UITableViewCell {
    
    @IBOutlet weak var outlineView: SecondaryView!
    @IBOutlet weak var offerDetailLabel: SecondaryHeaderLabel!
    @IBOutlet weak var offerDescriptionLabel: ThemeColoredHintLabel!
    @IBOutlet weak var imageAppliedPromoIcon: ThemeColorTintImageView!
    
    @IBOutlet var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    override func awakeFromNib() {
        self.updateDesign()
        
    }
    func updateDesign(){
        self.offerDetailLabel.customColorsUpdate()
        self.outlineView.customColorsUpdate()
        self.outlineView.elevate(2)
        self.offerDetailLabel.customColorsUpdate()
        self.offerDescriptionLabel.customColorsUpdate()
        self.imageAppliedPromoIcon.customColorsUpdate()
    }
    
    
    
}



class ProfilePromoCodeViewController: BaseViewController{
    
    @IBOutlet weak var profilePromoView:ProfilePromoView!
    
    var accountVM : AccountViewModel!
    var promoValueDictArray = [[String:Any]]()
    var delegate : PromoValuePassedProtocol!
    var isfromPlaceOrder = Bool()
    var isFromMenu = Bool()
    var isFromPayment = Bool()
    var payment_promo:Int?
    
    //MARK:- initWithStory
    class func initWithStory(_ delegate : PromoValuePassedProtocol) -> ProfilePromoCodeViewController {
        let VC : ProfilePromoCodeViewController = UIStoryboard.gojekCommon.instantiateViewController()
        VC.delegate = delegate
        VC.accountVM = AccountViewModel()
        return VC
    }
    
    
    func initNotification() {
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.removeObserver(self, name: Notification.Name("k_LogoutUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logOutUser), name: Notification.Name("k_LogoutUser"), object: nil)
        
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("k_WebUnderMaintenance"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(webUnderMaintenance), name: Notification.Name("k_WebUnderMaintenance"), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNotification()
        self.wsToGetPromo()
    }
    
    
    func wsToGetPromo() {
        self.accountVM.getPromoDetailsAPI(param: [:]) { (result) in
            switch result {
            case .success(let responseDict):
                print(responseDict)
                if let promoDetails = responseDict["promo_details"] as? [[String : Any]] {
                    self.promoValueDictArray.removeAll()
                    // Handy Splitup Start
                    if self.isFromPayment == true{
                        self.promoValueDictArray = promoDetails.filter({$0["business_id"] as! Int == AppWebConstants.businessType.rawValue})
                    }else{
                        // Handy Splitup End
                    self.promoValueDictArray = promoDetails
                        // Handy Splitup Start
                    }
                    // Handy Splitup End
                    self.profilePromoView.reloadfrom = true
                    self.profilePromoView.promoview.isHidden = false
                }
                self.profilePromoView.isLoading = false
                self.profilePromoView.reloadData()
            case .failure(let error):
                self.profilePromoView.isLoading = false
                print(error.localizedDescription)
//                appDelegate.createToastMessage(error.localizedDescription)
            }
        }
    }
    
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Shared.instance.isBackFromPayment = true
    }
    
    

    
    override func loadView() {
        super.loadView()

        
        
        
        
        
    }
    
    @objc func webUnderMaintenance(){
        print("WEB UNDER MAINTENANCEEEEEEEEEEEEEEEEEEEE::::::::::::::")
        
        let webMainVC = WebUnderMaintenanceVC.initWithStory()
        webMainVC.hidesBottomBarWhenPushed = true
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(webMainVC, animated: false)
    }
       
        
    @objc func logOutUser() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(false, forKey: "isLogin")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func addPromoCode(){
        // Handy Splitup Start
        let param : JSON = ["code" : self.profilePromoView.promoCodeTF.text!,
                            "business_id" : AppWebConstants.businessType.rawValue]
        // Handy Splitup End
        self.accountVM.addPromoCode(param: param, { result in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    self.profilePromoView.addPromoHandle(response)
                    self.profilePromoView.reloadData()
                }
                //else {
                    AppDelegate.shared.createToastMessage(response.status_message)
               // }
            case .failure(let error):
                print("\(error.localizedDescription)")

                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        })
    }
    
    
    func checkAvailablePromo(promoId:Int, index:Int,promoCode:String){
        let param : JSON = ["promo_id" : promoId]
        self.accountVM.checkPromoValidation(param: param, { result in
            switch result {
            case .success(let response):
                if response.isSuccess {
                    self.exitScreen(animated: true) {
                    self.delegate?.promoUpdate(promoId: promoId)
                    self.delegate.promoCodeName(code: promoCode)
                    self.profilePromoView.setSavedPromo(self.promoValueDictArray[index])
                    self.delegate?.reloadPromo()
                    }
                }else {
                    AppDelegate.shared.createToastMessage(response.status_message)
                    self.profilePromoView.reloadData()
                    self.delegate?.reloadPromo()
                }
                
            case .failure(let error):
                print("\(error.localizedDescription)")
                self.profilePromoView.reloadData()
                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        })
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Delegates
    
    
    
    
}





extension UITextField {
    func isChangeArabicTF() {
        let startPosition: UITextPosition = self.endOfDocument
        self.position(from: startPosition, offset: -1)
    }
//    let startPosition: UITextPosition = textField.beginningOfDocument
}
