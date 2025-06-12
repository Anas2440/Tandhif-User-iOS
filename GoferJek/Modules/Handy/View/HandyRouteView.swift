//
//  HandyRouteView.swift
//  GoferHandy
//
//  Created by trioangle on 01/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import GoogleMaps

class HandyRouteView: BaseView{
    
    var routeVC: HandyRouteVC!
    //MARK:- Outlets
    @IBOutlet weak var mainBGView: SecondaryView!
    @IBOutlet weak var titleLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var nameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var addressLbl : SecondaryRegularLabel!
    @IBOutlet weak var ratingLbl : UILabel!
   // @IBOutlet weak var ratingStack : StarStackView!
    @IBOutlet weak var viewOptionTitleLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var otpLbl : CustomOtpLabel!
    @IBOutlet weak var moreBtn : UIButton!
    @IBOutlet weak var providerProfileIV : UIImageView!
    @IBOutlet weak var jobProgressView: SecondaryView!
    @IBOutlet weak var tableholderView: TopCurvedView!
    @IBOutlet weak var headerView:HeaderView!
    @IBOutlet weak var topCurvedView:TopCurvedView!
    @IBOutlet weak var enRouteTable: CommonTableView!
    
    
    //TrackingView
    @IBOutlet weak var trackingView: UIView!
    
    @IBOutlet weak var dotViewAccepted:UIView!
    @IBOutlet weak var statusLabelAccepted:UILabel!
    @IBOutlet weak var timeLableAccepted:UILabel!
    @IBOutlet weak var vertBarAccepted:UIView!
    
    @IBOutlet weak var dotViewOnLocation:UIView!
    @IBOutlet weak var statusLabelOnLocation:UILabel!
    @IBOutlet weak var timeLableOnLocation:UILabel!
    @IBOutlet weak var vertBarOnLocation:UIView!
    
    @IBOutlet weak var dotViewStarted:UIView!
    @IBOutlet weak var statusLabelStarted:UILabel!
    @IBOutlet weak var timeLableStarted:UILabel!
    @IBOutlet weak var vertBarStarted:UIView!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.tableholderView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.topCurvedView.customColorsUpdate()
        self.jobProgressView.customColorsUpdate()
        self.mainBGView.customColorsUpdate()
        self.nameLbl.customColorsUpdate()
        self.addressLbl.customColorsUpdate()
        self.viewOptionTitleLbl.customColorsUpdate()
        self.otpLbl.customColorsUpdate()
        self.providerProfileIV.isCurvedCorner = true
        self.enRouteTable.customColorsUpdate()
        self.onChangeMapStyle()
        self.moreBtn.setImage(UIImage(named: "more")?.withRenderingMode(.alwaysTemplate),
                              for: .normal)
        self.moreBtn.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.enRouteTable.reloadData()
        if let text = self.ratingLbl.attributedText {
            let attText = NSMutableAttributedString(attributedString: text)
            attText.setColorForText(textToFind: attText.string, withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            attText.setColorForText(textToFind: "★", withColor: .ThemeYellow)
            self.ratingLbl.attributedText = attText
        }
    }
    func onChangeMapStyle() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate at zoom level 6.
        // googleMapView.setMinZoom(15.0, maxZoom: 55.0)
        let camera = GMSCameraPosition.camera(withLatitude: 9.917703, longitude: 78.138299, zoom: 4.0)
        GMSMapView.map(withFrame: gmsMapView.frame, camera: camera)
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: self.isDarkStyle ? "map_style_dark" : "mapStyleChanged", withExtension: "json") {
                gmsMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
            }
        } catch {
        }
    }
    
    //MARK:- Actions
    @IBAction
    override func backAction(_ sender: UIButton){
        if let vc = self.routeVC.findLastBeforeVC() ,
           vc.isKind(of: HandyTripHistoryVC.self) {
            self.routeVC.exitScreen(animated: true)
        } else {
            self.routeVC.setRootVC()
        }
    }
    
    @IBAction
    func optionAction(_ sender : UIButton){
        self.routeVC.showPopOver(sender: sender)
    }
    //MARK:- Variables
    lazy var gmsMapView : GMSMapView = {
        let map = GMSMapView()
        map.frame = self.enRouteTable.bounds
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        return map
    }()
    
    var currentlyViewing : RouteVCViewOptions? = nil
    //MAKR:- Life Cycle
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.routeVC = baseVC as? HandyRouteVC
        self.initView()
        self.initLanguage()
        self.darkModeChange()
