//
//  HandyProviderDetailView.swift
//  GoferHandy
//
//  Created by trioangle on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

enum ProfileCategories : Int{
      case services = 0, gallery, ratings
    var localizedString: String {
      switch self {
      case .services:
        return LangCommon.service
      case .gallery:
        return LangCommon.gallery
      case .ratings:
        return LangCommon.review
        }
    }
    var key : String {
        switch self {
        case .services:
            return "category"
        case .gallery:
            return "gallery"
        case .ratings:
            return "rating"
        }
    }
  }

class HandyProviderDetailView: BaseView {
  
    var providerDetailVC :  HandyProviderDetailVC!
  
    //MARK:- Outlets
    @IBOutlet weak var ratinglbl: UILabel!
    @IBOutlet weak var providerNameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var providerProfileIV :UIImageView!
    @IBOutlet weak var providerDescription : SecondaryRegularLabel!
    @IBOutlet weak var providerRatingStack : StarStackView!
    @IBOutlet weak var ratingStack: UIStackView!
    
   
    
    @IBOutlet weak var reviewTable : CommonTableView!
    @IBOutlet weak var serviceTable : CommonTableView!
    @IBOutlet weak var galleryCollectionView : UICollectionView!
    
    @IBOutlet weak var serVicesBtn : SecondaryButton!
    @IBOutlet weak var galleryBtn : SecondaryButton!
    @IBOutlet weak var reviewsBtn : SecondaryButton!
    @IBOutlet weak var sliderView : UIView!
    @IBOutlet weak var btnsBGView: HeaderView!
    @IBOutlet weak var viewMoreHolderView: UIView!
    
    //@IBOutlet weak var segmentController : CommonSegmentControl!
    
    @IBOutlet weak var parentScrollView : UIScrollView!
    @IBOutlet weak var stackScrollChild : UIStackView!
    @IBOutlet weak var viewScrollChild : UIView!
    
    
    @IBOutlet weak var galleryHolderView : TopCurvedView!
    @IBOutlet weak var servicesHolderView : TopCurvedView!
    @IBOutlet weak var reviewHolderView : TopCurvedView!
    
    @IBOutlet weak var galleryInnerView : TopCurvedView!
    @IBOutlet weak var servicesInnerView : TopCurvedView!
    @IBOutlet weak var reviewInnerView : TopCurvedView!
    
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var viewBasketView : TopCurvedView!
    @IBOutlet weak var itemCountLbl: SecondarySmallLabel!
    @IBOutlet weak var cartImageView: SecondaryImageView!
    
    @IBOutlet weak var viewMoreBtn: PrimarySmallTextButton!
    @IBOutlet weak var checkoutLbl: PrimarySubHeaderLabel!
    @IBOutlet weak var totalPriceLbl: PrimarySubHeaderLabel!
    @IBOutlet weak var holderBottomAnchor : NSLayoutConstraint!
    
    @IBOutlet weak var checkOutView : PrimaryView!
    
    // View More Option
    
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var contentView : CurvedView!
    @IBOutlet weak var descriptionLbl : SecondaryRegularLabel!
    
    enum state {
        case middle
        case full
    }
    
    var currentState : state = .middle
    
    //MARK:- Actions
    
    @IBOutlet weak var HolderBGView: SecondaryView!
    @IBOutlet weak var basketHight: NSLayoutConstraint!
    
    
    
    var oneTimeReviewApiHitted : Bool = true
    var oneTimeGalleryApiHitted : Bool = true
    var oneTimeServicesApiHitted : Bool = true
    
    var galleryCurrentPage : Int = 1
    var reviewCurrentPage : Int = 1
    var galleryTotalPage : Int = 0
    
    var remainingGalleryAPICount : Int = 0
    var remainingReviewAPICount : Int = 0
    
    
    
