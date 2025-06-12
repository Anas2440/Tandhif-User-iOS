//
//  EmergencyContactViewController.swift
//  MyRideCiti
//
//  Created by Trioangle Technologies on 02/04/18.
//  Copyright © 2018 Trioangle Technologies. All rights reserved.
//

import UIKit


class AddedContactsTVC: UITableViewCell {
    
    @IBOutlet weak var contactNameLabel: SecondarySmallBoldLabel!
    @IBOutlet weak var contactNumberLabel: SecondaryRegularLabel!
    @IBOutlet weak var deleteContactBtn: PrimaryTintButton!
    @IBOutlet weak var bgView: SecondaryView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.cornerRadius = 15
        self.bgView.elevate(2)
    }
    
    func ThemeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.bgView.customColorsUpdate()
        self.deleteContactBtn.customColorsUpdate()
        self.contactNameLabel.customColorsUpdate()
        self.contactNumberLabel.customColorsUpdate()
    }
  
}

class EmergencyContactViewController: BaseViewController {
    
    @IBOutlet var emergencyContactView: EmergencyContactView!
    
    override var stopSwipeExitFromThisScreen: Bool?{
        return self.emergencyContactView.confirmContactHolderView.transform == .identity
    }
  
    
    var appDelegate = AppDelegate()
    
    lazy var connectionHandler : ConnectionHandler? = {
        return ConnectionHandler()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func wsToGetSOS() {
        let paramDict : JSON = ["token" : Constants().GETVALUE(keyname: USER_ACCESS_TOKEN),
                         "country_code" : Constants().GETVALUE(keyname: USER_COUNTRY_CODE),
                         "action" : "view",
                         "cache" : 1 ]
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        self.connectionHandler?.getRequest(for: .sos, params: paramDict)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()

            if json.isSuccess {
                if json.status_code == 1 {
                    let contactDict = json["contact_details"] as! [[String:Any]]
                    self.emergencyContactView.contactDictArray = contactDict
                    if self.emergencyContactView.contactDictArray.count > 0 {
                        self.emergencyContactView.contactListTableView.isHidden = false
                        self.emergencyContactView.contactListTableView.reloadData()
                        if self.emergencyContactView.contactDictArray.count == self.emergencyContactView.contactCount {
                            self.emergencyContactView.hideAddBtn()
                        } else {
                            self.emergencyContactView.showAddBtn()
                        }
                    } else {
                        self.emergencyContactView.showAddBtn()
                    }
                }
                else {
                    self.appDelegate.createToastMessage(json["status_message"] as? String ?? String(),
                                                        bgColor: UIColor.PrimaryColor,
                                                        textColor: UIColor.white)
                }
            }else{
                self.appDelegate.createToastMessage(json["status_message"] as? String ?? String(),
                                                    bgColor: UIColor.PrimaryColor,
                                                    textColor: UIColor.white)

            }
        })
            .responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
//                self.appDelegate.createToastMessage(error, bgColor: UIColor.ThemeMain, textColor: UIColor.white)

            })
        DispatchQueue
            .main
            .asyncAfter(deadline: .now() + 0.2) {
                self.emergencyContactView.initContactConfimationView()
        }
    }
  
      
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // MARK: - TableView Delegates
    
    
    class func initWithStory() -> EmergencyContactViewController{
        return UIStoryboard.gojekAccount.instantiateViewController()
    }
    
    func addContact(withName name : String,number : String, country : CountryModel) {
        // test
        let paramDict = ["token" : Constants().GETVALUE(keyname: USER_ACCESS_TOKEN),
                         "mobile_number" : number,
                         "country_code" : country.country_code,
                         "action" : "update",
                         "name" : name] as [String : Any]
        
        WebServiceHandler.sharedInstance.getWebService(wsMethod:"sos", paramDict: paramDict, viewController:self, isToShowProgress:true, isToStopInteraction:false,complete: { (response) in
            let responseJson = response
            DispatchQueue.main.async {
                if responseJson["status_code"] as? String == "1" {
                    let contactDict = responseJson["contact_details"] as! [[String:Any]]
                    self.emergencyContactView.contactDictArray = contactDict
                    if self.emergencyContactView.contactDictArray.count > 0 {
                        self.emergencyContactView.contactListTableView.isHidden = false
                        self.emergencyContactView.contactListTableView.reloadData()
                        if self.emergencyContactView.contactDictArray.count == self.emergencyContactView.contactCount {
                            self.emergencyContactView.hideAddBtn()
                        } else {
                            self.emergencyContactView.showAddBtn()
                        }
                    } else {
                        self.emergencyContactView.showAddBtn()
                    }
                    self.emergencyContactView.hideContactView()
                } else {
                    self.appDelegate.createToastMessageForAlamofire(responseJson["status_message"] as? String ?? String(), bgColor: UIColor.black, textColor: UIColor.white, forView:self.view)
                }
            }
        }){(error) in
            
        }
    }
}


extension EmergencyContactViewController {
    func wsToDeleteContact(sender: UIButton) {
        let paramDict = ["token" : Constants().GETVALUE(keyname: USER_ACCESS_TOKEN),
                         "mobile_number" : self.emergencyContactView.contactDictArray[sender.tag]["mobile_number"]!,
                         "action" : "delete",
                         "country_code" : Constants().GETVALUE(keyname: USER_COUNTRY_CODE),
                         "name" : self.emergencyContactView.contactDictArray[sender.tag]["name"]!,
                         "id" : self.emergencyContactView.contactDictArray[sender.tag]["id"]!] as [String : Any]
        WebServiceHandler.sharedInstance.getWebService(wsMethod:"sos", paramDict: paramDict, viewController:self, isToShowProgress:true, isToStopInteraction:false,complete : { (response) in
            let responseJson = response
            DispatchQueue.main.async {
                if responseJson["status_code"] as? String == "1" {
                    // remove the item from the data model
                  self.emergencyContactView.contactDictArray.remove(at: sender.tag)
                    self.emergencyContactView.contactListTableView.reloadData()
                    // delete the table view row
                    if self.emergencyContactView.contactDictArray.count == 0 {
                        self.emergencyContactView.contactListTableView.isHidden = true
                        self.emergencyContactView.showAddBtn()
                    } else if self.emergencyContactView.contactDictArray.count == self.emergencyContactView.contactCount {
                        self.emergencyContactView.hideAddBtn()
                    } else if self.emergencyContactView.contactDictArray.count < self.emergencyContactView.contactCount && self.emergencyContactView.contactDictArray.count > 0 {
                        self.emergencyContactView.showAddBtn()
                    } else {
                        self.emergencyContactView.contactListTableView.isHidden = false
                    }
                } else {
                    self.appDelegate.createToastMessageForAlamofire(responseJson["status_message"] as? String ?? String(), bgColor: UIColor.black, textColor: UIColor.white, forView:self.view)
                }
            }
        }){(error) in
          print("----------> Error:  \(error.localizedDescription)")
        }
    }
    

  
}
