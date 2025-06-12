//
//  HandyServiceProvidersView.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import GoogleMaps

class HandyServiceProvidersView: BaseView {
    enum ViewOptions{
        case list,map
    }
    
    var oneTimeCompletedForProviderList: Bool = true
    var serviceProviderVC :  HandyServiceProvidersVC!
    
    //MARK:- Outlets
    @IBOutlet weak var providersListTable : CommonTableView!
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    
    @IBOutlet weak var switchView : SecondaryView!
    
    @IBOutlet weak var mapSwithView : SecondaryInvertedView!
    //@IBOutlet weak var mapNameLbl : SubHeaderLabel!
    @IBOutlet weak var mapSwitchIV : SecondaryImageView!
    @IBOutlet weak var listSwitchView : SecondaryInvertedView!
    //@IBOutlet weak var listNameLbl : SubHeaderLabel!
    @IBOutlet weak var listSwitchIV : SecondaryImageView!
    
    @IBOutlet weak var filterView : UIView!
    @IBOutlet weak var filterNameLbl : UILabel!
    @IBOutlet weak var filterIconIV : UIImageView!
    
    @IBOutlet weak var providerView : SecondaryView!
    @IBOutlet weak var providerProfileIV : UIImageView!
    @IBOutlet weak var providerNameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var providerKilometerLbl : SecondaryRegularLabel!
    @IBOutlet weak var providerRatingValueLbl : UILabel!
    @IBOutlet weak var providerRatingStack : StarStackView!
    @IBOutlet weak var providerMoreInfoBtn : TeritaryButton!
    
    @IBOutlet weak var sortingView : UIView!
    @IBOutlet weak var sortingLbl : SecondaryHeaderLabel!
    @IBOutlet weak var sortCloseBtn : PrimaryTextButton!
    @IBOutlet weak var sortNameBtn : SecondaryButton!
    @IBOutlet weak var sortRatingBtn : SecondaryButton!
    @IBOutlet weak var optionsBGView: SecondaryView!
    @IBOutlet weak var sortDistanceBtn : SecondaryButton!
    @IBOutlet weak var providerBGView : SecondaryView!
    @IBOutlet weak var topCurvedView: TopCurvedView!
    @IBOutlet weak var innerCurvedView: TopCurvedView!
    @IBOutlet weak var sortOptionsBGView : TopCurvedView!
    