    override func darkModeChange() {
        super.darkModeChange()
        self.galleryCollectionView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.parentScrollView.backgroundColor = self.isDarkStyle ? .DarkModeBackground :  .SecondaryColor
        self.titleLbl.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.btnsBGView.customColorsUpdate()
        self.bgView.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.galleryBtn.customColorsUpdate()
        self.reviewsBtn.customColorsUpdate()
        self.serVicesBtn.customColorsUpdate()
        self.contentView.customColorsUpdate()
        self.descriptionLbl.customColorsUpdate()
        self.serviceTable.customColorsUpdate()
        self.reviewTable.customColorsUpdate()
        self.contentView.customColorsUpdate()
        self.HolderBGView.customColorsUpdate()
        self.viewBasketView.customColorsUpdate()
        self.viewMoreBtn.customColorsUpdate()
        self.checkoutLbl.customColorsUpdate()
        self.totalPriceLbl.customColorsUpdate()
        self.providerNameLbl.customColorsUpdate()
        self.providerDescription.customColorsUpdate()
        self.galleryHolderView.customColorsUpdate()
        self.reviewHolderView.customColorsUpdate()
        self.servicesHolderView.customColorsUpdate()
        self.galleryInnerView.customColorsUpdate()
        self.reviewInnerView.customColorsUpdate()
        self.servicesInnerView.customColorsUpdate()
        //self.segmentController.customColorsUpdate()
        self.serviceTable.reloadData()
        self.galleryCollectionView.reloadData()
        self.reviewTable.reloadData()
        if let text = self.ratinglbl.attributedText {
            let attText = NSMutableAttributedString(attributedString: text)
            attText.setColorForText(textToFind: attText.string, withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            attText.setColorForText(textToFind: "★", withColor: .ThemeYellow)
            self.ratinglbl.attributedText = attText
        }
        self.cartImageView.customColorsUpdate()
        self.cartImageView.image = self.cartImageView.image?.withRenderingMode(.alwaysTemplate)
        self.cartImageView.tintColor = .PrimaryTextColor
        self.itemCountLbl.textColor = .SecondaryColor
    }
    @IBAction
    override func backAction(_ sender : UIButton){
        guard self.providerDetailVC.provider.bookedItems.isEmpty else{
            self.showAlertBeforeExit()
            return
        }
        super.backAction(sender)
    }
    
//    @IBAction func segmentChanged(_ sender: Any) {
//        self.setTo(content: ProfileCategories(rawValue: self.segmentController.selectedSegmentIndex)!)
//    }
//    //MARK:- Variables
//    var selectedContent : ProfileCategories{
//        get{
//            return ProfileCategories(rawValue: self.segmentController.selectedSegmentIndex) ?? .services
//
//        }
//        set{
//            self.segmentController.selectedSegmentIndex = newValue.rawValue
//
//        }
//    }
    
    
    var currentTab : ProfileCategories = .services {
        didSet{
            let services = currentTab == .services
            let gallery = currentTab == .gallery
            let ratings = currentTab == .ratings

            switch currentTab {
            case .services:
                UIView.animate(withDuration: 0.3, animations: {
                    self.parentScrollView.contentOffset = services
                                    ? CGPoint(x: self.servicesHolderView.frame.minX,
                                              y: 0)
                                    : CGPoint.zero
                    if isRTLLanguage{
                        self.sliderView.transform = CGAffineTransform(translationX: -self.reviewsBtn.frame.minX, y: 0)
                    }else{
                        self.sliderView.transform = CGAffineTransform(translationX: self.serVicesBtn.frame.minX , y: 0)
                    }}){ completed in
                    if completed{
                        self.setTo(content: .services)
                        //self.serviceTable.reloadData()
                    }
                }
            case .gallery:
                UIView.animate(withDuration: 0.3, animations: {
                                self.parentScrollView.contentOffset = gallery
                                                ? CGPoint(x: self.galleryHolderView.frame.minX,
                                                          y: 0)
                                                : CGPoint.zero
                    if isRTLLanguage{
                        self.sliderView.transform = CGAffineTransform(translationX: -self.galleryBtn.frame.minX, y: 0)
                    }else{
                        self.sliderView.transform = CGAffineTransform(translationX: self.galleryBtn.frame.minX , y: 0)
                    }}){ completed in
                    if completed{
                        self.setTo(content: .gallery)
                        //self.galleryCollectionView.reloadData()
                    }
                }
            case .ratings:
                UIView.animate(withDuration: 0.3, animations: {
                                self.parentScrollView.contentOffset = ratings
                                    ? CGPoint(x: self.reviewHolderView.frame.minX,
                                                          y: 0)
                                                : CGPoint.zero
                    if isRTLLanguage{
                        self.sliderView.transform = CGAffineTransform(translationX: -self.serVicesBtn.frame.minX, y: 0)
                    }else{
                        self.sliderView.transform = CGAffineTransform(translationX: self.reviewsBtn.frame.minX , y: 0)
                    }}){ completed in
                    if completed{
                        self.setTo(content: .ratings)
                        //self.reviewTable.reloadData()
                    }
                }
          
            }
            
            
        }
    }
    
    
    var currentCategoryDetails = String()
    var selectedRatingIndex : Int? = nil
    //MAKR:- life cycle
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.providerDetailVC = baseVC as? HandyProviderDetailVC
        
        self.initView()
        self.initLanguage()
        self.initGestures()
        self.darkModeChange()
        self.parentScrollView.delegate = self
        self.galleryCollectionView.register(footer.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")

    }
    func resetModel() {
        self.providerDetailVC.provider.gallery.removeAll()
        self.providerDetailVC.provider.reviews.removeAll()
        self.providerDetailVC.provider.categories.removeAll()
        self.galleryCollectionView.reloadData()
        self.reviewTable.reloadData()
        self.serviceTable.reloadData()
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
    }
    override func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
        
    }

    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
    //MARK:- initializers
    