//        self.setCurrentViewing(to: .list, jobDetail: nil)
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
    }
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
        
    }
    //MARK:- initializers
    
    func initView(){
        self.enRouteTable.delegate = self
        self.enRouteTable.dataSource = self
        self.titleLbl.textAlignment = .natural
        self.otpLbl.adjustsFontSizeToFitWidth = true
        self.currentlyViewing = .list
        self.enRouteTable.setSpecificCornersForTop(cornerRadius: 40)
        self.viewOptionTitleLbl.setTextAlignment()
    }
    func initLanguage(){
        self.viewOptionTitleLbl.text = LangHandy.jobProgress
    }
    //MARK:- UDF
    func setCurrentViewing(to state : RouteVCViewOptions,jobDetail : HandyJobDetailModel?){
        guard self.currentlyViewing != state else{return}
        self.currentlyViewing = state
        self.enRouteTable.reloadData()
        switch  state {
        case .list:
          self.viewOptionTitleLbl.text = LangHandy.jobProgress
        case .map:
          self.viewOptionTitleLbl.text = LangHandy.liveTracking
        }
        if state == .map {
   
            if gmsMapView.camera.zoom < 14{
                gmsMapView.animate(toZoom: 14)
            }
        }
    }
    func populateView(with jobDetail : HandyJobDetailModel){
        self.enRouteTable.reloadData()
        self.nameLbl.text = jobDetail.providerName
        self.addressLbl.textAlignment = .natural
        self.addressLbl.text = jobDetail.users.pickup
        self.titleLbl.text = "\(LangCommon.number)#\(jobDetail.users.jobID)"
        //self.ratingStack.setRating(jobDetail.providerRating)
        if !jobDetail.providerRating.isZero{
            let textAtt =  NSMutableAttributedString(string: "★ \(jobDetail.providerRating)")
            textAtt.setColorForText(textToFind: "★ \(jobDetail.providerRating) ", withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            textAtt.setColorForText(textToFind: "\(jobDetail.providerRating)", withColor:self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            textAtt.setColorForText(textToFind: "★", withColor: .ThemeYellow)
            ratingLbl.attributedText = textAtt
        }
        self.providerProfileIV.sd_setImage(with: URL(string: jobDetail.providerImage),
                                           placeholderImage: UIImage(named: "user_dummy"),
                                           options: .highPriority,
                                           context: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.providerProfileIV.contentMode = .scaleAspectFill
            self.providerProfileIV.isClippedCorner = true
            self.providerProfileIV.isCurvedCorner = true
            self.providerProfileIV.border(width: 0,
                                          color: .PrimaryColor)
        }
        if jobDetail.canShowLiveTrackingMap{
            self.setCurrentViewing(to: self.currentlyViewing ?? .list, jobDetail: jobDetail)
        }else{
            self.setCurrentViewing(to: .list, jobDetail: jobDetail)
        }
        if jobDetail.users.isRequiredOtp ,!jobDetail.users.jobStatus.isTripStarted{
            self.otpLbl.text = "OTP " + jobDetail.users.otp
            self.otpLbl.isHidden = false
        }else{
            self.otpLbl.isHidden = true
        }
        
    }
    
  
    
}
extension HandyRouteView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count : Int
        if self.currentlyViewing == .list{
            count = self.routeVC.jobViewModel?.jobDetailModel?.users.jobProgress.count ?? 0
            tableView.backgroundView = nil
        }
        else{
            count = 0
            self.gmsMapView.frame = tableView.bounds
            tableView.backgroundView = self.gmsMapView
            self.routeVC.jobViewModel.validateMapMarkers()
        }
          return count
      }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HandyEnrouteTVC = enRouteTable.dequeueReusableCell(for: indexPath)
        
        guard let progress = self.routeVC.jobDetailModel?.users.jobProgress.value(atSafe: indexPath.row) else {
            return cell
        }
        let totRows = self.routeVC.jobViewModel?.jobDetailModel?.users.jobProgress.count ?? 0
        let truedRows =  self.routeVC.jobViewModel?.jobDetailModel?.users.jobProgress.filter({$0.status == true}).count ?? 0
        cell.dotView.backgroundColor = self.backgroundColor
        cell.dotView.elevate(2)
        cell.statusLbl.text = progress.jobStatusMsg
        cell.timeLbl.isHidden = !progress.status
        cell.timeLbl.text = progress.time
        cell.timeLbl.setTextAlignment()
        cell.statusLbl.setTextAlignment()
        cell.ThemeChange()
        cell.innerDot.backgroundColor = progress.status ? .PrimaryColor : .TertiaryColor
        DispatchQueue.main.async {
            self.drawLine(cell: cell, completedRows: truedRows, totalRows: totRows, currentRow: indexPath.row, view: cell.lineView)
        }
        
        return cell
    }
    func drawLine(cell:HandyEnrouteTVC,completedRows:Int,totalRows:Int,currentRow:Int,view:UIView){
            
        let redColor = UIColor.PrimaryColor
        let inActiveColr = UIColor.TertiaryColor
        switch completedRows{
        case 1:
            switch currentRow{
            case 0:
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: inActiveColr)
            case totalRows - 1:
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: inActiveColr)
            default:
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: inActiveColr)
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: inActiveColr)
            }
        case 2:
            switch currentRow{
            case 0:
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: redColor)
            case totalRows - 1:
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: inActiveColr)
            case 1:
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: redColor)
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: inActiveColr)
            default:
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: inActiveColr)
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: inActiveColr)
            }
        case 3:
            switch currentRow{
            case 0:
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: redColor)
            case totalRows - 1:
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: inActiveColr)
            case 1:
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: redColor)
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: redColor)
            case 2:
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: redColor)
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: inActiveColr)
            default:
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: inActiveColr)
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: inActiveColr)
            }
        case 4:
            switch currentRow{
            case 0:
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: redColor)
            case totalRows - 1:
                cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: redColor)
            default:
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: view.frame.minY), end: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), view: view, color: redColor)
                    cell.drawDottedLine(start: CGPoint(x: cell.dotView.center.x, y: cell.dotView.center.y), end: CGPoint(x: cell.dotView.center.x, y: view.frame.maxY), view: view, color: redColor)
            }
        default:
            print("no lines")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
