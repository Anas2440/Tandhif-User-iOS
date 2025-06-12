//
//  HandyBookedServicesView.swift
//  GoferHandy
//
//  Created by trioangle on 01/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyBookedServicesView: BaseView {
    
    
    var bookedServicesVC : HandyBookedServicesVC!
    var isSelected:Bool = false
    var selectedIndexes = [IndexPath]()
    //MARK:- Outlets
    @IBOutlet weak var bookedServicesTables : CommonTableView!
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var topcurvedView : TopCurvedView!
    
  //MARK:- Actions
    @IBAction
    override func backAction(_ sender: UIButton){
        super.backAction(sender)
    }
    //MARK:- Life Cycle
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.bookedServicesVC = baseVC as? HandyBookedServicesVC
        self.initView()
        self.initLanguage()
        
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
    }
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    //MARK:- initializers
    
    override func darkModeChange() {
        super.darkModeChange()
        self.titleLbl.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.topcurvedView.customColorsUpdate()
        self.bookedServicesTables.customColorsUpdate()
        self.bookedServicesTables.reloadData()
    }
    
    func initView(){
        self.bookedServicesTables.delegate = self
        self.bookedServicesTables.dataSource = self
        self.titleLbl.text = LangHandy.requestedService
        
    }
    func initLanguage(){
        
    }
    
    
}
extension HandyBookedServicesView : UITableViewDataSource{
    
    func reloadTable() {
        self.bookedServicesTables.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookedServicesVC.servicesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HandyBookedServicesTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let item = self.bookedServicesVC.servicesArray.value(atSafe: indexPath.row) else{
            return cell
        }
    
        cell.populate(with: item,expand : self.selectedIndexes.contains(indexPath),
                      showQuantity: self.bookedServicesVC.faretype == .fixed, fareType: self.bookedServicesVC.faretype ?? .hourly)
        cell.layoutIfNeeded()
        self.layoutIfNeeded()
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedIndexes.contains(indexPath){
            self.selectedIndexes = self.selectedIndexes.filter({$0 != indexPath})
        }else{
            self.selectedIndexes.append(indexPath)
        }
        tableView.reloadData()
     
    
  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension HandyBookedServicesView : UITableViewDelegate {
    
}
