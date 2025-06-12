//
//  LoadWebkitSubview.swift
//  Goferjek
//
//  Created by trioangle on 22/09/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

import UIKit
import MessageUI
import Social
import WebKit

class LoadWebkitSubview: BaseView {
    var loadVC:LoadWebKitView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet var webCommon: WKWebView?
    @IBOutlet var lblTitle: SecondaryHeaderLabel!
    @IBOutlet weak var bgView: TopCurvedView!

    var strPageTitle = ""

    var strCancellationFlexible = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
   

    override
    func darkModeChange() {
        super.darkModeChange()
    }
    override
    func didLoad(baseVC: BaseViewController) {
        self.loadVC = baseVC as? LoadWebKitView
        super.didLoad(baseVC: baseVC)
        self.webCommon?.navigationDelegate = self
        self.webCommon?.uiDelegate = self
        self.loadVC.navigationController?.isNavigationBarHidden = true
        lblTitle.text = strPageTitle
        let request = URLRequest(url: URL(string: self.loadVC.strWebUrl)!)
        webCommon?.load(request)
        self.lblTitle.text = LangCommon.paymentDetails.capitalized
        self.setTheme()

    }
    func setTheme(){
        let isDarkStyle = traitCollection.userInterfaceStyle == .dark
        self.headerView.customColorsUpdate()
        self.lblTitle.customColorsUpdate()
        self.bgView.customColorsUpdate()
        webCommon?.isOpaque = false
        self.backgroundColor = isDarkStyle ? .DarkModeBackground : .PrimaryTextColor
    }
    override
    func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    
    override
    func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
    }
    func goBack()
    {
//        OperationQueue.main.addOperation {
        self.loadVC.navigationController?.popViewController(animated: true)
//        }
    }
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.loadVC.navigationController?.popViewController(animated: true)
       
    }
}
extension LoadWebkitSubview: WKNavigationDelegate,WKUIDelegate {

    
    // 1. Decides whether to allow or cancel a navigation.
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        print("*********************************************************navigationAction load:\(String(describing: navigationAction.request.url))")
        let str = String(describing: navigationAction.request.url)
        if str.contains("/challenge/complete"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "subcription_complete"),
                                                object: self, userInfo: nil)
                self.goBack()
            }
        } else {
            print("Error ----------------------------------")
        }
        decisionHandler(.allow)
    }
    
    // 2. Start loading web address
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load:\(String(describing: webView.url))")
        UberSupport().showProgress(viewCtrl: self.loadVC, showAnimation: true)
    }
    
    // 3. Fail while loading with an error
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        print("fail with error: \(error.localizedDescription)")
    }
    
    // For Http Handling
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil) ; return }
            let exceptions = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
    
    // 4. WKWebView finish loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading")
        UberSupport().removeProgress(viewCtrl: self.loadVC)
        webView.evaluateJavaScript("document.getElementById('data').innerHTML", completionHandler: { result, error in
            if let userAgent = result as? String {

                if let resFinal = self.convertStringToDictionary(text: userAgent) as? JSON {
                    print("*****************")
                    print(resFinal)
                    let statCode = resFinal["status_code"] as! String
                    let statMessage = resFinal["status_message"] as! String
                    var tripId = ""
                    var walletAmount = ""
                    if self.loadVC.isFromTrip{
                        tripId = resFinal.string("job_id")
                    }
                    else {
                        walletAmount = resFinal.string("wallet_amount")
                    }
                    if statCode == "1"{
                        self.goBack()
                        if self.loadVC.isFromPlaceOrder{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlaceOrderApi"), object: self, userInfo: ["status": statMessage,"code": statCode])

                        }
                        if self.loadVC.isFromTrip{
                            tripId = resFinal.string("job_id")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TripApi"), object: self, userInfo: ["status": statMessage,"tripId":tripId,"name": resFinal.string("user_name"),"image": resFinal.string("user_thumb_image")])
                        }
                        else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WalletApi"), object: self, userInfo: ["wallet": walletAmount])
                            self.appDelegate.createToastMessage(statMessage)
                        }
//                        if self.isFromTrip{
//                            FireBaseNodeKey.trip.getReference(for: "\(tripId)").removeValue()
//                            self.appDelegate.onSetRootViewController(viewCtrl: self)
//                        }
                    }else{
                        self.appDelegate.createToastMessage(statMessage)
                        self.goBack()
                    }
                    
                   
                } else {
                    print("Error ----------------------------------")
                }
                
            }
        })

        print("didFinish")
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
