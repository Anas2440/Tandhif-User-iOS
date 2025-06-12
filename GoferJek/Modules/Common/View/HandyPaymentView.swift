//
//  HandyPaymentView.swift
//  GoferHandy
//
//  Created by trioangle on 01/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire
import IQKeyboardManagerSwift

class HandyPaymentView: BaseView,UITableViewDelegate,UITableViewDataSource{
    
    enum InvoiceSections{
        case address
        case invoice1
        case rating
        case beginImages
        case endImages
        case addTips
        case distanceView
        case promoView
    }
    
    //MARK:- variables
    var ref: DatabaseReference?
    var viewController: HandyPaymentVC!
    var isPaidShown : Bool = false
    var invoiceSections = [InvoiceSections]()
    var userRating:Int = 0
    var userRatingFeedBack = String()
    var isFareDetailsShow : Bool = false
    var givenTipsAmount:Double?
    
    @IBOutlet weak var totalFareStack: UIStackView!
    @IBOutlet weak var lineStack: UIStackView!
    @IBOutlet weak var paymentTypeStack: UIStackView!
    @IBOutlet weak var priceTypeStack: UIStackView!
    @IBOutlet weak var noOfSeetsStack: UIStackView!
    //MARK:- Outlets
    @IBOutlet weak var makePaymentBtn: PrimaryButton!
    @IBOutlet weak var paymentTableOuterview: TopCurvedView!
    @IBOutlet weak var paymentTable: CommonTableView!
    @IBOutlet weak var paymentDetailsTitle: SecondaryHeaderLabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var navView: HeaderView!
    
    @IBOutlet weak var paymentOptionHolderView : UIView!
    
    @IBOutlet weak var noOfSeatsvalueLbl: SecondaryRegularLabel!
    @IBOutlet weak var numberOfseatsLbl: SecondaryRegularLabel!
    @IBOutlet weak var headerView: SecondaryView!
    @IBOutlet weak var jobReqDateLbl: SecondaryRegularLabel!
    @IBOutlet weak var topNewHeaderView: SecondaryView!
    @IBOutlet weak var totalFareLbl: SecondaryRegularLabel!
    @IBOutlet weak var totalFareValueLbl: PrimaryLargeLabel!
    @IBOutlet weak var priceTypeLbl : SecondaryRegularLabel!
    @IBOutlet weak var paymentTypeLbl : SecondaryRegularLabel!
    @IBOutlet weak var feedbackview: SecondaryView!
    @IBOutlet weak var priceValueLbl : SecondarySmallBoldLabel!
    @IBOutlet weak var paymentValueLbl : SecondarySmallBoldLabel!
    @IBOutlet weak var jobReqDateValueLbl: SecondarySmallBoldLabel!
    @IBOutlet weak var pickupLocLbl: InactiveRegularLabel!
    @IBOutlet weak var viewResBtn : SecondaryButton!
    @IBOutlet weak var dropLocationStack : UIStackView!
    @IBOutlet weak var dropLocationView : SecondaryView!
    @IBOutlet weak var ratingViewHeaderView : UIStackView!
    @IBOutlet weak var ratingViewOuterView : SecondaryView!
    @IBOutlet weak var ratingViewBodyView : UIStackView!
    
    @IBOutlet weak var promoStack: UIStackView!
    @IBOutlet weak var dropImg: UIImageView!
    @IBOutlet weak var pickupImg: UIImageView!
    @IBOutlet weak var dropLocValueLbl: SecondarySmallBoldLabel!
    @IBOutlet weak var dropLocLbl: InactiveRegularLabel!
    @IBOutlet weak var pickupLocValueLbl: SecondarySmallBoldLabel!
    
    
    @IBOutlet weak var thanksView : UIView!
    @IBOutlet weak var thanksDescLbl :SecondaryRegularLabel!
    @IBOutlet weak var serviceNumberLbl : UILabel!
    
    @IBOutlet weak var ratingView:  SecondaryView!
    @IBOutlet weak var userRatingLAbel : UILabel!
    @IBOutlet weak var providerNameLbl :SecondaryRegularLabel!
    @IBOutlet weak var howWasJobLbl : SecondarySmallBoldLabel!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var inputRatingView : StarRatingView!
    @IBOutlet weak var submitRatingHolderView : UIView!
    
    
    @IBOutlet weak var submitRatingBtn : PrimaryButton!
    @IBOutlet weak var feedBackTitleLbl : SecondaryRegularLabel!
    @IBOutlet weak var feedBackTextView : commonTextView!
    
    @IBOutlet weak var bottomPaymentView: TopCurvedView!
    @IBOutlet weak var thanksLblStackView : UIStackView!
    
    
    @IBOutlet weak var paybuttonConst: NSLayoutConstraint!
    @IBOutlet weak var pickupStack : UIStackView!
    @IBOutlet weak var locView : UIStackView!
    
    
    
    @IBOutlet weak var PaymentBGView: SecondaryView!
    
    //Promo Label
    @IBOutlet weak var promoTitleLAbel:SecondaryRegularBoldLabel!
    @IBOutlet weak var addPromoLabel:SecondaryRegularBoldLabel!
    @IBOutlet weak var addButton:PrimaryButton!
    @IBOutlet weak var promoImageView:ThemeColorTintImageView!
    
    @IBOutlet var tripDistView: SecondaryView!
    @IBOutlet var tripHeaderView: CategoryView!
    @IBOutlet weak var durationLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var durationValueLbl: PrimaryColoredHeaderLabel!
    @IBOutlet weak var distanceLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var distanceValueLbl: PrimaryColoredHeaderLabel!
    
    
    @IBOutlet weak var vehicleTypeStack: UIStackView!
    @IBOutlet weak var vehicleLbl: SecondaryRegularLabel!
    @IBOutlet weak var vehicleValue: SecondarySmallBoldLabel!
    
