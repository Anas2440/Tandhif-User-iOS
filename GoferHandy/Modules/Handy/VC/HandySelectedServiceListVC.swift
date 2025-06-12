//
//  HandySelectedServiceListVC.swift
//  GoferHandy
//
//  Created by Maroofff  on 06/11/24.
//  Copyright © 2024 Vignesh Palanivel. All rights reserved.
//

import UIKit
import CoreLocation

class HandySelectedServiceListVC: BaseViewController, CLLocationManagerDelegate {
    
    //MARK: --- Variables
    var selectedServiceList: [SelectedService] = []
    
    //MARK: --- Outlets
    @IBOutlet weak var servicesInnerView : TopCurvedView!
    @IBOutlet weak var serviceTable : CommonTableView!
    @IBOutlet weak var servicesHolderView : TopCurvedView!
    @IBOutlet weak var BottomView: TopCurvedView!
    @IBOutlet weak var btnSearchDrivers: PrimaryButton!
    
    var bookingVM: HandyJobBookingVM?
    var accountVM : AccountViewModel?
    var locationManager: CLLocationManager?
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customSetup()
        self.accountVM?.getCurrentLocation { (newLocation) in
            newLocation.getAddress { (address) in
                print("åååAddress:\(String(describing: address))")
                self.location = newLocation.coordinate.location
            }
        }
    }
    
    //MARK: --- Custom Functions
    func customSetup() {
        selectedServicesCart.forEach({ selectedService in
            if selectedService.selectedCategories.count != 0 {
                selectedServiceList.append(selectedService)
            }
        })
        serviceTable.reloadData()
        servicesInnerView.customColorsUpdate()
        serviceTable.customColorsUpdate()
        servicesHolderView.customColorsUpdate()
        BottomView.customColorsUpdate()
        btnSearchDrivers.customColorsUpdate()
        btnSearchDrivers.setTitle(LangCommon.search.capitalized + " Driver", for: .normal)
    }
    
    //MARK: - intiWithStory
    class func initWithStory() -> HandySelectedServiceListVC{
        let view : HandySelectedServiceListVC =  UIStoryboard.gojekCommon.instantiateViewController()
            //Delivery Splitup Start
        return view
    }
    
    //MARK: --- Actions
    @IBAction func backAction(_ sender : UIButton) {
        self.exitScreen(animated: true)
    }

    @IBAction func btnSearchDriversClk(_ sender: UIButton) {
        let vc = UIStoryboard(name: "GoJek_HandyUnique", bundle: nil).instantiateViewController(withIdentifier: "SearchDriverAnimationVC") as! SearchDriverAnimationVC
        vc.modalTransitionStyle = .crossDissolve
        vc.bookingVM = self.bookingVM
        vc.service_list = self.selectedServiceList
        vc.location = self.location
        vc.completionHandler = { (providers,cat_ids) in
            print(providers)
            guard let provider = providers.first else {return}
            self.navigationController?
              .pushViewController(HandyProviderDetailVC
                .initWithStory(and: provider,
                               accountVM: self.accountVM,
                               bookingVM: self.bookingVM,
                               cat_ids: cat_ids),
                                  animated: true)
        }
        vc.failureHandler = { error in
            AppUtilities()
                .customCommonAlertView(titleString: appName,
                                       messageString: error.localizedDescription)
        }
        self.navigationController?.present(vc, animated: true)
    }
}

extension HandySelectedServiceListVC : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.selectedServiceList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedServiceList[section].selectedCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let holderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: section == 0 ? 40 : 40))
            holderView.isClippedCorner = true
            //holderView.elevate(2)
        holderView.backgroundColor = self.view.backgroundColor
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
           
        lbl.text = self.selectedServiceList[section].service_name
            
            return holderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HandyAddServiceTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let item = self.selectedServiceList.value(atSafe: indexPath.section)?.selectedCategories.value(atSafe: indexPath.row) else{return cell}
        cell.serviceNameLbl.text = item.categoryName
        cell.serviceIV.sd_setImage(with: URL(string: item.categoryImage),
                                   completed: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cell.serviceIV.contentMode = .scaleToFill
            cell.serviceIV.isRounded = true
            cell.serviceIV.clipsToBounds = true
        }
        self.accessibilityHint = item.categoryID.description
        cell.ThemeChange()
        cell.addSerivceBtn.border(width: 0,
                                  color: .clear)
        cell.addSerivceBtn.setTitleColor(.PrimaryTextColor, for: .normal)
        cell.addSerivceBtn.backgroundColor = .PrimaryColor
        cell.addSerivceBtn.setTitle(LangCommon.remove.capitalized,
                                    for: .normal)
        cell.addSerivceBtn.addAction(for: .tap) {
            self.selectedServiceList[indexPath.section].selectedCategories.removeAll(where: {$0 == item})
            if let index = selectedServicesCart.firstIndex(where: {$0.service_id==self.selectedServiceList[indexPath.section].service_id}) {
                if selectedServicesCart[index].selectedCategories.contains(item) {
                    selectedServicesCart[index].selectedCategories.removeAll(where: {$0 == item})
                }
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension HandySelectedServiceListVC {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        self.location = location
    }
}
