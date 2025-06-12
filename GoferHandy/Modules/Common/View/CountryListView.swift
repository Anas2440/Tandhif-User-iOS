//
//  CountryListView.swift
//  GoferHandy
//
//  Created by trioangle on 30/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class CountryListView: BaseView {
    @IBOutlet weak var tblCountryList : CommonTableView!
    @IBOutlet weak var txtFldSearch:commonTextField!
    @IBOutlet weak var selectCountryLabel: SecondaryHeaderLabel!
    @IBOutlet weak var SearchBGView: SecondaryView!
    @IBOutlet weak var SearchIV: SecondaryTintImageView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var contentCurvedHolderView: TopCurvedView!
    
    lazy var staticCountryArray : [CountryModel] = {
        let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist")
        let arrCountryList = NSMutableArray(contentsOfFile: path!)!
        
        let countriesArray : [CountryModel] = arrCountryList
                   .compactMap({$0 as? JSON})
                   .compactMap({CountryModel($0)})
        return countriesArray
    }()
   
    
    
    var viewController : CountryListVC!
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? CountryListVC
        self.backgroundColor = .PrimaryColor
        self.initView()
        self.initLanguage()
        self.ThemeChange()
    }
    
    // MARK: Initialisation
    
    func initView() {
        self.txtFldSearch.setTextAlignment()
        self.SearchBGView.cornerRadius = 10
        self.SearchBGView.elevate(2)
    }
    
    func ThemeChange() {
        self.darkModeChange()
        self.headerView.customColorsUpdate()
        self.selectCountryLabel.customColorsUpdate()
        self.contentCurvedHolderView.customColorsUpdate()
        self.SearchBGView.customColorsUpdate()
        self.txtFldSearch.customColorsUpdate()
        self.SearchIV.customColorsUpdate()
        self.tblCountryList.customColorsUpdate()
        self.tblCountryList.reloadData()
    }
    
    func initLanguage(){
        self.selectCountryLabel.text = LangCommon.selectCountry
        self.txtFldSearch.placeholder = LangCommon.search
        self.txtFldSearch.setTextAlignment()
    }

    
    //MARK:- Actions
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        DispatchQueue.main.async { [weak self] in
            self?.filterCountries(for: textField.text ?? "")
        }
    }
    
    //MARK:- Filter and Update
    func filterCountries(for strSearchText:String) {
        
           let countriesArray : [CountryModel] = self.staticCountryArray
           .filter({$0.name.lowercased().hasPrefix(strSearchText.lowercased())})
        
           
            self.viewController.filteredCountries = [:]
            self.viewController.filteredKeys.removeAll()
           for country in countriesArray{
               let nameFirstChar = "\(country.name.first ?? "#")"
            var internalArray = self.viewController.filteredCountries[nameFirstChar] ?? [CountryModel]()
               internalArray.append(country)
            self.viewController.filteredCountries[nameFirstChar] = internalArray
           }
        self.viewController.filteredKeys = self.viewController.filteredCountries.keys.sorted(by: {$0 < $1})
           self.tblCountryList.reloadData()
    }
    
    
    
}

extension CountryListView : UITextFieldDelegate {
    //MARK: TextField Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        return true
    }
}

extension CountryListView : UITableViewDataSource {
    //MARK: Table view Datasource
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
//        if isForFilter{
//            return self.viewController.filteredKeys
//        }else{
//            return self.viewController.keys
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        
        if isForFilter{
            return self.viewController.filteredKeys.count
        }else{
            return self.viewController.keys.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        if isForFilter{
            let key = self.viewController.filteredKeys.value(atSafe: section) ?? "#"
            return self.viewController.filteredCountries[key]?.count ?? 0
        }else{
            let key = self.viewController.keys.value(atSafe: section) ?? "#"
            return self.viewController.countries[key]?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.cornerRadius = 10
        lbl.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        lbl.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.2)
        lbl.font = AppTheme.Fontmedium(size: 16).font
        lbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        if isForFilter {
            lbl.text = "    " + (self.viewController.filteredKeys.value(atSafe: section) ?? "#")
        }else{
            lbl.text = "    " + (self.viewController.keys.value(atSafe: section) ?? "#")
        }
        return lbl
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellCountry = tblCountryList.dequeueReusableCell(withIdentifier: "CellCountry") as! CellCountry
        cell.ThemeChange()
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        if isForFilter {
            if let key = self.viewController.filteredKeys.value(atSafe: indexPath.section),
               let country = self.viewController.filteredCountries[key]?.value(atSafe: indexPath.row){
                cell.populateCell(with: country)
                if Constants().GETVALUE(keyname: "user_country_code") == country.country_code && self.viewController.isShowSelected {
                    cell.holderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
                    cell.holderView.cornerRadius = 15
                }
            }
        } else {
            if let key = self.viewController.keys.value(atSafe: indexPath.section),
               let country = self.viewController.countries[key]?.value(atSafe: indexPath.row){
                cell.populateCell(with: country)
                if Constants().GETVALUE(keyname: "user_country_code") == country.country_code && self.viewController.isShowSelected {
                    cell.holderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
                    cell.holderView.cornerRadius = 15
                }
            }
        }
        return cell
    }
}

extension CountryListView : UITableViewDelegate{
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        if isForFilter{
            if let key = self.viewController.filteredKeys.value(atSafe: indexPath.section),
                let country = self.viewController.filteredCountries[key]?.value(atSafe: indexPath.row){
                viewController.delegate?.countryCodeChanged(countryCode:country.country_code,
                                             dialCode:country.dial_code,
                                             flagImg:country.flag)
            }
        }else{
            if let key = self.viewController.keys.value(atSafe: indexPath.section),
                let country = self.viewController.countries[key]?.value(atSafe: indexPath.row){
                viewController.delegate?.countryCodeChanged(countryCode:country.country_code,
                                             dialCode:country.dial_code,
                                             flagImg:country.flag)
            }
        }
  
        self.endEditing(true)
        
        if self.viewController.isPresented(){
            self.viewController.dismiss(animated: true, completion: nil)
        }else{
            self.viewController.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CellCountry else {return}
        cell.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        cell.holderView.cornerRadius = 15
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CellCountry else {return}
        cell.holderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        cell.holderView.cornerRadius = 15
    }
}