    @IBOutlet var promoView: SecondaryView!
    @IBOutlet var promoSubView: CategoryView!
    @IBOutlet weak var promotitleLbl:SecondaryDescLabel!
    @IBOutlet weak var promoAddBtn:primaryBgButton!
    @IBOutlet weak var promoRemoveBtn:errorBgButton!
    @IBOutlet weak var removeBtnView:UIView!


    
    
    
    override func darkModeChange() {
        super.darkModeChange()
        // Delivery Splitup Start
        self.setTipsView.ThemeUpdate()
        // Delivery Splitup End
        self.viewResBtn.customColorsUpdate()
        self.viewResBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.feedbackview.customColorsUpdate()
        self.bottomPaymentView.customColorsUpdate()
        self.priceValueLbl.customColorsUpdate()
        self.paymentValueLbl.customColorsUpdate()
        self.topNewHeaderView.customColorsUpdate()
        self.PaymentBGView.customColorsUpdate()
//        self.submitRatingBtn.customColorsUpdate()
        self.feedBackTitleLbl.customColorsUpdate()
        self.feedBackTextView.customColorsUpdate()
        if self.feedBackTextView.text == LangCommon.provideYourFeedback.capitalized {
            self.feedBackTextView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
        self.providerImageView.isCurvedCorner = true
        self.howWasJobLbl.customColorsUpdate()
        self.providerNameLbl.customColorsUpdate()
        self.ratingView.customColorsUpdate()
        self.paymentTable.customColorsUpdate()
//        self.makePaymentBtn.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.jobReqDateLbl.customColorsUpdate()
        self.totalFareLbl.customColorsUpdate()
        self.totalFareValueLbl.customColorsUpdate()
        self.jobReqDateValueLbl.customColorsUpdate()
        self.pickupLocLbl.customColorsUpdate()
        self.pickupLocValueLbl.customColorsUpdate()
        self.dropLocLbl.customColorsUpdate()
        self.dropLocValueLbl.customColorsUpdate()
        self.paymentTypeLbl.customColorsUpdate()
        self.priceTypeLbl.customColorsUpdate()
        self.priceValueLbl.customColorsUpdate()
        self.paymentValueLbl.customColorsUpdate()
        self.changePaymentView.ThemeChange()
        self.paymentDetailsTitle.customColorsUpdate()
        self.navView.customColorsUpdate()
        self.paymentTableOuterview.customColorsUpdate()
        self.thanksDescLbl.customColorsUpdate()
        self.numberOfseatsLbl.customColorsUpdate()
        self.noOfSeatsvalueLbl.customColorsUpdate()
        //AppUtilities().cornerRadiusWithShadow(view: self.ratingViewOuterView)
        //AppUtilities().cornerRadiusWithShadow(view: self.paymentTableOuterview)
        self.ratingViewOuterView.customColorsUpdate()
        if let text = self.userRatingLAbel.attributedText {
            let attText = NSMutableAttributedString(attributedString: text)
            attText.setColorForText(textToFind: attText.string, withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            attText.setColorForText(textToFind: "★", withColor: .ThemeYellow)
            self.userRatingLAbel.attributedText = attText
        }
        self.paymentTable.reloadData()
        self.promoImageView.customColorsUpdate()
        self.promoTitleLAbel.customColorsUpdate()
        self.addButton.customColorsUpdate()
        self.addPromoLabel.customColorsUpdate()
        
        self.tripDistView.customColorsUpdate()
        self.tripHeaderView.customColorsUpdate()
        self.durationLbl.customColorsUpdate()
        self.durationValueLbl.customColorsUpdate()
        self.distanceLbl.customColorsUpdate()
        self.distanceValueLbl.customColorsUpdate()
        self.promotitleLbl.customColorsUpdate()
        self.promoAddBtn.customColorsUpdate()
        self.promoRemoveBtn.customColorsUpdate()
        self.promoView.customColorsUpdate()
        self.promoSubView.customColorsUpdate()
        self.vehicleLbl.customColorsUpdate()
        self.vehicleValue.customColorsUpdate()

        
    }
//    func initPromo(){
//        self.promoImageView.image = UIImage(named: "ic_promo_offer")
//        self.promoTitleLAbel.text = LangCommon.promotions
//        if let promoId:Int = UserDefaults.value(for: .promo_id),
//           promoId != 0{
//            self.addButton.setTitle(LangCommon.change, for: .normal)
//            self.addPromoLabel.text =  "Change promo code".localize
//        }else{
//            self.addButton.setTitle(LangCommon.add, for: .normal)
//            self.addPromoLabel.text = LangDeliveryAll.addPromoCode.capitalized
//        }
//    }
 
    //MARK:- Actions
    
    @IBAction
    func changeAction(_ sender : UIButton){
        self.viewController
            .navigateToChangePayment()
    }
    @IBAction
    func makePaymentAction(_ sender : UIButton){
        self.viewController.handlePayment()
    }
    @IBAction
    func submitRatingAction(_ sender : UIButton){
        self.feedbackview.isHidden = self.userRating != 0  ? true : false
//        self.feedBackTitleLbl.isHidden = self.userRating != 0 ? true : false
        if self.userRating != 0 {
            self.viewController.handleRating(userFeedback: self.feedBackTextView.text == LangCommon.provideYourFeedback.capitalized ? "" : self.feedBackTextView.text,
                                             userRating: self.userRating)
        } else {
            AppUtilities().customCommonAlertView(titleString: LangCommon.message, messageString: LangCommon.pleaseGiveRating)
        }
        
    }
    
    //MARK:- Variables
    // Delivery Splitup Start
    lazy var setTipsView : SetTipsView = {
        let mnView = SetTipsView.CreateView(self.bounds)
        mnView.enterTipsTF.text = nil
        mnView.currencySymbolLbl.text = UserDefaults.value(for: .user_currency_symbol_org)
        mnView.setTipBtn.setTitle(LangCommon.setTip.capitalized, for: .normal)
        //            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        //            mnView.countryHolderView.addGestureRecognizer(gesture)
        
        
        //        mnView.countryHolderView.addAction(for: .tap, Action: {
        //            self.pushToCountryVC()
        //        })
        return mnView
    }()
    // Delivery Splitup End
    
    var isAlreadyFirstResponder = Bool()
    
    var changePaymentView = ChangePaymentMethod.initViewFromXib()
    //MARK:- life cycles
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? HandyPaymentVC
        //        AppUtilities().cornerRadiusWithShadow(view: self.paymentView)
        //        AppUtilities().cornerRadiusWithShadow(view: self.locationView)
        self.locView.backgroundColor = UIColor.clear
        self.ratingViewHeaderView.isClippedCorner = true
        self.ratingViewHeaderView.layer.cornerRadius = 10
        self.locView.layer.cornerRadius = 10
        self.topNewHeaderView.layer.cornerRadius = 20
        self.topNewHeaderView.elevate(2.5)
        self.ratingViewHeaderView.backgroundColor = UIColor.clear
        self.paymentTable.delegate = self
        self.paymentTable.dataSource = self
        paymentTable.registerNib(forCell: PaymentTVC.self)
        //        paymentTable.registerNib(forCell: AddTipsTVC.self)
        // Delivery Splitup Start
        self.addSubview(self.setTipsView)
        self.setTipsView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.setTipsView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.frame.width,
                                        height: self.frame.height)
        self.setTipsView.enterTipsTF.text = ""
        self.setTipsView.transform = CGAffineTransform(translationX: 0,
                                                       y: self.frame.height)
        self.layoutIfNeeded()
        self.setTipsView.tipsHolderView.elevate(2)
        self.setTipsView.layoutIfNeeded()
        // Delivery Splitup End
        
        
        
        
        self.initView()
        self.initLanguage()
        self.initGestures()
        self.initPromoView()
        self.backBtn?.addTarget(self, action: #selector(self.onBackTapped(_:)), for: .touchUpInside)
        
        /* 666
         NotificationCenter.default.addObserver(self, selector: #selector(self.getPaymentSuccess), name: NSNotification.Name.PaymentSuccess_job, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.gotoHomePage), name: NSNotification.Name.PaymentSuccessInHomeAlert_job, object: nil)
         */
        
        UberSupport().removeProgressInWindow()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboardObserver(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboardObserver), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.darkModeChange()
        
    }
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
        
        IQKeyboardManager.shared.enable = true
    }
    override func didDisappear(baseVC: BaseViewController) {
        super.didDisappear(baseVC: baseVC)
        IQKeyboardManager.shared.enable = false
        
    }
    
