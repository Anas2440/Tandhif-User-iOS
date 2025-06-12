//
//  ReferalVC.swift
//  Gofer
//
//  Created by trioangle on 27/03/19.
//  Copyright Â© 2019 Trioangle Technologies. All rights reserved.
//

import UIKit

class ReferalVC: BaseViewController{
    //MARK:- Outlets
    @IBOutlet weak var referalView : ReferalView!
    
    //MARK:- Variables
    var accountViewModel : AccountViewModel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
//  let referalBC = "SignUp & Get Paid For Every Referral Sign-up & Much More Bonus Awaits!".localize
   
    var referalCode = String()
    var totalEarning = String()
    var maxReferal = String()
    var appLink = String()
    var referalSections = [ReferalType]()
    var isLoading : Bool = true
    var completedReferals = [ReferalModel]()
    var inCompleteReferals = [ReferalModel]()
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.wsToGetReferals()
        // Do any additional setup after loading the view.
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //MARK:- Init with story
    
    class func initWithStory()->ReferalVC{
        let story = UIStoryboard.gojekCommon
        let vc = story.instantiateViewController(withIdentifier: "ReferalVCID") as! ReferalVC
        vc.accountViewModel = AccountViewModel()
        return vc
    }
    //MARK:- WebServices
    func wsToGetReferals(){
        self.accountViewModel.getReferal { (result) in
            switch result{
            case .success(let data):
                self.referalCode = data.referal
                self.appLink = data.appLink
                self.referalView.referalCodeValueLbl.text = self.referalCode
                self.totalEarning = data.totalEarning.description
                self.maxReferal = data.maxReferal.description
                self.referalView.referalDescription.text = LangCommon.getUpto + " \(data.maxReferal) " + LangCommon.forEveryFriendJobs + " \(appName)"
                self.inCompleteReferals = data.incomplete
                self.completedReferals = data.complete
                self.isLoading = false
                self.referalView.referalTable.springReloadData()
            case .failure(let error):
                self.isLoading = false
                print("\(error.localizedDescription)")

//                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
    }
}