    func initView(){
        // Inital Hide State
        self.viewMoreHolderView.isHidden = true
        self.viewMoreBtn.setTitle(LangCommon.viewMore, for: .normal)
        self.checkoutLbl.text = LangCommon.checkOut
        self.layoutIfNeeded()
        self.showHideBasket()
        self.contentView.layer.cornerRadius = 10
        self.contentView.elevate(2.5)
        self.reviewTable.registerNib(forCell: HandyUserProfileTVC.self)
        self.serviceTable.registerNib(forCell: HandySubServiceTVC.self)
        self.serviceTable.registerNib(forCell: LoadMoreTVC.self)
        self.reviewTable.tableFooterView = self.providerDetailVC.reviewBottomLoader
        self.reviewTable.delegate = self
        self.reviewTable.dataSource = self
        self.serviceTable.delegate = self
        self.serviceTable.dataSource = self
        self.providerDescription.isUserInteractionEnabled = true
        self.serviceTable.separatorColor = UIColor.clear
        self.reviewTable.separatorColor = UIColor.clear
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
        
        self.currentTab = .services
        self.setTo(content: .services)
        
        
    }
    func initLanguage(){
        self.sliderView.backgroundColor = .PrimaryColor
        self.serVicesBtn.setTitle(ProfileCategories(rawValue: 0)?.localizedString, for: .normal)
        self.galleryBtn.setTitle(ProfileCategories(rawValue: 1)?.localizedString, for: .normal)
        self.reviewsBtn.setTitle(ProfileCategories(rawValue: 2)?.localizedString, for: .normal)
    }
    func initGestures(){
        self.checkOutView.layer.cornerRadius = 15
        self.checkOutView.addAction(for: .tap) { [weak self] in
            self?.providerDetailVC.navigateToCheckOut()
        }    
    }
    @IBAction func switchTabAction(_ sender : UIButton?){
        if sender == self.serVicesBtn {
            self.currentTab = .services
            self.setTo(content: .services)

        }else if sender == self.galleryBtn{
            self.currentTab = .gallery
            self.setTo(content: .gallery)

        }else{
            self.currentTab = .ratings
            self.setTo(content: .ratings)

        }
    }
    