    @objc func showKeyboardObserver(_ notification:Notification){
        guard self.viewController.presentedViewController == nil else{return}
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            
            // Delivery Splitup Start
            if self.setTipsView.enterTipsTF.canBecomeFirstResponder {
                
                if UIDevice.getIphoneXAbove() {
                    self.setTipsView.transform = CGAffineTransform(translationX: 0, y: -(keyboardFrame.height - 35) )
                }else {
                    self.setTipsView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
                }
                
            } else // Delivery Splitup End
            if self.feedBackTextView.isFirstResponder {
                if UIDevice.getIphoneXAbove() {
                    self.ratingView.transform = CGAffineTransform(translationX: 0, y: -(keyboardFrame.height - 35) )
                }else {
                    self.ratingView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
                }
            }
        }
    }
    
    @objc func hideKeyboardObserver(){
        
        guard self.viewController.presentedViewController == nil else{return}
        if self.feedBackTextView.resignFirstResponder() {
            self.ratingView.transform = .identity
        }else {
            
        }
    }
    
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.viewController.navigationController?.isNavigationBarHidden = true
        //        self.initPaymentView(with: nil)
        
        
    }
    //MARK:- Initializers
    deinit {
        self.ref?.removeAllObservers()
    }
    func deleteRating(model: HandyJobDetailModel){

        if model.providerName == "Deleted Provider" && model.users.jobStatus.rawValue == "Rating"{
              self.howWasJobLbl.isHidden = true

             self.inputRatingView.isHidden = true
              self.feedBackTextView.isHidden = true
              self.submitRatingBtn.isHidden = true
          }
        else if model.providerName == "Deleted Provider" && model.users.jobStatus.rawValue == "Completed"{

//            self.feedBackTextView.isHidden = true
//            self.submitRatingBtn.isHidden = true
          }

          else{
              self.howWasJobLbl.isHidden = false

             self.inputRatingView.isHidden = false
              self.feedBackTextView.isHidden = false
              self.submitRatingBtn.isHidden = false
          }
      }
    func initView(){
        self.viewResBtn.cornerRadius = 5
        self.viewResBtn.elevate(2)
        //        self.paymentTable.tableHeaderView = headerView
        self.dropImg.image = UIImage(named: "location_pin")?.withRenderingMode(.alwaysTemplate)
        self.dropImg.tintColor = .green
        self.pickupImg.image = UIImage(named: "location_pin")?.withRenderingMode(.alwaysTemplate)
        self.pickupImg.tintColor = .red
        self.totalFareLbl.text = LangCommon.totalFare
        self.jobReqDateLbl.text = LangCommon.jobRequestDate
        // Delivery Splitup Start
        self.paymentTable.registerNib(forCell: JobImageTVC.self)
        // Delivery Splitup End
        self.bottomPaymentView.isHidden = true
        self.serviceNumberLbl.setTextAlignment()
        self.jobReqDateValueLbl.setTextAlignment()
        self.dropLocLbl.setTextAlignment()
        self.pickupLocLbl.setTextAlignment()
        self.pickupLocValueLbl.setTextAlignment()
        self.jobReqDateLbl.setTextAlignment()
        self.dropLocValueLbl.setTextAlignment()
        self.thanksDescLbl.setTextAlignment()
        self.paymentDetailsTitle.setTextAlignment()
        self.totalFareValueLbl.setTextAlignment(aligned: .right)
        self.paymentValueLbl.setTextAlignment(aligned: .right)
        self.priceValueLbl.setTextAlignment(aligned: .right)
        self.howWasJobLbl.setTextAlignment()
        self.feedBackTextView.setTextAlignment()
        self.feedBackTitleLbl.setTextAlignment()
        self.noOfSeatsvalueLbl.setTextAlignment(aligned: .right)
        

        
        self.paymentTable.register(UINib(nibName: "AddTipTableViewCell", bundle: nil), forCellReuseIdentifier: "AddTipTableViewCell")
    }
    
    func checkPromo(job: HandyJobDetailModel?) {
        //self.promoStack.isHidden = job?.isCompletedJob ?? false
        self.promoStack.isHidden = true
    }
    
    func updateChangePayementViewFrame() {
        self.changePaymentView.frame = self.changePaymentView.setFrame(self.paymentOptionHolderView.frame)
        self.paymentOptionHolderView.addSubview(self.changePaymentView)
        self.paymentOptionHolderView.bringSubviewToFront(self.changePaymentView)
        self.layoutIfNeeded()
    }
    
    func initLanguage(){
        self.totalFareValueLbl.text = ""
        self.paymentDetailsTitle.text = LangHandy.jobDetails.capitalized
        self.howWasJobLbl.text = LangCommon.howWasTheJobDone
        self.feedBackTitleLbl.text = LangCommon.provideYourFeedback
        self.viewResBtn.setTitle("".capitalized, for: .normal)
        self.feedBackTextView.text = LangCommon.provideYourFeedback.capitalized
        self.numberOfseatsLbl.text = ""
        self.inputRatingView.delegate = self
        self.inputRatingView.setButtonTitle(rating: .none)
        self.feedBackTextView.delegate = self
        // Delivery Splitup Start
        self.setTipsView.enterTipsTF.delegate = self
        self.setTipsView.enterTipsTF.addTarget(self, action: #selector(self.textFieldDidChangeValue(_:)), for: .editingChanged)
        self.setTipsView.closeTipViewBtn.addTarget(self, action: #selector(self.cancelTipAction(_:)), for: .touchUpInside)
        self.setTipsView.setTipBtn.addTarget(self, action: #selector(self.setTipAmount(_:)), for: .touchUpInside)
        self.setTipsView.enterTipsTF.placeholder = LangCommon.enterTipAmount.capitalized
        // Delivery Splitup End

        self.distanceLbl.text = LangCommon.distance
        self.durationLbl.text = LangCommon.duration
        //self.promotitleLbl.text = LangCommon.promotions
        self.promoAddBtn.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.promoRemoveBtn.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.promoAddBtn.cornerRadius = 10
        self.promoRemoveBtn.cornerRadius = 10

        self.promoAddBtn.elevate(4)
        self.promoRemoveBtn.elevate(4)
//        self.promoAddBtn.setTitle(LangCommon.add.capitalized, for: .normal)
//        self.promoRemoveBtn.setTitle(LangCommon.remove.capitalized, for: .normal)
        
    }
    
    func initPromoView()
    {
//        if let promoId:Int = UserDefaults.value(for: .promo_id),
//           promoId != 0 {
        if self.viewController.promoID != 0{
            self.promoAddBtn.setImage(UIImage(named: "edit_delivery")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            self.promoAddBtn.setTitle(LangCommon.change, for: .normal)
            let attributerStr : NSMutableAttributedString = NSMutableAttributedString(string: "\(LangCommon.applied_promo.capitalized) \n \n \(self.viewController.promoCode ?? "")")
            attributerStr.setColorForText(textToFind: self.viewController.promoCode ?? "", withColor: .PrimaryColor)
            self.promotitleLbl.attributedText =  attributerStr

            
//            self.promotitleLbl.text =  "\(LangCommon.changePromoCode.capitalized) \n \n \(self.viewController.promoCode ?? "")"
            self.promoRemoveBtn.isHidden = false
            self.removeBtnView.isHidden = false
        } else {
            self.promoAddBtn.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            self.promoAddBtn.setTitle(LangCommon.add, for: .normal)
            self.promotitleLbl.text = LangCommon.addPromoCode.capitalized
            self.promoRemoveBtn.isHidden = true
            self.removeBtnView.isHidden = true
        }
    }
    
    func initGestures(){
        changePaymentView.changeBtn
            .addTarget(self,
                       action: #selector(changeAction(_:)),
                       for: .touchUpInside)
        
        // Delivery Splitup Start
        self.setTipsView.addAction(for: .tap) { [weak self] in
            guard let welf = self else{return}
            UIView.animate(withDuration: 0.6, animations: {
                welf.setTipsView.enterTipsTF.resignFirstResponder()
                welf.setTipsView.transform = .identity
            })
        }
        // Delivery Splitup End
        
    }
    //MARK:- UDF
    func setContent(fromJob job : HandyJobDetailModel) {
        
        let data = job.users
        self.viewController.promoID = data.promoId
        let promoname = job.promoDetails.filter({$0.id == data.promoId}).first
        self.viewController.promoCode = promoname?.code
        self.checkPaymentStatus(model: job)
        self.initPaymentView(with: job)
        // Handy Splitup Start
        self.priceTypeLbl.isHidden = data.businessID == .Delivery || data.businessID == .Ride
        self.priceTypeStack.isHidden = data.businessID == .Delivery || data.businessID == .Ride
        self.vehicleTypeStack.isHidden = data.businessID == .Services
        self.priceValueLbl.isHidden = data.businessID == .Delivery || data.businessID == .Ride
        self.viewResBtn.isHidden = !(data.businessID == .Delivery && data.jobStatus.isTripCompleted)
        // Handy Splitup End
        self.priceTypeLbl.text =  "\(LangHandy.priceType)"
        self.priceValueLbl.text = "\(data.priceType.rawValue.capitalized)"
        // Handy Splitup Start
        self.numberOfseatsLbl.isHidden = data.businessID == .Delivery || data.businessID == .Services || data.businessID == .DeliveryAll
        //self.numberOfseatsLbl.isHidden = true
        self.numberOfseatsLbl.isHidden = data.businessID == .Delivery || data.businessID == .Services || data.businessID == .DeliveryAll
        //self.numberOfseatsLbl.isHidden = true
        self.noOfSeatsvalueLbl.isHidden = data.businessID == .Delivery || data.businessID == .Services || data.businessID == .DeliveryAll
        //self.noOfSeatsvalueLbl.isHidden = true
        self.noOfSeetsStack.isHidden = data.businessID == .Delivery || data.businessID == .Services || data.businessID == .DeliveryAll
        //self.noOfSeetsStack.isHidden = true
        // Handy Splitup End

        self.noOfSeatsvalueLbl.text = "\(data.seats.capitalized)"

        
        self.vehicleLbl.text =  LangCommon.vehicleType
        self.vehicleValue.text = data.vehicleName
        self.vehicleValue.textAlignment = isRTLLanguage ? .left : .right


        self.jobReqDateValueLbl.text = data.scheduleDisplayDate
        self.pickupLocLbl.text = LangCommon.jobLocation
        self.dropLocLbl.text = LangCommon.destinationLocation
        self.pickupLocValueLbl.text = data.pickup
        self.thanksDescLbl.text =  LangCommon.thanksForProvidingThisService
        self.serviceNumberLbl.backgroundColor = .clear
        self.serviceNumberLbl.textColor = .PrimaryColor
        self.serviceNumberLbl.font = AppTheme.Fontbold(size: 14).font
        self.serviceNumberLbl.text = "\(LangHandy.serviceNo) #\(job.users.jobID.description)"
        let isCompletedJob = job.isCompletedJob
        if isCompletedJob{
//            self.thanksLblStackView.isHidden = false
//            self.thanksView.isHidden = false
            self.bottomPaymentView.isHidden = true
            self.paymentOptionHolderView.isHidden = true
            self.makePaymentBtn.isHidden = true
            self.paybuttonConst.constant = 0
        }else{
//            self.thanksView.isHidden = false
            self.paybuttonConst.constant = 140
//            self.thanksLblStackView.isHidden = true
            self.bottomPaymentView.isHidden = false
            self.paymentOptionHolderView.isHidden = false
            self.updateChangePayementViewFrame()
            self.makePaymentBtn.isHidden = false
        }
        
        if data.drop == ""
        {
            self.dropImg.isHidden = true
        }
        if data.priceType == .distance{
            self.dropLocValueLbl.isHidden = false
            self.dropLocationStack.isHidden = false
            self.dropLocationView.isHidden = false
        }else{
            self.dropLocValueLbl.isHidden = true
            self.dropLocationStack.isHidden = true
            self.dropLocationView.isHidden = true
        }
        self.dropLocValueLbl.text = data.drop
        self.totalFareValueLbl.text = "\(UserDefaults.value(for: .user_currency_symbol_org) ?? "$")" + " " + data.totalFare
        
        self.invoiceSections.removeAll()
        self.invoiceSections.append(.address)
        self.invoiceSections.append(.invoice1)
        // Handy Splitup Start
        AppWebConstants.businessType != .DeliveryAll && job.users.jobStatus == .payment ? self.invoiceSections.append(.promoView) : nil
        // Handy Splitup End
        if job.users.jobStatus == .payment && (job.users.businessID == .Services || job.users.businessID == .Ride) {
            self.invoiceSections.append(.addTips)
        }
        if isCompletedJob{
            if job.users.jobStatus == .rating || job.users.jobStatus == .completed {
                self.invoiceSections.append(.rating)
            }
            if job.users.jobImage?.beforeImages.isNotEmpty ?? false{
                self.invoiceSections.append(.beginImages)
            }
            if job.users.jobImage?.afterImages.isNotEmpty ?? false{
                self.invoiceSections.append(.endImages)
            }
        }
        // Handy Splitup Start
        AppWebConstants.businessType == .Ride ? self.invoiceSections.append(.distanceView) : nil
        // Handy Splitup End
        
        self.submitRatingHolderView.isHidden = job.users.jobStatus != .rating
        //        self.ratingView.isUserInteractionEnabled = job.users.jobStatus == .rating
        self.inputRatingView.isUserInteractionEnabled = job.users.jobStatus == .rating
        self.feedBackTextView.isEditable = job.users.jobStatus == .rating
        self.feedBackTextView.isSelectable = job.users.jobStatus == .rating
        self.providerNameLbl.text = job.providerName
        self.feedBackTextView.border(width: 1, color: .TertiaryColor)
        self.feedBackTextView.isClippedCorner = true
        self.providerImageView.border(width: 1, color: .clear)
        self.providerImageView.sd_setImage(with: NSURL(string: job.providerImage)! as URL,
                                           placeholderImage:UIImage(named:"user_dummy"))
        self.inputRatingView.setButtonTitle(rating: StarRatingEnum(rawValue: job.users.jobRating?.providerRating ?? 0) ?? StarRatingEnum.none)
        self.feedbackview.isHidden = job.users.jobRating?.providerRating ?? 0 > 0 ? true : false
//        self.feedBackTitleLbl.isHidden = job.users.jobRating?.providerRating ?? 0 > 0 ? true : false
        self.feedBackTextView.text = job.users.jobRating?.providerComments.isEmpty ?? false ? LangCommon.provideYourFeedback.capitalized : job.users.jobRating?.providerComments
        
        if self.feedBackTextView.text == LangCommon.provideYourFeedback.capitalized {
            self.feedBackTextView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        } else {
            self.feedBackTextView.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryColor
        }
        //        self.inputRatingView.set
//        let vals = Double(job.users.rating)
        let vals = job.providerRating
        if vals == 0.0 {
            self.userRatingLAbel.isHidden = true
        }else{
            let textAtt =  NSMutableAttributedString(string: "★ \(vals)")
            textAtt.setColorForText(textToFind: "\(vals)", withColor:self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            textAtt.setColorForText(textToFind: "★", withColor: .ThemeYellow)
            userRatingLAbel.attributedText = textAtt
            self.userRatingLAbel.isHidden = false
        }
        self.paymentOptionHolderView.isHidden = job.users.jobStatus != .payment
        self.makePaymentBtn.isHidden = job.users.jobStatus != .payment
        self.paymentTable.reloadDataWithAutoSizingCellWorkAround()
        self.durationValueLbl.text = "\(job.users.totalTime)"  + " " + LangCommon.mins.uppercased()
        self.distanceValueLbl.text = "\(job.users.totalkm)" + " " + LangCommon.km.uppercased()
        self.initPromoView()
        self.deleteRating(model: job)
        }
    
    //MARK: Payment  btn status
    func checkPaymentStatus(model : HandyJobDetailModel) {
        
        var priceType = ""
        print("Get price \(priceType)")
        let _ : PaymentOptions
        switch model.users.paymentMode{
            case let x where x.lowercased().contains("cash")://Cash
                changePaymentView.cashImg.image = UIImage(named:"cash_new")!.withRenderingMode(.alwaysTemplate)
                priceType = LangCommon.cash.capitalized
                if model.getPayableAmount.isEmpty || Double(model.getPayableAmount) == 0.0{
                    self.setBtnState(to: .proceed, model: model)
                }else{
                    self.setBtnState(to: .waitingForConfirmation, model: model)
                }
            case let x where x.lowercased().first == "o"://Cash
                changePaymentView.cashImg.image = UIImage(named:"onlinePay")!.withRenderingMode(.alwaysTemplate)
                priceType = LangCommon.onlinePay.capitalized
                if model.getPayableAmount.isEmpty || Double(model.getPayableAmount) == 0.0{
                    self.setBtnState(to: .proceed, model: model)
                }else{
                    self.setBtnState(to: .pay, model: model)
                }
            case let x where x.lowercased().first == "b"://Braintree
                changePaymentView.cashImg.image = UIImage(named:"braintree")!
                priceType = UserDefaults.value(for: .brain_tree_display_name) ?? LangCommon.onlinePay
                if model.getPayableAmount.isEmpty || Double(model.getPayableAmount) == 0.0{
                    self.setBtnState(to: .proceed, model: model)
                }else{
                    self.setBtnState(to: .pay, model: model)
                }
            case let x where x.lowercased().first == "p"://Pay Pal
                changePaymentView.cashImg.image = UIImage(named:"paypal")!.withRenderingMode(.alwaysTemplate)
                priceType = LangCommon.paypal.capitalized
                if model.getPayableAmount.isEmpty || Double(model.getPayableAmount) == 0.0{
                    self.setBtnState(to: .proceed, model: model)
                }else{
                    self.setBtnState(to: .pay, model: model)
                }
            case let x where x.lowercased().first == "s"://Stripe
                if model.getPayableAmount.isEmpty || Double(model.getPayableAmount) == 0.0{
                    self.setBtnState(to: .proceed, model: model)
                }else{
                    self.setBtnState(to: .pay, model: model)
                }
                changePaymentView.cashImg.image = UIImage(named:"stripe_card_new")!.withRenderingMode(.alwaysTemplate)
                priceType = LangCommon.card.uppercased()
                _ = UserDefaults.standard
                if let last4 : String = UserDefaults.value(for: .card_last_4),
                   let brand : String = UserDefaults.value(for: .card_brand_name),!last4.isEmpty{
                    changePaymentView.cashLbl.text  = "**** "+last4
                    changePaymentView.cashImg.image = self.viewController.getCardImage(forBrand: brand)
                }
            case let x where x.lowercased().first == "a":
                changePaymentView.cashImg.image = UIImage(named:"apple-pay")!.withRenderingMode(.alwaysTemplate)
                priceType = "apple_pay"
                if model.getPayableAmount.isEmpty || Double(model.getPayableAmount) == 0.0{
                    self.setBtnState(to: .proceed, model: model)
                }else{
                    self.setBtnState(to: .pay, model: model)
                }
            default:
                changePaymentView.cashImg.image = UIImage(named:"cash_new")!.withRenderingMode(.alwaysTemplate)
                priceType = LangCommon.cash.capitalized
                self.setBtnState(to: .proceed, model: model)
        }
        switch PaymentOptions.default {
        case .cash:
            changePaymentView.cashImg.image = UIImage(named:"cash_new")!.withRenderingMode(.alwaysTemplate)
            //changePaymentView.cashLbl.text = LangCommon.cash.capitalized
            changePaymentView.cashLbl.text = model.users.businessID == .Delivery ? LangCommon.selectPaymentMode.capitalized : LangCommon.cash.capitalized
        case .paypal:
            changePaymentView.cashImg.image = UIImage(named:"paypal")!.withRenderingMode(.alwaysTemplate)
            changePaymentView.cashLbl.text = LangCommon.paypal.capitalized
        case .brainTree:
            changePaymentView.cashImg.image = UIImage(named:"braintree")!
            changePaymentView.cashLbl.text = UserDefaults.value(for: .brain_tree_display_name) ?? LangCommon.onlinePay
        case .onlinepayment:
            changePaymentView.cashImg.image = UIImage(named:"onlinePay")!.withRenderingMode(.alwaysTemplate)
            changePaymentView.cashLbl.text = LangCommon.onlinePayment
        case .stripe:
            changePaymentView.cashImg.image = UIImage(named:"stripe_card_new")!.withRenderingMode(.alwaysTemplate)
            changePaymentView.cashLbl.text = LangCommon.card.uppercased()
            if let last4 : String = UserDefaults.value(for: .card_last_4),
                let brand : String = UserDefaults.value(for: .card_brand_name),!last4.isEmpty{
                changePaymentView.cashLbl.text  = "**** "+last4
                changePaymentView.cashImg.image = self.viewController.getCardImage(forBrand: brand)
            }
        default:
            changePaymentView.cashImg.image = UIImage(named:"apple-pay")!.withRenderingMode(.alwaysTemplate)
            changePaymentView.cashLbl.text = "Apple Pay"
        }
//        changePaymentView.cashLbl.text = priceType
        
        self.paymentTypeLbl.text = "\(LangCommon.paymentType)"
        self.paymentValueLbl.text = "\(model.users.paymentResult)"
        
    }
    func initPaymentView(with job : HandyJobDetailModel?){
        changePaymentView.changeBtn.addTarget(self, action: #selector(changeAction(_:)), for: .touchUpInside)
        self.changePaymentView.changeBtn.setTitle(LangCommon.change.capitalized , for: .normal)
        self.checkPromo(job: job)
        self.changePaymentView.ThemeChange()
//        self.changePaymentView.promoStack.isHidden = !(
//            Constants().GETVALUE(keyname: USER_PROMO_CODE) != "0"
//                && Constants().GETVALUE(keyname: USER_PROMO_CODE) != "")
        self.changePaymentView.promoStack.isHidden = true
        print("payment method \(String(describing: PaymentOptions.default))")
        let walletAmt = UserDefaults.value(for: .wallet_amount) ?? ""
        self.changePaymentView.walletStack.isHidden = !(
            Constants().GETVALUE(keyname: USER_SELECT_WALLET) == "Yes"
                && !walletAmt.toDouble().isZero)
        print("isWallet",Constants().GETVALUE(keyname: USER_SELECT_WALLET))
        self.changePaymentView.promoStack.isHidden = true
        self.layoutIfNeeded()
    }
//    func onPromoCode() {
//        self.changePaymentView.promoStack.isHidden = true
//        self.initPromo()
//    }
    //MARK:- Payment change status tracking in firebase
    
    // goto payment success page
    @objc func getPaymentSuccess(_ notification : Notification)
    {
        if self.isPaidShown
        {
            return
        }
        self.backAction(UIButton())
    }
    func onPaymentSucces(_ json : JSON){
        
        //666
    }
    
    @IBAction func viewResBtnPressed(_ sender: Any) {
        
    }
    // if rider paid a cash payment driver update the server to the api
    
    
    func setBtnState(to state : BtnPymtStatus,model : HandyJobDetailModel){
        self.viewController.paymentButtonStatus = state
        self.makePaymentBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            switch state {
            case .pay:
                self.makePaymentBtn.setTitle(LangCommon.pay.uppercased(), for: .normal)
                self.makePaymentBtn.backgroundColor = .PrimaryColor
                self.makePaymentBtn.isUserInteractionEnabled = true
            case .waitingForConfirmation:
                self.makePaymentBtn.setTitle(LangCommon.waitDriverConfirm.uppercased(), for: .normal)
                self.makePaymentBtn.backgroundColor = .TertiaryColor
                self.makePaymentBtn.isUserInteractionEnabled = false
            case .proceed:
                self.makePaymentBtn.setTitle(LangCommon.proceed.uppercased(), for: UIControl.State.normal)
                self.makePaymentBtn.backgroundColor = .PrimaryColor
                self.makePaymentBtn.isUserInteractionEnabled = true
            case .continueToRequest:
                self.makePaymentBtn.setTitle(LangCommon.continueRequest.uppercased(), for: .normal)
                self.makePaymentBtn.backgroundColor = .TertiaryColor
                self.makePaymentBtn.isUserInteractionEnabled = true
            }
        }
        
    }
    
    
    
    // User when press back button
    @IBAction
    func onBackTapped(_ sender:UIButton!) {
        if let controller = self.viewController.findLastBeforeVC(),
           // Handy Splitup Start
           controller.isKind(of: HandyRouteVC.self) {
            // Handy Splitup End
            self.viewController.setRootVC()
        }else{
            self.viewController.exitScreen(animated: true)
        }
    }
    
    @IBAction func addPromo(_ sender: UIButton) {
        let vc = ProfilePromoCodeViewController.initWithStory(self)
        vc.isFromPayment = true
        vc.payment_promo = self.viewController.promoID
        self.viewController.navigationController?.pushViewController(vc,animated: true)
    }
    
    
    @IBAction func removePromo(_ sender: UIButton) {
        self.initPromoView()
        self.viewController.wsToGetInvoice(withTips: nil, withpromoid: 0)
    }
    
    
    //MARK:- Tableview delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.invoiceSections.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let selectedSection = self.invoiceSections.value(atSafe: section) else{return 0}
        switch selectedSection {
        case .address:
            return 0
        case .invoice1:
            return 0
        case .rating:
            return 0
        case .beginImages,.endImages:
            return 50
        case .addTips:
            return 0
        case .distanceView:
            return 0
        case .promoView:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let selectedSection = self.invoiceSections.value(atSafe: section) else{return 0}
        switch selectedSection {
        case .address:
            return 0
        case .invoice1:
            return 0
        case .rating:
            return 0
        case .beginImages,.endImages:
            return 50
        case .addTips:
            return 0
        case .distanceView:
            return 0
        case .promoView:
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let selectedSection = self.invoiceSections.value(atSafe: section) else{return nil}
        switch selectedSection {
        case .address:
            return nil
        case .invoice1:
            return nil
        case .rating:
            return nil
        case .beginImages,.endImages:
            return nil
        case .addTips:
            return nil
        case .distanceView:
            return nil
        case .promoView:
            return nil
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let selectedSection = self.invoiceSections.value(atSafe: section) else{return nil}
        switch selectedSection {
        case .address,.invoice1,.rating, .addTips:
            return nil
        case .beginImages:
            return LangCommon.beforeService
        case .endImages:
            return LangCommon.afterService
            
        case .distanceView:
            return nil
        case .promoView:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedSection = self.invoiceSections.value(atSafe: section) else{return 0}
        switch selectedSection {
        case .invoice1:
            return (self.viewController.jobViewModel.jobDetailModel?.users.modifiedInvoice.count ?? 0)
        case .rating:
            return (self.viewController.jobViewModel.jobDetailModel?.isCompletedJob ?? false) ? 1 : 0
        case .address:
            return 1
        case .beginImages,.endImages:
            return 1
        case .addTips:
            return 1
        case .distanceView:
            return 1
        case .promoView:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let selectedSection = self.invoiceSections.value(atSafe: indexPath.section) else{return 0}
        switch selectedSection {
        case .invoice1:
            let model = self.viewController.jobViewModel.jobDetailModel?.users.modifiedInvoice[indexPath.row]
            if isFareDetailsShow{
                if model?.bar == 1{
                    return 64
                }else{
                    return 44
                }
            }
            else{
                return 0
            }
            
        case .address:
            return UITableView.automaticDimension
        case .rating:
            return UITableView.automaticDimension
        case .beginImages,.endImages:
            return 80
        case .addTips:
            return 50
        case .distanceView:
            return 120
        case .promoView:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let selectedSection = self.invoiceSections.value(atSafe: indexPath.section) else{return 0}
        switch selectedSection {
        case .invoice1:
            let model = self.viewController.jobViewModel.jobDetailModel?.users.modifiedInvoice[indexPath.row]
//            if isFareDetailsShow{
                if model?.bar == 1{
                    return UITableView.automaticDimension
                }else{
                    return UITableView.automaticDimension
                }
//            }
//            else{
//                return 0
//            }
            
        case .rating:
            return UITableView.automaticDimension
        case .address:
            return UITableView.automaticDimension
        case .beginImages,.endImages:
            return 80
        case .addTips:
            return 50
        case .distanceView:
            return 120
        case .promoView:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let selectedSection = self.invoiceSections.value(atSafe: indexPath.section) else{return UITableViewCell()}
        let jobDetailModel = self.viewController.jobViewModel.jobDetailModel
        guard jobDetailModel?.users.modifiedInvoice.count ?? 0 > 0 else {return UITableViewCell()}
        let model = jobDetailModel?.users.modifiedInvoice[indexPath.row]
        switch selectedSection {
        case .invoice1:
            let cell : PaymentTVC = paymentTable.dequeueReusableCell(for: indexPath)
            if indexPath.row == 0 {
                cell.ThemeUpdate()
                //            cell.serviceItem.textColor = UIColor(hex: AppWebConstants.RegularLabelTextColor)
                //            cell.serviceItem.font = .boldSystemFont(ofSize: 16)
                cell.serviceItem.font = AppTheme.Fontlight(size: 16).font
                cell.rate.font = AppTheme.Fontlight(size: 16).font
                //            cell.backgroundColor = UIColor.init(hex: AppWebConstants.TertiaryColor).withAlphaComponent(0.1)
                
                cell.outerView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
                cell.outerView.border(width: 0, color: .clear)
                cell.rate.text = ""
                cell.serviceItem.setTextAlignment()
                cell.serviceItem.text = LangCommon.fareDetails
                cell.currencySymbol.text = ""
                cell.borderView.border(width: 0, color: .clear)
//                cell.borderView.cornerRadius = 0
                cell.dropDownImg.isHidden = false
                //            cell.borderView.backgroundColor = UIColor.clear
                cell.contentView.layoutIfNeeded()
                cell.contentView.layoutSubviews()
                if let comment = model?.comment,
                   !comment.isEmpty{
                    cell.serviceItem.text = cell.serviceItem.text! + " ⓘ"
                    cell.serviceItem.addAction(for: .tap) { [unowned self] in
                        self.viewController.showPopOver(withComment: comment,on : cell.serviceItem!)
                    }
                }else{
                    cell.serviceItem.addAction(for: .tap) {}
                }
                cell.layoutIfNeeded()
            } else {
                
                
                //            if indexPath.row == self.viewController.jobViewModel.jobDetailModel?.users.invoice.count ?? 1 - 1{
                //                cell.outerView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10)
                //            }
                
                if model?.bar == 1{
                    cell.ThemeUpdate()
                    cell.outerView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
                    cell.borderView.border(width: 0, color: .clear)
                    cell.dropDownImg.isHidden = true
                    cell.serviceItem.font = AppTheme.Fontlight(size: 16).font
                    cell.rate.font = AppTheme.Fontlight(size: 16).font
                    cell.outerView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
                    cell.currencySymbol.text = ""
                    cell.rate.text = model?.value
                    cell.serviceItem.text = model?.key
                    cell.contentView.layoutIfNeeded()
                    cell.contentView.layoutSubviews()
                }else{
                    cell.ThemeUpdate()
                    cell.serviceItem.font = AppTheme.Fontlight(size: 16).font
                    cell.rate.font = AppTheme.Fontlight(size: 16).font
                    cell.outerView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
                    cell.outerView.border(width: 0, color: .clear)
                    cell.borderView.border(width: 0, color: .clear)
                    cell.currencySymbol.text = ""
                    cell.rate.text = model?.value
                    cell.serviceItem.text = model?.key
                    cell.dropDownImg.isHidden = true
                    cell.contentView.layoutIfNeeded()
                    cell.contentView.layoutSubviews()
                }
                
                if let comment = model?.comment,
                   !comment.isEmpty{
                    cell.serviceItem.text = cell.serviceItem.text! + " ⓘ"
                    cell.serviceItem.addAction(for: .tap) { [unowned self] in
                        self.viewController.showPopOver(withComment: comment,on : cell.serviceItem!)
                    }
                }else{
                    cell.serviceItem.addAction(for: .tap) {}
                }
                //            cell.ThemeUpdate()
                let colorStr = model?.colour
                if !(colorStr?.isEmpty ?? false){
                    //                let color = colorStr == "black" ? UIColor(hex: "000000") : UIColor(hex: "27aa0b")
                    cell.serviceItem?.textColor = UIColor(named: colorStr?.capitalized ?? "black") //color
                    cell.rate?.textColor = UIColor(named: colorStr?.capitalized ?? "black") //color
                }else{
                    let color : UIColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                    cell.serviceItem?.textColor = color
                    cell.rate?.textColor = color
                }
                cell.serviceItem.setTextAlignment()
                cell.rate.setTextAlignment()
                cell.layoutIfNeeded()
            }
            if indexPath.row == 0,
               let model = self.viewController.jobViewModel.jobDetailModel?.users{
                if model.showInvoice {
                    cell.outerView.setTopCorners(radius: 10)
                    cell.dropDownImg.transform = CGAffineTransform(rotationAngle: .pi)
                    cell.outerView.clipsToBounds = true
                    cell.outerView.layoutIfNeeded()
                }else{
                    cell.outerView.cornerRadius = 10
                    cell.dropDownImg.transform = .identity
                    cell.outerView.clipsToBounds = true
                    cell.outerView.layoutIfNeeded()
                }
            } else if let count = self.viewController.jobViewModel.jobDetailModel?.users.modifiedInvoice.count,
               indexPath.row == count - 1 {
                cell.outerView.setBottomCorners(radius: 10)
                cell.outerView.clipsToBounds = true
                cell.outerView.layoutIfNeeded()
            } else {
                cell.outerView.cornerRadius = 0
                cell.outerView.clipsToBounds = false
                cell.outerView.layoutIfNeeded()
            }
            return cell
            // Delivery Splitup Start
        case .beginImages:
            let cell : JobImageTVC = tableView.dequeueReusableCell(for: indexPath)
            guard let items = jobDetailModel?.users.jobImage?.beforeImages else{return cell}
            cell.images = items
            cell.parentTableView = tableView
            cell.navigationDelegate = self.viewController
            cell.collectionView.reloadData()
            return cell
        case .endImages:
            let cell : JobImageTVC = tableView.dequeueReusableCell(for: indexPath)
            guard let items = jobDetailModel?.users.jobImage?.afterImages else{return cell}
            cell.parentTableView = tableView
            cell.images = items
            //            cell.backgroundColor = UIColor.init(hex: AppWebConstants.TertiaryColor).withAlphaComponent(0.1)
            cell.navigationDelegate = self.viewController
            cell.collectionView.reloadData()
            cell.ThemeUpdate()
            return cell
            // Handy Splitup Start
            // Delivery Splitup Start
        case .address:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") else { return UITableViewCell() }
            cell.addSubview(self.headerView)
            self.headerView.anchor(toView: cell,
                                   leading: 0,
                                   trailing: 0,
                                   top: 0,
                                   bottom: 0)
            return cell
        case .rating:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") else { return UITableViewCell() }
            cell.addSubview(self.ratingView)
            self.ratingView.anchor(toView: cell,
                                   leading: 0,
                                   trailing: 0,
                                   top: 0,
                                   bottom: 0)
            return cell
        case .distanceView:
            // Handy Splitup Start
            if AppWebConstants.businessType == .Ride{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tripDistCell") else { return UITableViewCell() }
            cell.addSubview(self.tripDistView)
            self.tripDistView.anchor(toView: cell,
                                   leading: 0,
                                   trailing: 0,
                                   top: 0,
                                   bottom: 0)
            return cell
            }else{
                return UITableViewCell()}
            // Handy Splitup End
        case .promoView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "promocodeCell") else { return UITableViewCell() }
            cell.addSubview(self.promoView)
            self.promoView.anchor(toView: cell,
                                   leading: 0,
                                   trailing: 0,
                                   top: 0,
                                   bottom: 0)
            return cell
        case .addTips:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTipTableViewCell") as? AddTipTableViewCell else { return UITableViewCell() }
             let curr_sym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
            cell.updateTipAmountView(riderGivenTripAmount: self.givenTipsAmount, curr_sym: curr_sym)
            cell.tipsView.layer.cornerRadius = 15
            cell.tipsView.elevate(2)
            cell.tipsView.addAction(for: .tap) { [weak self] in
                guard let welf = self,welf.givenTipsAmount == nil else{return}
                UIView.animate(withDuration: 0.6,
                               animations: {
                                welf.setTipsView.transform = .identity
                               }, completion: { (completed) in
                                if completed{
                                    welf.setTipsView.enterTipsTF.becomeFirstResponder()
                                }
                               })
            }
            
            cell.tipCloseImageView.addAction(for: .tap) { [weak self] in
                guard let welf = self,welf.givenTipsAmount != nil else{return}
                welf.givenTipsAmount =  nil
                cell.updateTipAmountView(riderGivenTripAmount: nil, curr_sym: curr_sym)
                welf.viewController.wsToGetInvoice(withTips: nil, withpromoid: nil)
            }
            cell.ThemeUpdate()
            return cell
        default:
            return UITableViewCell()
        }
        
    }

//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        // Delivery Splitup Start
//        guard let selectedSection = self.invoiceSections.value(atSafe: section) else{return nil}
//        if selectedSection == .addTips {
//            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 45)
//            let cell = AddTipsView.CreateView(frame)
//            let curr_sym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
//            cell.updateTipAmountView(riderGivenTripAmount: self.givenTipsAmount, curr_sym: curr_sym)
//            cell.tipsView.layer.cornerRadius = 15
//            cell.tipsView.elevate(2)
//            cell.tipsView.addAction(for: .tap) { [weak self] in
//                guard let welf = self,welf.givenTipsAmount == nil else{return}
//                UIView.animate(withDuration: 0.6,
//                               animations: {
//                                welf.setTipsView.transform = .identity
//                               }, completion: { (completed) in
//                                if completed{
//                                    welf.setTipsView.enterTipsTF.becomeFirstResponder()
//                                }
//                               })
//            }
//
//            cell.tipCloseImageView.addAction(for: .tap) { [weak self] in
//                guard let welf = self,welf.givenTipsAmount != nil else{return}
//                welf.givenTipsAmount =  nil
//                cell.updateTipAmountView(riderGivenTripAmount: nil, curr_sym: curr_sym)
//                welf.viewController.wsToGetInvoice(withTips: nil, withpromoid: nil)
//            }
//            cell.ThemeUpdate()
//            return cell
//        }
//        // Delivery Splitup End
//        return nil
//    }
    
    
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        guard let selectedSection = self.invoiceSections.value(atSafe: section) else{return 0}
//        if selectedSection == .addTips {
//            return 60
//        }
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedSection = self.invoiceSections.value(atSafe: indexPath.section),
        let model = self.viewController.jobViewModel.jobDetailModel?.users else{ return }
        
        switch selectedSection{
        case .invoice1:
            if indexPath.row == 0 {
                model.showInvoice = !(model.showInvoice)
                //                isFareDetailsShow = !isFareDetailsShow
                self.paymentTable.reloadDataWithAutoSizingCellWorkAround()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.paymentTable.reloadDataWithAutoSizingCellWorkAround()
                }
            }
        case .address:
            return
        case .rating:
            return
        case .beginImages:
            return
        case .endImages:
            return
        case .addTips:
            return
        case .distanceView:
            return
        case .promoView:
            return
        }
    }
    
}

extension HandyPaymentView : CustomRatingViewProtocol {
    func updateRatingValue(rating: StarRatingEnum) {
        print(rating.rawValue)
        self.userRating = rating.rawValue
    }
    
    
}

extension HandyPaymentView: UITextViewDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (range.length == 0) {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LangCommon.provideYourFeedback.capitalized {
            textView.text = nil
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LangCommon.provideYourFeedback.capitalized
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        lblPlaceHolder.isHidden = (txtComments.text.count > 0) ? true : false
        if textView.text == LangCommon.provideYourFeedback.capitalized {
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        } else {
            textView.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        }
    }
}

extension HandyPaymentView : UITextFieldDelegate {
    @objc func textFieldDidChangeValue(_ textField:UITextField) {
        print(textField.text!)
    }
    
    // Delivery Splitup Start
    @objc func setTipAmount(_ sender : UIButton?){
        
        guard let amount = Double(self.setTipsView.enterTipsTF.text ?? ""),
              !amount.isZero else{
            
            //                self.viewController.appDelegate.createToastMessage(LangCommon.pleaseEnterValidAmount)//"Please enter valid amount"
            return
        }
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let welf = self else {return}
            welf.setTipsView.enterTipsTF.text = ""
            welf.setTipsView.enterTipsTF.resignFirstResponder()
            welf.endEditing(true)
            welf.setTipsView.transform = CGAffineTransform(translationX: 0,
                                                           y: welf.frame.height)
        }
        self.givenTipsAmount = amount
        if let index = self.invoiceSections.firstIndex(where: {$0 == .addTips}) {
            self.paymentTable.reloadSections(IndexSet(integer: index), with: .automatic)
        }
        self.viewController.wsToGetInvoice(withTips: amount, withpromoid: nil)
    }
    @objc func cancelTipAction(_ sender : UIButton){
        UIView.animate(withDuration: 0.6) {
            self.endEditing(true)
            
            self.setTipsView.enterTipsTF.text = ""
            self.setTipsView.transform = CGAffineTransform(translationX: 0,
                                                           y: self.frame.height)
        }
    }
    // Delivery Splitup End
}

extension UITableView {
    //addKeyboard Observer for keyboard show&hide
    func addkeyBoardObserver()
    {
        
        NotificationCenter.default.addObserver( self, selector: #selector(self.handleKeyboard(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(self.handleKeyboard(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //handle keyboard height dynamically
    @objc func handleKeyboard( note:NSNotification )
    {
        // read the CGRect from the notification (if any)
        if let keyboardFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            if self.contentInset.bottom == 0 && keyboardFrame.height != 0 {
                let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
                self.contentInset = edgeInsets
                self.scrollIndicatorInsets = edgeInsets
            }
            else {
                let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.contentInset = edgeInsets
                self.scrollIndicatorInsets = edgeInsets
            }
        }
    }
}

extension HandyPaymentView : PromoValuePassedProtocol {
    func promoCodeName(code: String) {
        self.viewController.promoCode = code
    }
    
    func promoDetailId(id: Int) {
        
    }
    
    func reloadPromo() {
        self.initPromoView()
    }
    
    func promoUpdate(promoId: Int) {
        self.viewController.promoID = promoId
        print("PromoId=====",promoId)
    }
}
