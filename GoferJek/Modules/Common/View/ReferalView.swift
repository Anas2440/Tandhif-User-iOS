//
//  ReferalView.swift
//  GoferHandy
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation


class ReferalView : BaseView{
    //MARK:- Outlets
    let referalBC = LangCommon.signUpandGetPaid
    var viewController : ReferalVC!
    @IBOutlet weak var navView : HeaderView!
    @IBOutlet weak var headerView : SecondaryView!
    @IBOutlet weak var shareBtn : PrimaryTintButton!
    @IBOutlet weak var referalHolderView : UIView!
    @IBOutlet weak var referalCodeValueLbl: PrimaryColoredHeaderLabel!
    @IBOutlet weak var referalDescription : InactiveRegularLabel!
    @IBOutlet weak var urRefcodeLbl : SecondaryRegularLabel!
    @IBOutlet weak var pageTitle : SecondaryHeaderLabel!
    @IBOutlet weak var referealTextLBL : UILabel!
    @IBOutlet weak var referalTable : CommonTableView!
    @IBOutlet weak var copyBtn: PrimaryTintButton!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    

    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.navView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.shareBtn.customColorsUpdate()
        self.referalDescription.customColorsUpdate()
        self.urRefcodeLbl.customColorsUpdate()
        self.pageTitle.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.referalTable.customColorsUpdate()
        self.copyBtn.customColorsUpdate()
        self.referalTable.reloadData()
    }

    @IBAction func shareAction(_ sender : UIButton?){
        let urlString = self.viewController.appLink
        guard let url = NSURL(string: urlString) else {return}
        let text = LangCommon.signUpandGetPaid
        + LangCommon.useMyReferral
        + " "
        + self.viewController.referalCode
        + " "
        + LangCommon.startJourneyonGofer
        + " "
        + LangCommon.appName
        + " "
        + LangCommon.fromHere
        + " "
        + "\(url)"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self
        self.viewController.presentInFullScreen(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- Life cycle
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? ReferalVC
        
        self.initView()
        self.initGestures()
    }
    func initView(){
        self.copyBtn.setTitle(nil, for: .normal)
        self.copyBtn.setImage(UIImage(named: "Copy")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.shareBtn.setTitle(nil, for: .normal)
        self.shareBtn.setImage(UIImage(named: "Share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.pageTitle.text = LangCommon.referral.capitalized
        self.urRefcodeLbl.text = LangCommon.yourInviteCode.capitalized
        self.referalTable.delegate = self
        self.referalTable.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.headerView.isHidden = !Shared.instance.isReferralEnabled()
            self.headerView.cornerRadius = 15
            self.headerView.elevate(4)
        }
    }
    func initGestures(){
        self.referalHolderView.addAction(for: .tap) {[weak self] in
            guard let welf = self else{return}
            UIPasteboard.general.string = welf.viewController.referalCode//self.referalBC + " Use my Referral " +
            AppDelegate.shared.createToastMessage(LangCommon.referralCodeCopied)
        }
        self.copyBtn.addAction(for:.tap){[weak self] in
            guard let welf = self else{return}
            UIPasteboard.general.string = welf.viewController.referalCode//self.referalBC + " Use my Referral " +
            AppDelegate.shared.createToastMessage(LangCommon.referralCodeCopied)
        }
    }
}

extension ReferalView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let vc = self.viewController else { return 0 }
        vc.referalSections.removeAll()
        if !vc.inCompleteReferals.isEmpty {
            vc.referalSections.append(.inComplete)
        }
        if !vc.completedReferals.isEmpty{
            vc.referalSections.append(.completed)
        }
        if vc.referalSections.isEmpty && !vc.isLoading {
            referalTable.alwaysBounceVertical = false
            let no_referal = UILabel()
            no_referal.text = LangCommon.noDataFound
            no_referal.font = AppTheme.Fontbold(size: 15).font
            no_referal.textColor = .ThemeTextColor
            no_referal.textAlignment = .center
            self.referalTable.backgroundView = no_referal
            return 0
        } else {
            self.referalTable.backgroundView = nil
            referalTable.alwaysBounceVertical = true
            return vc.referalSections.count
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.frame.height * 0.08
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.frame.height * 0.08
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let holderView = SecondaryView(frame: CGRect(
                                        x: 0,
                                        y: headerView.frame.maxY,
                                        width: tableView.frame.width,
                                        height: self.frame.height * 0.08)
        )
        let label1Width = tableView.frame.width
        let label = SecondarySubHeaderLabel(frame: CGRect(
                                                x: 15,
                                                y: 0,
                                                width: label1Width - 30,
                                                height: self.frame.height * 0.08)
        )
        let label2 = SecondarySubHeaderLabel(frame: CGRect(
                                                x: label1Width + 15,
                                                y: 0,
                                                width: tableView.frame.width - label1Width - 5,
                                                height: self.frame.height * 0.08)
        )
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.setTextAlignment()
        label2.lineBreakMode = .byWordWrapping
        label2.numberOfLines = 1
        label2.setTextAlignment(aligned: .right)
        switch self.viewController.referalSections[section] {
        case .inComplete:
            label.text =  LangCommon.friendsInComplete.capitalized
        case .completed:
            label.text = LangCommon.friendsCompleted.capitalized + "(\(LangCommon.earned) \(!self.viewController.totalEarning.isEmpty ? self.viewController.totalEarning : "0") )"
            label2.text =  LangCommon.earned + "\(!self.viewController.totalEarning.isEmpty ? self.viewController.totalEarning : "0") "
        }
       
        holderView.addSubview(label)
//        holderView.addSubview(label2)
        holderView.customColorsUpdate()
        label.customColorsUpdate()
        label2.customColorsUpdate()
        holderView.layoutIfNeeded()
        return holderView
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewController.referalSections[section] {
        case .inComplete:
            return self.viewController.inCompleteReferals.count
        case .completed:
            return self.viewController.completedReferals.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReferalTCell.identifier) as! ReferalTCell
        let referal : ReferalModel
        if self.viewController.referalSections[indexPath.section] == .inComplete{
            referal = self.viewController.inCompleteReferals[indexPath.row]
        }else{
            referal = self.viewController.completedReferals[indexPath.row]
        }
        cell.ThemeUpdate()
        cell.setCell(referal)
        return cell
    }
}