    var remainingProviderListApi : Int = 0
    var currentPage : Int = 1
    
    
    override func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backBtn?.tintColor =  self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        super.darkModeChange()
        self.filterView.backgroundColor = .SecondaryColor
        self.filterIconIV.tintColor = .LightModeTextColor
        self.filterNameLbl.textColor = .SecondaryTextColor
        self.filterNameLbl.font = AppTheme.Fontlight(size: 14).font
        self.topCurvedView.customColorsUpdate()
        self.innerCurvedView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.CheckBackgroundColor(isMap: currentlyViewing == .some(.map))
        self.switchView.customColorsUpdate()
        self.providersListTable.customColorsUpdate()
        self.providerBGView.customColorsUpdate()
        self.providerView.customColorsUpdate()
        self.providerNameLbl.customColorsUpdate()
        self.providerKilometerLbl.customColorsUpdate()
        self.sortingLbl.customColorsUpdate()
        self.sortCloseBtn.customColorsUpdate()
        self.sortNameBtn.customColorsUpdate()
        self.optionsBGView.customColorsUpdate()
        self.sortRatingBtn.customColorsUpdate()
        self.sortDistanceBtn.customColorsUpdate()
        self.sortOptionsBGView.customColorsUpdate()
        self.onChangeMapStyle()
        self.providersListTable.reloadData()
        
    }
    func onChangeMapStyle() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate at zoom level 6.
        // googleMapView.setMinZoom(15.0, maxZoom: 55.0)
        let camera = GMSCameraPosition.camera(withLatitude: 9.917703, longitude: 78.138299, zoom: 4.0)
        GMSMapView.map(withFrame: mapView.frame, camera: camera)
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: self.isDarkStyle ? "map_style_dark" : "mapStyleChanged", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
            }
        } catch {
        }
    }
    //MARK:- Actions
    @IBAction
    override func backAction(_ sender : UIButton?){
        self.serviceProviderVC.exitScreen(animated: true)
    }
    @IBAction
    func sortingAction(_ sender : UIButton){
        switch sender {
        case self.sortCloseBtn:
            break
        case self.sortNameBtn:
            self.serviceProviderVC.sortItem(basedOn: .name)
        case self.sortRatingBtn:
            self.serviceProviderVC.sortItem(basedOn: .rating)
        case self.sortDistanceBtn:
            self.serviceProviderVC.sortItem(basedOn: .distance)
        default:
            break
        }

        UIView.animate(withDuration: 0.6) {
            self.translateSortingView(show: false)
        }
    }
    @objc
    func moreinfoBtnPressed(_ sender : UIButton) {
        print(sender.tag)
        let provider = self.serviceProviderVC.providers.filter({$0.providerID == sender.tag}).first
        if let provider = provider {
            self.serviceProviderVC.navigateToProviderDetail(for: provider)
        }
        
    }
   
    //MARK:- Variables
    var currentlyViewing : ViewOptions? = nil
    
    
   
    
    lazy var mapView : GMSMapView  = {
        let map = GMSMapView(frame: self.providersListTable.bounds)
        map.delegate = self
        return map
        
    }()
    var mapSelectedProvider : Provider? = nil
    
    //MAKR:- life cycle
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.serviceProviderVC = baseVC as? HandyServiceProvidersVC
        self.providersListTable.tableFooterView = self.serviceProviderVC.providerListBottomLoader
        self.initView()
        self.switchView.elevate(2.5)
        self.initLanguage()
        self.initGestures()
        self.darkModeChange()
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.setCurrentViewing(to: self.currentlyViewing ?? .list)
    }
    
    func ResetModel() {
        self.serviceProviderVC.providers.removeAll()
        self.providersListTable.reloadData()
        self.currentPage = 1
        self.remainingProviderListApi = 0
        self.serviceProviderVC.getAvailableProvidersList(providerCurrentPage: 1)
    }
    
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    
    //MARK:- initializers
    
    func initView(){
        self.providerBGView.cornerRadius = 19
        self.providerBGView.elevate(2)
        self.providerMoreInfoBtn.cornerRadius = 10
        self.providerProfileIV.cornerRadius = 12
        self.filterNameLbl.text = LangCommon.km
        self.providerMoreInfoBtn.setTitle(LangCommon.moreInfo,
                                          for: .normal)
        self.providerMoreInfoBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.titleLbl.setTextAlignment()
        self.sortingLbl.setTextAlignment()
        self.providersListTable.registerNib(forCell: HandyProviderProfileTVC.self)
        // Sort Name Fuction
        self.sortNameBtn.isHidden = true
        self.providersListTable.setSpecificCornersForTop(cornerRadius: 40)
        self.providersListTable.delegate = self
        self.providersListTable.dataSource = self
        self.addSubview(self.providerView)
        self.providerView.anchor(toView: self,
                                 leading: 0,
                                 trailing: 0,
                                 bottom: 0)
        self.providerView.layoutIfNeeded()
        self.bringSubviewToFront(self.providerView)
        self.translateProviderView(show: false)
        
        
        self.addSubview(self.sortingView)
        self.sortingView.anchor(toView: self,
                                 leading: 0,
                                 trailing: 0,
                                 top : 0,
                                 bottom: 0)
        self.bringSubviewToFront(self.sortingView)
        self.translateSortingView(show: false)
        
        //Refresh contoller
        if #available(iOS 10.0, *) {
            self.providersListTable.refreshControl = self.serviceProviderVC.providerRefereshControl
        } else {
            self.providersListTable.addSubview(self.serviceProviderVC.providerRefereshControl)
        }
        
        self.providerMoreInfoBtn.isUserInteractionEnabled = true
    }
    
    
    
    func initLanguage(){
        self.titleLbl.text = self.serviceProviderVC.serviceName
        self.sortingLbl.text = LangCommon.sorting.capitalized
        self.sortCloseBtn.setTitle(LangCommon.close.capitalized, for: .normal)
        self.sortRatingBtn.setTitle(LangCommon.ratingStatus.capitalized, for: .normal)
        self.sortNameBtn.setTitle(LangHandy.sortName.capitalized, for: .normal)
        self.sortDistanceBtn.setTitle(LangHandy.sortDistance.capitalized, for: .normal)
        self.filterIconIV.transform = isRTLLanguage ? CGAffineTransform(scaleX: -1, y: 1) : .identity
    }
    func initGestures(){
        self.mapSwithView.addAction(for: .tap) {
            self.setCurrentViewing(to: .map)
        }
        self.listSwitchView.addAction(for: .tap) {
            self.setCurrentViewing(to: .list)
        }
        self.providerView.addAction(for: .tap) {
            guard let selectedProvider = self.mapSelectedProvider else{
                return
            }
            self.serviceProviderVC.navigateToProviderDetail(for: selectedProvider)
        }
        self.filterView.addAction(for: .tap) {
            UIView.animate(withDuration: 0.6) {
                self.translateSortingView(show: true)
            }
        }
    }
    //MARK:- UDF
    func showBookingView(for provider : Provider){
        UIView.animate(withDuration: 0.15,
                       animations: {
                        self.serviceProviderVC.setMarker()
                        self.darkModeChange()
                        self.translateProviderView(show: true)
        }) { (completed) in
            guard completed else{return}
            self.populate(with: provider)
            UIView.animate(withDuration: 0.45) {
                self.translateProviderView(show: true)
            }
        }
    }
    fileprivate func populate(with provider : Provider){
        self.darkModeChange()
        // For Forced RTl Changes
        self.providerNameLbl.setTextAlignment()
        self.providerKilometerLbl.setTextAlignment()
        self.providerProfileIV.sd_setImage(with: URL(string: provider.profilePicture),
                                        placeholderImage: UIImage(named: "user_dummy"),
                                        options: .highPriority,
                                        context: nil)
        self.providerNameLbl.text = provider.name
        self.providerRatingValueLbl.text = provider.rating.description
        self.providerNameLbl.numberOfLines = 2
        self.providerMoreInfoBtn.tag = provider.providerID
//        self.providerNameLbl.adjustsFontSizeToFitWidth = true
        self.providerMoreInfoBtn.addTarget(self, action: #selector(moreinfoBtnPressed(_:)), for: .touchUpInside)
        self.providerMoreInfoBtn.customColorsUpdated()
        self.providerMoreInfoBtn.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.2)
        self.providerKilometerLbl.text = provider.distance < 1 ? LangCommon.lessThanAkm : provider.distance.description + " " + LangHandy.kilometerAway
        self.providerKilometerLbl.adjustsFontSizeToFitWidth = true
        self.providerRatingStack.setRating(provider.rating)
        self.providerRatingStack.isHidden = true
        let textAtt = NSMutableAttributedString()
            .attributedString("★ ",
                              foregroundColor: .ThemeYellow,
                              fontWeight: .bold,
                              fontSize: 14)
            .attributedString("\(provider.rating)",
                              foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                              fontWeight: .bold,
                              fontSize: 14)
            .attributedString(" (\(provider.ratingCount) \(LangHandy.reviews)) ",
                              foregroundColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                              fontWeight: .regular,
                              fontSize: 12)
        self.providerRatingValueLbl.attributedText = textAtt
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.providerProfileIV.isClippedCorner = true
            self.providerProfileIV.clipsToBounds = true
            self.providerProfileIV.contentMode = .scaleAspectFill
        }
    }
    ///animate provider view
    func translateProviderView(show : Bool){
        if show{
            self.providerView.transform = .identity
        }else{
            self.providerView.transform = CGAffineTransform(
                translationX: 0,
                y: self.frame.height * 1.5)
        }
    }
    ///animate sorting view
    func translateSortingView(show : Bool){
        if show{
            self.sortingView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            self.sortingView.transform = .identity
        }else{
            self.sortingView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.sortingView.transform = CGAffineTransform(translationX: 0,
                                                                   y: self.bounds.height)
         
        }
    }
    ///set currently viewing to (map / list) view
    func setCurrentViewing(to state : ViewOptions){
        guard self.currentlyViewing != state else{return}
        self.translateProviderView(show: false)
        self.translateSortingView(show: false)
        self.currentlyViewing = state
        
            
        self.CheckBackgroundColor(isMap: state == .map)
                switch state{
                case .map:
                    self.serviceProviderVC.setMarker()
                    self.filterView.isHidden = true
                case .list:
                    self.filterView.isHidden = false
                }
            self.providersListTable.reloadData()
        
    }
    
    func CheckBackgroundColor(isMap : Bool) {
        self.mapSwithView.border(width: 1,
                                 color: self.isDarkStyle ? .clear : .SecondaryColor)
        self.listSwitchView.border(width: 1,
                                   color: self.isDarkStyle ? .clear : .SecondaryColor)
        if isMap {
            self.mapSwithView.backgroundColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            self.listSwitchView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.mapSwitchIV.tintColor =  self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.listSwitchIV.tintColor =  self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        }else{
            self.mapSwitchIV.tintColor =  self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            self.listSwitchIV.tintColor =  self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.mapSwithView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.listSwitchView.backgroundColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        }
    }
}
//MARK:- UITableViewDataSource
extension HandyServiceProvidersView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count : Int
        self.filterView.alpha = 1
        self.filterView.isUserInteractionEnabled = true
        self.switchView.alpha = 1
        self.switchView.isUserInteractionEnabled = true
        if  self.currentlyViewing == .list{
            count = self.serviceProviderVC.providers.count
            if count == 0 && !Shared.instance.isLoading(in: self) && !self.serviceProviderVC.providerListBottomLoader.isAnimating {
                let placeholderLbl = self.getPlaceholderLbl(for: tableView)
                placeholderLbl.text = LangCommon.noDataFound
                tableView.backgroundView = placeholderLbl
                self.filterView.alpha = 0.5
                self.filterView.isUserInteractionEnabled = false
                self.switchView.alpha = 0.5
                self.switchView.isUserInteractionEnabled = false
            }else {
                tableView.backgroundView = nil
            }
        }else{
            count = 0
            tableView.backgroundView = self.mapView
          
        }
        return count
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.ProviderListPagination()
    }
    
    func ProviderListPagination() {
        
        let cell = self.providersListTable.visibleCells.last
        let nextPage = self.currentPage + 1
        
        if cell?.accessibilityHint == self.serviceProviderVC.providers.last?.providerID.description
            && oneTimeCompletedForProviderList
            && !self.serviceProviderVC.providerListBottomLoader.isAnimating {
            
            self.serviceProviderVC.getAvailableProvidersList(providerCurrentPage: nextPage)
            self.oneTimeCompletedForProviderList = !self.oneTimeCompletedForProviderList
            
            debug(print: "å:: we reached the currentPage \(self.currentPage) last cell in providersListTable")
            
        } else {
            if self.remainingProviderListApi == 0 {
                debug(print: "å:: we reached the LastPage of TotalPages \(self.currentPage)")
            } else {
                debug(print: "å:: Waiting Time For the CurrentPage \(self.currentPage)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : HandyProviderProfileTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let provider = self.serviceProviderVC.providers.value(atSafe: indexPath.row) else{
            return cell
        }
        cell.accessibilityHint = provider.providerID.description
        cell.populate(with: provider)
        cell.moreInfoBtn.isUserInteractionEnabled = true
        cell.moreInfoBtn.tag = provider.providerID
        cell.moreInfoBtn.addTarget(self, action: #selector(moreinfoBtnPressed(_:)), for: .touchUpInside)
        cell.ThemeUpdate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}
//MARK:- UITableViewDelegate
extension HandyServiceProvidersView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let provider = self.serviceProviderVC.providers.value(atSafe: indexPath.row) else{
            return
        }
        self.serviceProviderVC.navigateToProviderDetail(for: provider)
        self.layoutIfNeeded()
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.currentlyViewing == .some(.map){
            self.innerCurvedView.customColorsUpdate()
            self.providersListTable.setSpecificCornersForTop(cornerRadius: 40)
            return 0
        }else{
            self.innerCurvedView.removeSpecificCorner()
            self.providersListTable.removeSpecificCorner()
            return 0
        }
       
    }
}
//MARK:- GMSMapViewDelegate
extension HandyServiceProvidersView : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let tag = marker.iconView?.tag,
              let provider = self.serviceProviderVC.providers.filter({$0.providerID == tag}).first else{return false}
        self.mapSelectedProvider = provider
        self.showBookingView(for: provider)
        DispatchQueue.main.async {
            mapView.animate(toLocation: provider.location.coordinate)
            var zoom = mapView.camera.zoom
            if zoom < 14 {zoom = 14}
            let camera = GMSCameraPosition(target: provider.location.coordinate,
                                           zoom: zoom,
                                           bearing: 0,
                                           viewingAngle: 0)
            mapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            
        }
        return true
    }
}
extension UITableView{
    func removeSpecificCorner(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = [] //
    }
}
