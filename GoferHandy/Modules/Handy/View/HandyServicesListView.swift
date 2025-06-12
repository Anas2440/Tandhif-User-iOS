//
//  ProvidedServiceListView.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyServicesListView: BaseView {
    
    var oneTimeForServiceCatagory : Bool = true
    var remaingCategoryListApi : Int = 0
    var currentPage : Int = 1
    var servicesListVC :  HandyServiceListVC!
    
    //MARK:- Outlets
    @IBOutlet weak var serviceListTable : CommonTableView!
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var nextBtn : PrimaryButton!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var topCurvedView: TopCurvedView!
//    @IBOutlet weak var addressDropDownIV : ThemeColorTintImageView!
//    @IBOutlet weak var locationLbl : InvertedHeaderLabel!
    //MARK:- Actions
    @IBAction
    override func backAction(_ sender : UIButton){
//        self.servicesListVC.popHandler?()
        super.backAction(sender)
        if let index = selectedServicesCart.firstIndex(where: {$0.service_id == self.servicesListVC.service.serviceID}) {
            selectedServicesCart[index].selectedCategories = self.servicesListVC.existingSelectedCategoryArray
        }
    }
    @IBAction
    func nextAction(_ sender : UIButton){
        guard self.servicesListVC.service.categories.anySatisfy({$0.isSelected}) else{
            AppUtilities().customCommonAlertView(titleString: appName,
                                                 messageString: LangCommon.pleaseSelectOption)
            return
        }
        self.servicesListVC.navigateToProvidersList()
    }
    //MAKR:- life cycle
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.servicesListVC = baseVC as? HandyServiceListVC
        self.serviceListTable.tableFooterView = self.servicesListVC.serviceListBottomLoader
        self.initView()
        self.ThemeChange()
        self.initLanguage()
    }
    func resetingModel() {
        self.servicesListVC.service.categories.removeAll()
        self.serviceListTable.reloadData()
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
    }
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
        self.checkStatus()
    }
    //MARK:- initializers
    
    func ThemeChange() {
        self.darkModeChange()
        self.titleLbl.customColorsUpdate()
        self.serviceListTable.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.topCurvedView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.nextBtn.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.serviceListTable.reloadData()
    }
    
    func initView(){
        self.nextBtn.backgroundColor = .TertiaryColor
        self.serviceListTable.delegate = self
        self.serviceListTable.dataSource = self
        self.serviceListTable.refreshControl = self.servicesListVC.serviceListRefresher
        
    }
    func initLanguage(){
//        self.locationLbl.text = self.servicesListVC.accountVM?.profileModel?.currentAddress
        self.titleLbl.text = self.servicesListVC.serviceName
        self.nextBtn.setTitle(LangCommon.save.capitalized, for: .normal)
    }
   
    //MARK:- UDF
    func checkStatus(){
        self.nextBtn.setMainActive(self.servicesListVC.service.categories.anySatisfy({$0.isSelected}))
    }
    
}

extension HandyServicesListView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.serviceListPaginationUpdate()
    }
    
    /// Pagination of the service Catagory
    func serviceListPaginationUpdate() {
        let cell = self.serviceListTable.visibleCells.last
        let nextPage = self.currentPage + 1
        if cell?.accessibilityHint == self.servicesListVC.service.categories.last?.categoryID.description
            && oneTimeForServiceCatagory
            && !self.servicesListVC.serviceListBottomLoader.isAnimating {
            
            self.servicesListVC.getMoreServiceCategories(param: [ "service_id" : self.servicesListVC.service.serviceID], currentPage: nextPage)
            self.oneTimeForServiceCatagory = !self.oneTimeForServiceCatagory
            
            debug(print: "å:: we reached the currentPage \(self.currentPage) last cell in serviceListTable")
        } else {
            if remaingCategoryListApi == 0 {
                debug(print: "å:: we reached the LastPage of TotalPages \(self.currentPage)")
            } else {
                debug(print: "å:: Waiting Time For the CurrentPage \(self.currentPage)")
            }
        }
    }
   
}

//MARK:- UITableViewDataSource
extension HandyServicesListView : UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.servicesListVC.service.categories.count
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HandyAddServiceTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let item = self.servicesListVC.service.categories.value(atSafe: indexPath.row) else{return cell}
        cell.populateCell(with: item)
        cell.addSerivceBtn.addAction(for: .tap) {
            item.isSelected = !item.isSelected
            if let index = selectedServicesCart.firstIndex(where: {$0.service_id==self.servicesListVC.service.serviceID}) {
                if selectedServicesCart[index].selectedCategories.contains(item) {
                    selectedServicesCart[index].selectedCategories.removeAll(where: {$0 == item})
                } else {
                    selectedServicesCart[index].selectedCategories.append(item)
                }
            }
            tableView.reloadData()
            self.checkStatus()
        }
        return cell
    }
    
    
}
//MARK:- UITableViewDelegate
extension HandyServicesListView : UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