    func addViewMoreView() {
        self.addSubview(self.bgView)
        self.bgView.anchor(toView: self, leading: 0, trailing: 0, top: 0, bottom: 0)
        
        // Inital Bottom Posiotion
        self.contentView.alpha = 0
        self.bgView.frame.origin.y = self.frame.maxY * 1.5
        self.contentView.frame.origin.y = self.frame.maxY * 1.5
        self.currentState = .middle
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5) {
            self.bgView.frame.origin.y = self.frame.minY
            self.contentView.frame.origin.y = self.frame.midY
            self.contentView.alpha = 1
        } completion: { (_) in
            print("Success Fully View Added")
        }

    }
    
    @IBAction func providerDescriptionViewMoreClicked(_ sender: Any) {
        self.addViewMoreView()
    }
    //MARK:- udf
    func setProvider(details : Provider){
        self.providerNameLbl.text = details.name
//        self.providerDescription.text = ""
        // In order to hide the view more button based on the service De
//        self.viewMoreBtn.isHidden = details.serviceDescription.isEmpty
        
        self.providerDescription.text = details.serviceDescription
        self.viewMoreBtn.isHidden = !(self.providerDescription.calculateMaxLines() > 2)
        self.descriptionLbl.text = details.serviceDescription
        self.initGestures()
        self.providerProfileIV.sd_setImage(with: URL(string: details.profilePicture),
                                        placeholderImage: UIImage(named: "user_dummy"),
                                        options: .highPriority,
                                        context: nil)
        
        self.titleLbl.text = self.providerDetailVC.serviceName
        if details.rating.isZero {
            self.ratingStack.isHidden = true
        }else{
            self.ratingStack.isHidden = false
            let textAtt = NSMutableAttributedString()
                .attributedString("★ ",
                                  foregroundColor: .ThemeYellow,
                                  fontWeight: .bold,
                                  fontSize: 14)
                .attributedString("\(details.rating)",
                                  foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                  fontWeight: .bold,
                                  fontSize: 14)
                .attributedString(" (\(details.ratingCount) \(LangHandy.reviews)) ",
                                  foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                  fontWeight: .regular,
                                  fontSize: 12)
            self.ratinglbl.attributedText = textAtt
            //            self.providerRatingStack.setRating(details.rating)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.providerProfileIV.clipsToBounds = true
            self.providerProfileIV.cornerRadius = 20
            self.providerProfileIV.contentMode = .scaleAspectFill
        }
        self.showHideBasket()
//        self.providerDescription.text = details.
    }
    func showHideBasket(){
        guard  let details = self.providerDetailVC.provider else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            if details.bookedItems.isEmpty {
                self.viewBasketView.transform = CGAffineTransform(translationX: 0,
                                                                  y: self.frame.height * 1.5)
            } else {
                self.viewBasketView.transform = .identity
            }
        }
        if details.bookedItems.isEmpty{
            self.viewBasketView.isHidden = true
            self.checkOutView.isHidden = true
            self.basketHight.constant = 0
            self.viewBasketView.layoutIfNeeded()
        }else{
            self.viewBasketView.isHidden = false
            self.checkOutView.isHidden = false
            self.basketHight.constant = UIDevice.current.hasNotch ? 129 : 95
            self.viewBasketView.layoutIfNeeded()
            self.itemCountLbl.text = details.cartTotalItemCount.description
            let cartTotalPriceStr = String(format: "%.2f", details.cartTotalPrice)
            self.totalPriceLbl.text = "\(UserDefaults.value(for: .user_currency_symbol_org) ?? "$")\(cartTotalPriceStr)"
        }
    }
    func setTo(content : ProfileCategories) {
        self.reviewTable.isHidden = true
        self.serviceTable.isHidden = true
        self.galleryCollectionView.isHidden = true
        self.serVicesBtn.alpha = self.currentTab == .services ? 1 : 0.5
        self.reviewsBtn.alpha = self.currentTab == .ratings ? 1 : 0.5
        self.galleryBtn.alpha = self.currentTab == .gallery ? 1 : 0.5
        switch content {
        case .services:
            self.serviceTable.isHidden = false
            self.serviceTable.reloadData()
            if isRTLLanguage {
                self.sliderView.transform = CGAffineTransform(translationX: -self.reviewsBtn.frame.minX,y: 0)
                self.parentScrollView.contentOffset = CGPoint(x: (self.galleryHolderView.frame.width * 2), y: 0)
            } else {
                self.parentScrollView.contentOffset = CGPoint(x: parentScrollView.frame.minX,
                                                              y: 0)
                self.sliderView.transform = .identity
            }
            
        case .gallery:
            self.galleryCollectionView.isHidden = false
            self.galleryCollectionView.reloadData()
            if isRTLLanguage {
                self.sliderView.transform = CGAffineTransform(translationX: -self.galleryBtn.frame.minX,
                                                              y: 0)
                self.parentScrollView.contentOffset = CGPoint(x: (self.galleryHolderView.frame.width * 1), y: 0)
            } else {
                self.parentScrollView.contentOffset = CGPoint(x: servicesHolderView.frame.maxX,
                                                              y: 0)
                self.sliderView.transform = CGAffineTransform(translationX: self.galleryBtn.frame.minX,
                                                              y: 0)
            }
        case .ratings:
            self.reviewTable.isHidden = false
            self.reviewTable.reloadData()
            if isRTLLanguage {
                self.sliderView.transform = CGAffineTransform(translationX: -self.serVicesBtn.frame.minX,
                                                              y: 0)
                self.parentScrollView.contentOffset = CGPoint(x: (self.parentScrollView.frame.minX), y: 0)
            } else {
                self.parentScrollView.contentOffset = CGPoint(x: galleryHolderView.frame.maxX,
                                                              y: 0)
                self.sliderView.transform = CGAffineTransform(translationX: self.reviewsBtn.frame.minX,
                                                              y: 0)
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.galleryCollectionView {
            self.galleryPagination()
        } else if scrollView == self.reviewTable {
            self.reviewPagination()
        }else if scrollView == self.parentScrollView{
            guard scrollView == self.parentScrollView else{return}
            
//            if isRTLLanguage{
//                self.sliderView
//                    .transform = CGAffineTransform(translationX: (scrollView
//                        .contentOffset.x / 3) - self.sliderView.frame.width ,
//                                                   y: 0)
//            }else{
//                self.sliderView
//                    .transform = CGAffineTransform(translationX: scrollView
//                        .contentOffset.x / 3,
//                                                   y: 0)
//            }
        }
    }
    
    
    func galleryPagination() {
        let visibleItemsAccesbiliryHint = galleryCollectionView.visibleCells.map({$0.accessibilityHint})
        let nextPage = self.galleryCurrentPage + 1
        if self.providerDetailVC.provider.galleryTotalPage != 1 && visibleItemsAccesbiliryHint.contains(self.providerDetailVC.provider.gallery.count.description)
            && oneTimeGalleryApiHitted {
            print("Gallery Table")
            // Page argument is Only Affecting Service
            self.providerDetailVC.getLoadMoredetails(catagoryType: .gallery, page: nextPage)
            self.oneTimeGalleryApiHitted = !self.oneTimeGalleryApiHitted
              
        }
    }
    
    func reviewPagination() {
        let cell = self.reviewTable.visibleCells.last
        let nextPage = self.reviewCurrentPage + 1
        if self.providerDetailVC.provider.userRatingTotalPage != 1 &&
            cell?.accessibilityHint == self.providerDetailVC.provider.reviews.count.description && oneTimeReviewApiHitted && !self.providerDetailVC.reviewBottomLoader.isAnimating{
            // Page argument is Only Affecting Service
            self.providerDetailVC.getLoadMoredetails(catagoryType: .ratings, page: nextPage)
            self.oneTimeReviewApiHitted = !self.oneTimeReviewApiHitted
        }
    }
    
    func showAlertBeforeExit(){
        self.providerDetailVC
            .presentAlertWithTitle(title: appName,
                                   message: LangHandy.itemsInYourCartWillBeDiscarded,
                                   options: "ð\(LangCommon.ok.capitalized)",LangCommon.cancel.capitalized) { (option) in
                                    if option == 0{
                                        self.providerDetailVC.exitScreen(animated: true)
                                    }
        }
    }
    func showAlertForChangingService(){
        self.providerDetailVC
            .presentAlertWithTitle(title: appName,
                                   message: LangHandy.youCanOnlyOneItemForThisServiceType,
                                   options: LangCommon.ok.capitalized) { (_) in}
    }
}
//MARK:- TableView DataSourece
extension HandyProviderDetailView : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case self.serviceTable:
            return self.providerDetailVC.provider.categories.count
        case self.reviewTable:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.serviceTable:
            tableView.backgroundView = nil
            if let isViewMoreNeedToShow = (self.providerDetailVC.provider.categories.value(atSafe: section)?.isViewMoreNeedToShow),isViewMoreNeedToShow {
                return (self.providerDetailVC.provider.categories.value(atSafe: section)?.serviceItems.count ?? 0) + 1
            } else {
                return self.providerDetailVC.provider.categories.value(atSafe: section)?.serviceItems.count ?? 0
            }
           
        case self.reviewTable:
            let count = self.providerDetailVC.provider.reviews.count
            if count == 0 && !Shared.instance.isLoading(in: self) && !self.providerDetailVC.reviewBottomLoader.isAnimating {
                let placeholderLbl = self.getPlaceholderLbl(for: tableView)
                placeholderLbl.text = LangCommon.noDataFound
                tableView.backgroundView = placeholderLbl
            }else{
                tableView.backgroundView = nil
            }
            return count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == self.serviceTable ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.serviceTable{
            
            let holderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: section == 0 ? 40 : 40))
            holderView.isClippedCorner = true
            //holderView.elevate(2)
            holderView.backgroundColor = self.backgroundColor
            let lbl = UILabel()
            //let Linelbl = UILabel()
            lbl.textColor = .PrimaryColor
            //Linelbl.backgroundColor = UIColor(hex: AppWebConstants.TertiaryColor)
            holderView.addSubview(lbl)
            //holderView.addSubview(Linelbl)
            lbl.anchor(toView: holderView,
                       leading: 8, trailing: 8, top: 2, bottom: 2)
            //Linelbl.anchor(toView: holderView,
             //              leading: 8, trailing: 8, top: nil, bottom: 0)
            //Linelbl.heightAnchor.constraint(equalToConstant: 1).isActive = true
            lbl.font = AppTheme.Fontbold(size: 15).font
           
                lbl.text = " \(self.providerDetailVC.provider.categories.value(atSafe: section)?.categoryName ?? "") "
            
            return holderView
        }else{
            return nil
        }
    }
    
 
    @objc
    func loadMoreBtnClicked(_ sender:String){
        let detailsArray = sender.components(separatedBy: ",")
        if let categoryID = Int(detailsArray.value(atSafe: 0) ?? "0"),
           let currenntPage = Int(detailsArray.value(atSafe: 1) ?? "0"),
           let totalPage = Int(detailsArray.value(atSafe: 2) ?? "0"),
           let remainingPage = Int(detailsArray.value(atSafe: 3) ?? "0") {
            print("ååå : categoryID : \(categoryID)  currenntPage: \(currenntPage) totalPage: \(totalPage) remainingPage: \(remainingPage)")
                if (remainingPage > 0) {
                    self.providerDetailVC.getLoadMoredetails(catagoryType: .services,catagoryID: categoryID, page: currenntPage + 1)
                } else {
                    self.serviceTable.reloadData()
                
                print("å::: \(categoryID)")
            }
        }
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.serviceTable:
            let cell : HandySubServiceTVC = tableView.dequeueReusableCell(for: indexPath)
            let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            
            if let category = self.providerDetailVC.provider.categories.value(atSafe: indexPath.section),
               let currentItem = category.serviceItems.value(atSafe: indexPath.row) {
                cell.lineLabel.backgroundColor = .TertiaryColor
                cell.lineLabel.isHidden = false
                
                if indexPath.row == totalRows - 1 {
                    cell.lineLabel.isHidden = true
                }
                
                // Forced RTL Changes Done By Karuppasamy
                    cell.nameLbl.setTextAlignment()
                    cell.descriptionLbl.setTextAlignment()
                
                //cell.setPosition(totalItems: category.serviceItems.count, forIndex: indexPath)
                cell.nameLbl.text = currentItem.itemName
                cell.descriptionLbl.text = currentItem.itemDescription
                
                var baseFareStr = ""
                if currentItem.baseFare > currentItem.minimumFare{
                    baseFareStr = String(format: "%.2f", currentItem.baseFare)
                }else{
                    baseFareStr = String(format: "%.2f", currentItem.minimumFare)
                }
                //  baseFareStr = String(format: "%.2f", currentItem.baseFare)
                
                /*
                 if currentItem.baseFare > currentItem.minimumFare{
                 let baseFareStr = String(format: "%.2f", currentItem.baseFare)
                 cell.priceLbl.text = "\(UserDefaults.value(for: .user_currency_symbol_org) ?? "$") \(baseFareStr)/\(currentItem.priceType.rawValue)"
                 
                 }else{
                 let baseFareStr = String(format: "%.2f", currentItem.minimumFare)
                 cell.priceLbl.text = "\(UserDefaults.value(for: .user_currency_symbol_org) ?? "$") \(baseFareStr)/\(currentItem.priceType.rawValue)"
                 }
                 */
                
                cell.priceLbl.text = "\(UserDefaults.value(for: .user_currency_symbol_org) ?? "$")\(baseFareStr)/\(currentItem.priceType.rawValue)"
                cell.bookBtnImg.image = currentItem.isSelected ? UIImage(named: "dlt")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "bookicon")?.withRenderingMode(.alwaysTemplate)
                cell.bookBtnImg.tintColor = .PrimaryTextColor
                cell.bookBtn.setTitle(currentItem.isSelected ? LangCommon.remove : LangHandy.book, for: .normal)
                cell.bookBtn.addAction(for: .tap) {
                    if currentItem.isSelected{
                        currentItem.isSelected = false
                        self.showHideBasket()
                        tableView.reloadData()
                    }else{
                        if let exisitingItem = self.providerDetailVC.provider.bookedItems.first,
                           !(exisitingItem.priceType == .fixed && currentItem.priceType == .fixed){
                            self.showAlertForChangingService()
                            return
                            
                        }
                        self.providerDetailVC.navigateToBookService(currentItem)
                    }
                }
                cell.ThemeUpdate()
                cell.nameLbl.font = AppTheme.Fontlight(size: 16).font
                return cell
            } else {
                let cell : LoadMoreTVC = tableView.dequeueReusableCell(for: indexPath)
                cell.loadMoreBtn.tag = indexPath.section
                cell.loadMoreBtn.setTitle(LangCommon.viewMore, for: .normal)
                cell.loadMoreBtn.isUserInteractionEnabled = false
                cell.bgView.isRoundCorner = true
                cell.bgView.elevate(2)
                cell.selectionStyle = .none
                cell.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
                cell.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
                cell.bgView.border(width: 0.5,
                                   color: UIColor.TertiaryColor.withAlphaComponent(0.1))
                return cell
            }
        
        case self.reviewTable:
            let cell : HandyUserProfileTVC = tableView.dequeueReusableCell(for: indexPath)
            guard let review = self.providerDetailVC.provider.reviews.value(atSafe: indexPath.row) else{
                return cell
            }
            cell.accessibilityHint = (indexPath.row + 1).description
            cell.nameLbl.text = review.userName
            let attrText = NSMutableAttributedString()
                .attributedString("★ ",
                                  foregroundColor: .ThemeYellow,
                                  fontWeight: .bold,
                                  fontSize: 14)
                .attributedString("\(review.rating)",
                                  foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                  fontWeight: .bold,
                                  fontSize: 14)
