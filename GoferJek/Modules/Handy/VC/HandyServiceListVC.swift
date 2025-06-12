//
//  ProvidedServiceListVC.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyServiceListVC: BaseViewController {
    
    
    @IBOutlet weak var servicesListView : HandyServicesListView!
    var service : Service!
    var bookingVM : HandyJobBookingVM?
    var accountVM : AccountViewModel?
    var popHandler: (() -> Void)? = nil
    var serviceName : String?
    var selectedCategoryArray : [String] = []
    var existingSelectedCategoryArray : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.servicesListView.resetingModel()
        self.getMoreServiceCategories(param: [ "service_id" : self.service.serviceID], currentPage: 1)
        // Do any additional setup after loading the view.
        if let index = selectedServicesCart.firstIndex(where: {$0.service_id == self.service.serviceID}) {
            self.existingSelectedCategoryArray = selectedServicesCart[index].selectedCategories
        }
    }
    override func willExitFromScreen() {
        super.willExitFromScreen()
//        self.service.categories.forEach({$0.isSelected = false})
    }
    func getBottomLoader() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .PrimaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }
    
    //MARK:- intiWithStory
    class func initWithStory(for service : Service,
                             usingBookingVM vm: HandyJobBookingVM,
                             andAccount accountVM : AccountViewModel,
                             serviceName : String) -> HandyServiceListVC{
        let handyServiceListVC : HandyServiceListVC = UIStoryboard.gojekHandyBooking.instantiateViewController()
        handyServiceListVC.serviceName = serviceName
        handyServiceListVC.service = service
        handyServiceListVC.bookingVM = vm
        handyServiceListVC.accountVM = accountVM
        return handyServiceListVC
    }
    
    func navigateToProviderDetail(to provider : Provider){
        self.navigationController?
            .pushViewController(HandyProviderDetailVC
                .initWithStory(for: service,
                               and: provider,
                               accountVM: accountVM!,
                               bookingVM: self.bookingVM!, serviceNAme: self.serviceName ?? ""),
                                animated: true)
        
    }
    
    var serviceListHitCount : Int = 0
    
    //MARK:- Refreshers
    lazy var serviceListRefresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
    
    lazy var serviceListBottomLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    
    func getRefreshController() -> UIRefreshControl{
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: LangCommon.pullToRefresh)
        refresher.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return refresher
    }
    @objc func onRefresh(_ sender : UIRefreshControl){
            self.servicesListView.currentPage = 1
            self.servicesListView.remaingCategoryListApi = 0
            self.getMoreServiceCategories(param: [ "service_id" : self.service.serviceID], currentPage: 1)
            self.service.categories.removeAll()
            self.servicesListView.serviceListTable.reloadData()
            
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.servicesListView.ThemeChange()
    }
    
    func getMoreServiceCategories(param : JSON,currentPage: Int) {
        
        
        self.serviceListBottomLoader.startAnimating()
        self.bookingVM?.getService(currentPage: currentPage, params: param, { (response) in
            switch response {
            case .success(let Service):
                if self.serviceListRefresher.isRefreshing{
                    self.servicesListView.serviceListTable.reloadData()
                    self.serviceListRefresher.endRefreshing()
                }
                self.servicesListView.remaingCategoryListApi = (Service.totalPages - Service.currentPage)
                self.servicesListView.oneTimeForServiceCatagory = ((Service.totalPages - Service.currentPage) != 0)
                self.servicesListView.currentPage = Service.currentPage
                if Service.currentPage == 1 {
                    self.saveLastSelectedItems()
                    self.service.categories.removeAll()
                    self.service = Service
                    self.reselectTheCategries()
                } else {
                    self.service.categories.append(contentsOf: Service.categories)
                }
                    selectedServicesCart.forEach({ service in
                        if self.service.serviceID == service.service_id {
                            for selectedCategory in service.selectedCategories {
                                if let index = self.service.categories.firstIndex(where: {$0.categoryID == selectedCategory.categoryID}) {
                                    self.service.categories[index].isSelected = true
                                }
                            }
                        }
                    })
                self.serviceListBottomLoader.stopAnimating()
                self.servicesListView.serviceListTable.reloadData()
                self.servicesListView.checkStatus()
            case .failure(_):
                self.serviceListBottomLoader.stopAnimating()
                self.serviceListRefresher.endRefreshing()
            }
        })
    }
    func reselectTheCategries() {
        if self.selectedCategoryArray != [] {
            for categoryID in self.selectedCategoryArray {
                self.service.categories.forEach { (category) in
                    if category.categoryID.description == categoryID {
                        category.isSelected = true
                    }
                }
            }
        }
    }
    func saveLastSelectedItems() {
        self.selectedCategoryArray =  self.service.categories.filter({$0.isSelected}).map({$0.categoryID.description})
        print("ååå : \(selectedCategoryArray)")
    }
    
    func navigateToProvidersList(){
        self.navigationController?.popViewController(animated: true)
        self.popHandler?()
        self.popHandler = nil
        
//        self.navigationController?.pushViewController(HandyServiceProvidersVC
//            .initWithStory(for: self.service,
//                           usingBookingVM: self.bookingVM,
//                           accountVM: self.accountVM!,serviceName: serviceName ?? ""),
//                                                      animated: true)
    }
}
