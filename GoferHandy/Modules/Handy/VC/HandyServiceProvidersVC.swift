//
//  HandyServiceProvidersVC.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
class HandyServiceProvidersVC: BaseViewController {
   
    @IBOutlet weak var serviceProvidersView : HandyServiceProvidersView!
    var service : Service!
    var bookingVM : HandyJobBookingVM?
    var accountVM : AccountViewModel?
    var providers = [Provider]()
    var providerMarkers = [GMSMarker]()
    var serviceName : String?
  var selectedFilter : FilterType = .distance{
        didSet{
            self.currentPageNumber = 1
            
        }
    }
    var currentPageNumber  = 1
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.serviceProvidersView.darkModeChange()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serviceProvidersView.ResetModel()
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK:- intiWithStory
    class func initWithStory(for service : Service,
                             usingBookingVM vm: HandyJobBookingVM?,
                             accountVM: AccountViewModel,serviceName : String) -> HandyServiceProvidersVC{
        let serviceProvider : HandyServiceProvidersVC = UIStoryboard.gojekHandyBooking.instantiateViewController()
        serviceProvider.service = service
        serviceProvider.serviceName = serviceName
        serviceProvider.bookingVM = vm
        serviceProvider.accountVM = accountVM
        return serviceProvider
    }

    func navigateToProviderDetail(for provider : Provider){
      self.navigationController?
        .pushViewController(HandyProviderDetailVC
            .initWithStory(for: service,
                           and: provider,
                           accountVM: self.accountVM!,
                           bookingVM: self.bookingVM!, serviceNAme: self.serviceName ?? ""),
                            animated: true)

        
    }
    
    lazy var providerListBottomLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    
    func getBottomLoader() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .PrimaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }
    
    @objc
    func onRefresh(_ sender : UIRefreshControl){
        self.serviceProvidersView.currentPage = 1
        self.serviceProvidersView.remainingProviderListApi = 0
        self.getAvailableProvidersList(providerCurrentPage: 1)
    }
    
    lazy var providerRefereshControl : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: LangCommon.pullToRefresh)
        refresher.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return refresher
    }()
    
    //MARK:- UDF
    func getAvailableProvidersList(providerCurrentPage: Int){
        if !self.providerRefereshControl.isRefreshing{
            self.providerListBottomLoader.startAnimating()
        }
        self.bookingVM?.wsToGetProviderListDetails(for: self.service,providerCurrentPage: providerCurrentPage, { (result) in
                if self.providerRefereshControl.isRefreshing{
                    self.serviceProvidersView.providersListTable.reloadData()
                    self.providerRefereshControl.endRefreshing()
                }
            
                switch result {
                case .success(let response):
                    
                    self.serviceProvidersView.currentPage = response.currentPage
                    self.serviceProvidersView.remainingProviderListApi = (response.totalPages - response.currentPage)
                    self.serviceProvidersView.oneTimeCompletedForProviderList = ((response.totalPages - response.currentPage) != 0)
                    
                    if response.currentPage == 1 || response.currentPage == 0 {
                        self.providers.removeAll()
                        self.providers = response.providers
                    } else {
                        self.providers.append(contentsOf: response.providers)
                    }
                    
                    self.providerListBottomLoader.stopAnimating()
                    self.sortItem(basedOn: self.selectedFilter)
                case .failure(let error):
                    self.providers.removeAll()
                    self.providerListBottomLoader.stopAnimating()
                    AppUtilities()
                        .customCommonAlertView(titleString: appName,
                                               messageString: error.localizedDescription)
                    self.sortItem(basedOn: self.selectedFilter)
                }
        })
            self.serviceProvidersView.providersListTable.reloadData()
    }
    func sortItem(basedOn type : FilterType ){
        
        switch type {
        case .name:
            self.providers = self.providers.sorted(by: { (p1, p2) -> Bool in
                return p1.firstName.capitalized < p2.firstName.capitalized
            })
            self.serviceProvidersView.filterNameLbl.text = LangCommon.aToZ
        case .rating:
            
            self.providers = self.providers.sorted(by: { (p1, p2) -> Bool in
                return p1.rating > p2.rating
            })
            self.serviceProvidersView.filterNameLbl.text = LangCommon.ratingStatus
        case .distance:
            
            self.providers = self.providers.sorted(by: { (p1, p2) -> Bool in
                return p1.distance < p2.distance
            })
            self.serviceProvidersView.filterNameLbl.text = LangCommon.km
        }
        self.serviceProvidersView.providersListTable.reloadData()
    }
    func setMarker() {
        self.providerMarkers.forEach({
            let iconView = $0.iconView
            iconView?.tag = 0
            $0.iconView = nil
            $0.map = nil
            
        })
        self.providerMarkers.removeAll()
        var bounds = GMSCoordinateBounds()
        DispatchQueue.main.async {
        for provider in self.providers{
            let marker = GMSMarker(position: provider.location.coordinate)
            let view = ProviderMarkerView
                .getCarView(forProvider: provider,
                         using: CGRect(x: 0,
                                       y: 0,
                                       width: 40,
                                       height: 40))
            //view.elevate(1)

            marker.iconView = view
            if provider == self.serviceProvidersView.mapSelectedProvider{
                marker.zIndex = 2
            }else{
                marker.zIndex = 1
            }
            view.tag = provider.providerID
            marker.map = self.serviceProvidersView.mapView
            

           bounds = bounds.includingCoordinate(marker.position)
            self.providerMarkers.append(marker)
        }
            if let minProvider = self.providers.sorted(by: {$0.distance < $1.distance}).first,
               let maxProvider = self.providers.sorted(by: {$0.distance > $1.distance}).first {
                let firstProvider = CLLocationCoordinate2D(latitude: minProvider.latitude,
                                                           longitude: minProvider.longitude)
                let lastProvider = CLLocationCoordinate2D(latitude: maxProvider.latitude,
                                                            longitude: maxProvider.longitude)
                let bounds = GMSCoordinateBounds(coordinate: firstProvider,
                                                 coordinate: lastProvider)
                let camera = self.serviceProvidersView.mapView.camera(for: bounds,
                                                                         insets: UIEdgeInsets(top: 100,
                                                                                              left: 100,
                                                                                              bottom: 100,
                                                                                              right: 100))!
                self.serviceProvidersView.mapView.camera = camera
            }
            
            
//        if let firstProvider = self.providers.sorted(by: {$0.distance < $1.distance}).first{
//            let camera = GMSCameraPosition(target: firstProvider.location.coordinate,
//                                           zoom: 14,
//                                           bearing: 0,
//                                           viewingAngle: 0)
//
//
//            self.serviceProvidersView.mapView.moveCamera(GMSCameraUpdate.setCamera(camera))
//        }
//        GMSCameraUpdate.setTarget(<#T##target: CLLocationCoordinate2D##CLLocationCoordinate2D#>, zoom: <#T##Float#>)
//        let update = GMSCameraUpdate.fit(bounds, withPadding:1000)
//        self.serviceProvidersView.mapView.animate(with: update)
        }
        
    }
}