//            cell.ratingStack.setRating(review.rating)
            cell.ratingLbl.attributedText = attrText
            cell.profileIV.sd_setImage(with: URL(string: review.userImage),
                                       placeholderImage: UIImage(named: "user_dummy"),
                                       options: .highPriority,
                                       context: nil)
            cell.profileIV.isCurvedCorner = true
            
            if review.comments.count > 0 {
                cell.descriptionLbl.text = review.comments
                cell.descriptionLbl.isHidden = false
                cell.barView.isHidden = false
            } else {
                cell.descriptionLbl.text = ""
                cell.descriptionLbl.isHidden = true
                cell.barView.isHidden = true
            }
            cell.dropIV.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                cell.imageHolderView.isClippedCorner = true
                cell.imageHolderView.shadowColor = .clear
                cell.profileIV.contentMode = .scaleAspectFill
                cell.profileIV.clipsToBounds = true
            }
            cell.dropBtn.addAction(for: .tap) {
                if self.selectedRatingIndex != indexPath.row{
                    self.selectedRatingIndex = indexPath.row
                }else{
                    self.selectedRatingIndex = nil
                }
                tableView.reloadData()
            }
            cell.ThemeUpdate()
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableView {
        case self.serviceTable:
            guard let cell = cell as? HandySubServiceTVC,
                  let _ = self.providerDetailVC.provider.categories.value(atSafe: indexPath.section) else{return}
         
            cell.ThemeUpdate()
            //cell.setPosition(totalItems: category.serviceItems.count, forIndex: indexPath)
        case  self.reviewTable:
            guard let myCell = cell as? HandyUserProfileTVC else{return}
                myCell.ThemeUpdate()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                myCell.imageHolderView.isClippedCorner = true
                myCell.imageHolderView.shadowColor = .clear
                myCell.profileIV.contentMode = .scaleAspectFill
                myCell.profileIV.clipsToBounds = true
                myCell.profileIV.isCurvedCorner = true
            }
        default:break
            
        }
    }
    
    
}
//MARK:- TableView Delegate
extension HandyProviderDetailView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.serviceTable:
            return UITableView.automaticDimension
        case self.reviewTable:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tableView {
        case self.serviceTable:
            return UITableView.automaticDimension
        case self.reviewTable:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.serviceTable:
            
            if let category = self.providerDetailVC.provider.categories.value(atSafe: indexPath.section),
               let currentItem = category.serviceItems.value(atSafe: indexPath.row) {
                if !currentItem.isSelected,
                    let exisitingItem = self.providerDetailVC.provider.bookedItems.first,
                    !(exisitingItem.priceType == .fixed && currentItem.priceType == .fixed){
                    self.showAlertForChangingService()
                    return
                }
                self.providerDetailVC.navigateToBookService(currentItem)
            } else {
                let clickedCatagory = self.providerDetailVC.provider.categories.value(atSafe: indexPath.section)
                if let categoryID = clickedCatagory?.categoryID,
                   let currentPage = clickedCatagory?.currentPage,
                   let totalItemPage = clickedCatagory?.totalItemPage {
                    currentCategoryDetails = "\(categoryID),\(currentPage),\(totalItemPage),\(totalItemPage - currentPage)"
                    self.loadMoreBtnClicked(currentCategoryDetails)
                }
            }
            
//            guard let category = self.providerDetailVC.provider.categories.value(atSafe: indexPath.section),
//                let currentItem = category.serviceItems.value(atSafe: indexPath.row) else{
//                    return
//            }
//            if !currentItem.isSelected,
//                let exisitingItem = self.providerDetailVC.provider.bookedItems.first,
//                !(exisitingItem.priceType == .fixed && currentItem.priceType == .fixed){
//                self.showAlertForChangingService()
//                return
//
//            }
//
//            self.providerDetailVC.navigateToBookService(currentItem)
        case self.reviewTable:
            if self.selectedRatingIndex != indexPath.row{
                self.selectedRatingIndex = indexPath.row
            }else{
                self.selectedRatingIndex = nil
            }
            tableView.reloadData()
        default:break
        }
    }
}
//MARK:- Collection View DataSource
extension HandyProviderDetailView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.providerDetailVC.provider.gallery.count
        if self.providerDetailVC.provider.galleryTotalPage < 1 && self.remainingGalleryAPICount != 0{
            return count + 1
        }
        if count == 0 && !Shared.instance.isLoading(in: self) && !self.providerDetailVC.galleryBottomLoader.isAnimating {
            let placeholderLbl = self.getPlaceholderLbl(for: collectionView)
            placeholderLbl.text = LangCommon.noDataFound
            collectionView.backgroundView = placeholderLbl
        }else{
            collectionView.backgroundView = nil
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HandyGalleryCVC = collectionView.dequeueReusableCell(for: indexPath)
        guard let galleryItem = self.providerDetailVC.provider.gallery.value(atSafe: indexPath.row) else{
            let LoaderCell = UICollectionViewCell(frame: cell.frame)
            LoaderCell.backgroundColor = .green
            return cell
        }
        cell.accessibilityHint = (indexPath.row + 1).description
        cell.populate(with: galleryItem)
        cell.ThemeUpdate()
        return cell
    }
    
    
}
//MARK:- Collection View Delegate
extension HandyProviderDetailView : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HandyGalleryCVC else{
            return
        }
        cell.galleryIV.contentMode = .scaleToFill
        self.providerDetailVC
            .navigateToGalleryDetail(
                image: cell.galleryIV.image,
                from: cell.frame,
                with: self.providerDetailVC.provider.gallery.compactMap({$0.image}),
                selectedIndex: indexPath)
    }
}
//MARK:- CollectionView delegate flow layout
extension HandyProviderDetailView : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3.5
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.galleryTotalPage == self.galleryCurrentPage {
            return CGSize(width: collectionView.bounds.size.width, height: 0)
        }
        return CGSize(width: collectionView.bounds.size.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        let loader = UIView(frame: CGRect(x: self.frame.midX - 30, y: 0, width: self.frame.width - 30, height: 100))
        loader.addSubview(self.providerDetailVC.galleryBottomLoader)
        view.addSubview(loader)
        return view
    }
}
extension HandyProviderDetailView : UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.parentScrollView else{return}
        let currentX = scrollView.contentOffset.x
        let maxX = self.frame.width
        
        if isRTLLanguage{
            self.currentTab = currentX >= 2*maxX ? .services : currentX >= maxX ? .gallery : .ratings
        }else{
            self.currentTab = currentX >= 2*maxX ? .ratings : currentX >= maxX ? .gallery : .services
        }
    }
}

class footer : UICollectionReusableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        debug(print: "creating footer")
    }
}



extension UICollectionView {
    
    var isLastItemFullyVisible: Bool {
        return contentSize.width == contentOffset.x + frame.width - contentInset.right
    }
    
}
extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        return (keyWindow?.safeAreaInsets.bottom ?? 0) > 0
    }
}
