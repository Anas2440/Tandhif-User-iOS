//
//  HandyProviderDetailVC.swift
//  GoferHandy
//
//  Created by trioangle on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyProviderDetailVC: BaseViewController {
    
    @IBOutlet weak var providerDetailView : HandyProviderDetailView!
    
    var service : Service!
    var serviceName : String?
    var provider : Provider!
    var accountVM : AccountViewModel?
    var bookingVM : HandyJobBookingVM?
    var distanceBetweenUserAndProvider : Double?
    var cat_ids: [Int] = []

    override var stopSwipeExitFromThisScreen: Bool?{
        return self.provider.bookedItems.isNotEmpty
    }
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !provider.categories.isEmpty{
            self.providerDetailView.setProvider(details: provider)
            self.providerDetailView.setTo(content: .services)
        }else{
            self.providerDetailView.resetModel()
            self.wsToGetProviderDetail()
        }
    }
    
    
    //MARK:- intiWithStory
    class func initWithStory(for service : Service? = nil,
                             and provider : Provider,
                             accountVM : AccountViewModel? = nil,
                             bookingVM : HandyJobBookingVM? = nil,
                             serviceNAme:String? = nil,
                             cat_ids: [Int]? = nil) -> HandyProviderDetailVC{
        let providerVC : HandyProviderDetailVC =  UIStoryboard.gojekHandyBooking.instantiateViewController()
        providerVC.distanceBetweenUserAndProvider = provider.distance
        providerVC.service = service
        providerVC.provider = provider
        providerVC.bookingVM = bookingVM
        providerVC.accountVM = accountVM
        providerVC.serviceName = serviceNAme
        providerVC.cat_ids = cat_ids ?? []
        return providerVC
    }
    
    lazy var galleryBottomLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    
    lazy var reviewBottomLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    
    lazy var servicesBottomLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    
    func getBottomLoader() -> UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .PrimaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }
    
    func getLoadMoredetails(catagoryType: ProfileCategories,catagoryID : Int? = nil,page : Int) {
        
        var param = JSON()
        if let catagoryID = catagoryID {
            param["category_id"] = catagoryID
        }
        param["provider_id"] = provider.providerID
        param["type"] = catagoryType.key
        
        
        switch catagoryType {
        
        case .services:
            self.servicesBottomLoader.startAnimating()
        case .gallery:
            self.galleryBottomLoader.startAnimating()
        case .ratings:
            self.reviewBottomLoader.startAnimating()
        }
        
        
        
        self.bookingVM?.getMoreDetails(userServicePageCount: page, param: param, type: catagoryType,{ (response) in
            
            switch response {
            case .success(let result):
                switch catagoryType {
                case .services:
                    self.providerDetailView.oneTimeServicesApiHitted = !(result.totalItemPage == result.currentPage)
                    if let currentCat  = self.provider.categories.filter({$0.categoryID == catagoryID }).first {
                        currentCat.currentPage = result.currentPage
                        currentCat.isViewMoreNeedToShow = ((result.totalItemPage - result.currentPage) != 0) && ((result.totalItemPage - result.currentPage) > 0)
                    }
                    if let catagoryID = catagoryID {
                        self.provider.categories.filter({$0.categoryID == catagoryID }).first?.serviceItems.append(contentsOf: result.categories.first!.serviceItems)
                    }
                    self.servicesBottomLoader.stopAnimating()
                    self.providerDetailView.serviceTable.reloadData()
                case .gallery:
                    self.providerDetailView.galleryCurrentPage = result.currentPage
                    self.providerDetailView.remainingGalleryAPICount = result.galleryTotalPage - result.currentPage
                    self.providerDetailView.galleryTotalPage = result.galleryTotalPage
                    self.providerDetailView.oneTimeGalleryApiHitted = ((result.galleryTotalPage - result.currentPage) != 0)
                    self.provider.gallery.append(contentsOf: result.gallery)
                    self.galleryBottomLoader.stopAnimating()
                    self.providerDetailView.galleryCollectionView.reloadData()
                case .ratings:
                    self.providerDetailView.reviewCurrentPage = result.currentPage
                    self.providerDetailView.remainingReviewAPICount = result.userRatingTotalPage - result.currentPage
                    self.providerDetailView.oneTimeReviewApiHitted = ((result.userRatingTotalPage - result.currentPage) != 0)
                    if result.userRatingTotalPage >= result.userRatingCurrentPage {
                        self.provider.reviews.append(contentsOf: result.reviews)
                    }
                    self.reviewBottomLoader.stopAnimating()
                    self.providerDetailView.reviewTable.reloadData()
                }
            case .failure(_):
                print("Error")
            }
            
        })
        self.galleryBottomLoader.startAnimating()
    }
    
    
    func navigateToBookService(_ serviceItem: ServiceItem) {
        self.navigationController?
            .pushViewController(HandyBookServiceVC.initWithStory(serviceItem),
                                                        animated: true)
      }
      func navigateToCheckOut() {
          self.navigationController?
            .pushViewController(
                HandyCheckOutBookingVC.initWithStory(for: self.provider,
                                                     distanceBetweenUserAndProvider: self.distanceBetweenUserAndProvider,
                                                     accountVM: self.accountVM!,
                                                     bookingVM: self.bookingVM!),
                animated: true)
        }
    //MARK:- wsto get provider detail
    func wsToGetProviderDetail(){
        self.bookingVM?
            .wsToGetProviderDetail(
                using: self.provider,
                with: self.cat_ids,
                { (result) in
                    switch result{
                    case .success(let response):
                        self.provider = response.provider
                        self.providerDetailView.setProvider(details: self.provider)
                        self.providerDetailView.setTo(content: .services)
                    case .failure(let error):
                    AppUtilities()
                        .customCommonAlertView(titleString: appName,
                                               messageString: error.localizedDescription)
                    }
            })
            self.providerDetailView.setTo(content: .services)
    }
}

// Serivice Splitup Start
extension HandyProviderDetailVC : NavigateGalleryItemProtocol{
    func navigateToGalleryDetail(image: UIImage?,
                                 from frame: CGRect,
                                 with snaps: [String],
                                 selectedIndex: IndexPath) {
        let actualFrame = self.providerDetailView.galleryCollectionView.convert(frame,
                                                                                to: self.view)
        let vc = HandyGalleryDetailVC.initWithStory(fromFrame: actualFrame,
                                                    image : image,
                                                    withItem: snaps,
                                                    selectedIndex: selectedIndex)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc,
                     animated: false,
                     completion: nil)
    }
}
// Serivice Splitup End
