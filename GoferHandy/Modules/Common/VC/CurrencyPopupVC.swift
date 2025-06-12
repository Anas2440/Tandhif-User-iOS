//
//  CurrencyPopupVC.swift
//  GoferHandy
//
//  Created by Trioangle on 29/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

class CurrencyPopupVC: BaseViewController {

    @IBOutlet var currencyPopupView: CurrencyPopupView!
    var arrCurrencyData = [CurrencyModel]()
    var callback: ((String?)->())?
    var clickedSym : ((String?) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        self.currencyPopupView.oldOrgin = self.currencyPopupView.hoverView.frame.origin
        self.currencyPopupView.oldSize = self.currencyPopupView.hoverView.frame.size
    }
    //MARK: - Init with Storyboard
    class func initWithStory() -> CurrencyPopupVC{
        let view : CurrencyPopupVC = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.currencyPopupView.ThemeChange()
    }
    func saveCurrencyDetails() {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        var dicts = JSON()
        dicts["token"] =  Constants().GETVALUE(keyname: "access_token")
        let str = self.currencyPopupView.strCurrentCurrency.components(separatedBy: " | ")
        dicts["currency_code"] = str[0]
        ConnectionHandler.shared.getRequest(
                for: APIEnums.updateUserCurrency,
                params: dicts)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    //self.delegate?.onCurrencyChanged(currency: self.currencyPopupView.strCurrentCurrency)
                    let str = self.currencyPopupView.strCurrentCurrency.components(separatedBy: " | ")
                    Constants().STOREVALUE(value: str[1] as String? ?? String(), keyname: "user_currency_symbol_org")// code
                    Constants().STOREVALUE(value: str[0] as String? ?? String(), keyname: "user_currency_org")//symbal

//                    self.navigationController!.popViewController(animated: true)
                }else{

                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
//                AppDelegate.shared.createToastMessage(error)
            })
    }
    func callCurrencyAPI(){
//           UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(for: APIEnums.getCurrencyList,params: [:])
               .responseJSON({ (json) in
                              UberSupport.shared.removeProgressInWindow()
                              if json.isSuccess{
                                  let currencies = json
                                      .array("currency_list")
                                  .compactMap({CurrencyModel(from: $0)})
                                  self.arrCurrencyData = currencies
                                self.currencyPopupView.currencyTable.reloadData()
                              }else{
                                  AppDelegate.shared.createToastMessage(json.status_message)
                              }
                          }).responseFailure({ (error) in
                              UberSupport.shared.removeProgressInWindow()
//                              AppDelegate.shared.createToastMessage(error)
                          })
       }
  func updateCurrencyInfo() {
    
  }
}
