/**
* CountryListVC.swift
*
* @package Gofer
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import AVFoundation

protocol CountryListDelegate {
    func countryCodeChanged(countryCode:String, dialCode:String, flagImg:UIImage)
}


class CountryListVC : BaseViewController {
    
    @IBOutlet weak var countryListView : CountryListView!
    
    var delegate: CountryListDelegate?
    var strPreviousCountry = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    //MARK:- Country DataSources
    var keys = [String]()
    var countries : [String : [CountryModel]] = [:]
    var filteredKeys = [String]()
    var filteredCountries : [String : [CountryModel]] = [:]
    var isShowSelected = true
    // MARK: - ViewController Methods
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
        
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let uberLoader = UberSupport()
        uberLoader.showProgressInWindow(showAnimation: true)
        DispatchQueue.main.async { [weak self] in
            self?.generateDataSource()
            uberLoader.removeProgressInWindow()
        }
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }

    override
    func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.countryListView.ThemeChange()
    }
     
    //MARK:- initWithStory
    class func initWithStory(showSelected : Bool? = true) -> CountryListVC {
        let vc : CountryListVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.isShowSelected = showSelected ?? false
        return vc
    }
    
    //MARK:- UDF
    //MARK:- Generate datasource
    func generateDataSource(){
        let countriesArray = self.countryListView.staticCountryArray
        self.countries = [:]
        for country in countriesArray{
            let nameFirstChar = "\(country.name.first ?? "#")"
            var internalArray = self.countries[nameFirstChar] ?? [CountryModel]()
            internalArray.append(country)
            self.countries[nameFirstChar] = internalArray
        }
        self.keys = self.countries.keys.sorted(by: {$0 < $1})
        self.countryListView.tblCountryList.reloadData()
    }
}



extension UIImage{
    class func imageFlagBundleNamed(named:String)->UIImage{
        let image = UIImage(named: "assets.bundle".appendingFormat("/"+(named as String)))!
        return image
    }
}
