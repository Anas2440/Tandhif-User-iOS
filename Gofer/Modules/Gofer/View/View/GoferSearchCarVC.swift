/**
 * CarAvailableVC.swift
 *
 * @package Gofer
 * @author Trioangle Product Team
 *
 * @link http://trioangle.com
 */

import UIKit
import Foundation
import GoogleMaps
import Network




class GoferSearchCarVC : BaseVC, APIViewProtocol
 {
   
    
    
    
    
    //Mark: - Local Variables and Outlets
    @IBOutlet var searchCarView : SearchCarView!
    var apiInteractor: APIInteractorProtocol?
    weak var appDelegate  = UIApplication.shared.delegate as? AppDelegate
    var pickUpLatitude: CLLocationDegrees = 0.0
    var pickUpLongitude: CLLocationDegrees = 0.0
    var dropLatitude: CLLocationDegrees = 0.0
    var dropLongitude: CLLocationDegrees = 0.0
    var dropLocName = ""
    var pickUpLocName = ""
    var scheduledTime:String?
    var profileModel : RiderDataModel? = nil
    var delegate: carAvailbleDelegate?

    
    //Mark:- Init Func
    
    class func initWithStory() -> GoferSearchCarVCSearchCarVC{
        return UIStoryboard.anush.instantiateViewController()
    }
    
    
    //Mark: - Protocol Function
    func onAPIComplete(_ response: ResponseEnum, for API: APIEnums) {
        
    }
   
   //Mark: - Init Functions
    
    // MARK: - ViewController Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "Schedule_covid"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "Request_covid"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoScheduleScreen(_:)), name: NSNotification.Name(rawValue: "Schedule_covid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoRequestView(_:)), name: NSNotification.Name(rawValue: "Request_covid"), object: nil)


        self.searchCarView.initLanguage()
        self.createMap()
        self.updateApi()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        self.deinitObjects()
        debug(print: "Called")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.removeMap()
    }

    //Mark: - Necessary Functions
    @objc func gotoScheduleScreen(_ notification: NSNotification) {
        
        if let params = notification.userInfo?["params"] as? JSON,let time = notification.userInfo?["time"] as? String {
            self.searchCarView.goToScheduleScreen(dicts: params, scheduletime: time)
        }
       }
    
    @objc func gotoRequestView(_ notification: NSNotification) {
        
        if let params = notification.userInfo?["params"] as? JSON {
            self.searchCarView.gotoGettingNearCarView(params)
        }
       }

    
    func updatePaymentData(){
        self.apiInteractor?
            .getRequest(for: APIEnums.getPaymentOptions,
                        params: ["is_wallet":"0"])
            .responseDecode(to: PaymentList.self,
                            { (list) in
                                self.searchCarView.payView()
            })
    }
    func createMap() {
        
        //Display Current location while loading:
        self.apiInteractor = APIInteractor(self)
        
        self.searchCarView.map = GMSMapView()
        guard let map = self.searchCarView.map else { return }
        self.searchCarView.driverLTManger = DriverLiveTrackingManager(map,
                                                        viewController: self,
                                                        focusLocation: CLLocation(latitude: self.pickUpLatitude,
                                                                                  longitude: self.pickUpLongitude))
        self.searchCarView.googleMapView.addSubview(map)
        map.anchor(toView: self.searchCarView.googleMapView,
                   leading: 0,
                   trailing: 0,
                   top: 0,
                   bottom: 0)
        self.onChangeMapStyle()
        self.searchCarView.startLoader()
        
        self.callAPIForSearchNearestCars()
        self.updatePaymentData()
        self.searchCarView.preferenceTable.delegate = self.searchCarView
        self.searchCarView.preferenceTable.dataSource = self.searchCarView
        self.searchCarView.updatefilterIcon()
        self.searchCarView.initView()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) { [weak self] in
            self?.searchCarView.initLayer()
        }
        self.searchCarView.setFonts()
        self.searchCarView.viewObjectHolder.setSpecificCornersForTop(cornerRadius: 35)
        
    }
    
    
    func updateApi()
    {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        self.apiInteractor?
            .getRequest(for: .getPromoDetails)
            .responseDecode(
                to: PromoContainerModel.self,
                { (container) in
                    UberSupport.shared.removeProgressInWindow()
                    self.searchCarView.payView()
                    
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                AppDelegate.shared.createToastMessage(error)
            })
        
        
    }
   

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if self.searchCarView.timer != nil
        {
            self.searchCarView.timer?.invalidate()
        }
    }
   
    @IBAction func savePreferencesBtnAction(_ sender: Any) {
        dump(self.profileModel)
        if self.searchCarView.tempProfileModel !=  nil{
            self.profileModel?.update(fromData: self.searchCarView.tempProfileModel!)
        }
        dump(self.profileModel)
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        
        var dicts = JSON()
        if let requests = self.searchCarView.tempProfileModel?.requestOptions
            .filter({$0.isSelected})
            .compactMap({$0.id.description}){
            dicts["options"] = requests.joined(separator: ",")
        }
        
        self.apiInteractor?
            .getRequest(
                for: APIEnums.riderProfile,
                params: dicts)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if !json.isSuccess{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }else{
                    self.searchCarView.preferencePopupView.isHidden = true
                    self.searchCarView.updatefilterIcon()
                    self.searchCarView.refreshMap()
                }
            }).responseFailure({ (error) in
                if error != ""
                {
                    UberSupport.shared.removeProgressInWindow()
                    AppDelegate.shared.createToastMessage(error)
                }
            })
    }
    
  


    

    
   
    

    
    // MARK: CALLING API - SEARCHING NEAREST CARS
    /*
     HERE PASSING PICKUP AND DROP LATITUDE, LONGITUDE FROM SETLOCATION PAGE
     */
    func callAPIForSearchNearestCars()
    {
        self.searchCarView.lblNoCarsMsg.text = ""
        self.searchCarView.lblNoCarsMsg.isHidden = true
        searchCarView.btnRequestGofer.isUserInteractionEnabled = false
        searchCarView.btnRequestGofer.backgroundColor = UIColor.ThemeYellow
        searchCarView.viewRefresh.isUserInteractionEnabled = false
        var localTimeZoneName: String { return TimeZone.current.identifier }
        var dicts = JSON()
        dicts["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["user_id"] = Constants().GETVALUE(keyname: USER_ID)
        dicts["pickup_latitude"] = String(format:"%f",pickUpLatitude)
        dicts["pickup_longitude"] = String(format:"%f",pickUpLongitude)
        dicts["drop_latitude"] = String(format:"%f",dropLatitude)
        dicts["drop_longitude"] = String(format:"%f",dropLongitude)
        dicts["car_id"] = "1"
        if let _scheduleTime = self.scheduledTime {
            let (date,time) = searchCarView.getDate_Time(fromString: _scheduleTime)
            dicts["schedule_date"] = date
            dicts["schedule_time"] = time
            dicts["is_schedule"] = 1
        }else{
            dicts["is_schedule"] = 0
        }
        dicts["payment_method"] = PaymentOptions.default?.paramValue ?? "cash"
        dicts["timezone"] = localTimeZoneName
        dicts["is_wallet"] = Constants().GETVALUE(keyname: USER_SELECT_WALLET)
        self.apiInteractor?
            .getRequest(
                for: APIEnums.searchCars,
                params: dicts
        ).responseJSON({ (json) in
            self.searchCarView.handleSearchCarResponse(json)
        }).responseFailure({ (error) in
            self.searchCarView.removeSpinnerProgress()
            self.searchCarView.viewGoferLoader.endRefreshing()
            self.searchCarView.viewRefresh.isUserInteractionEnabled = true
            self.searchCarView.btnRequestGofer.isUserInteractionEnabled = false
            self.searchCarView.btnRequestGofer.backgroundColor = UIColor.ThemeInactive
            self.appDelegate?.createToastMessage(iApp.GoferError.server.localizedDescription, bgColor: UIColor.ThemeYellow, textColor: UIColor.white)
        })
       
    }


  
   
    
   
    

    
  
    

    
    func animatePolyLine(pickUpLatitude: CLLocationDegrees, pickUpLongitude: CLLocationDegrees, dropLatitude: CLLocationDegrees, dropLongitude: CLLocationDegrees)
    {
        let vancouver = CLLocationCoordinate2DMake(pickUpLatitude, pickUpLongitude)
        let calgary = CLLocationCoordinate2DMake(dropLatitude, dropLongitude)
        let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
        let camera1 = searchCarView.map?.camera(for: bounds, insets:UIEdgeInsets.zero)
        searchCarView.map?.camera = camera1!
        
        let service = "https://maps.googleapis.com/maps/api/directions/json"
        let urlString = "\(service)?origin=\(pickUpLatitude),\(pickUpLongitude)&destination=\(dropLatitude),\(dropLongitude)&mode=driving&units=metric&sensor=true&key=\(iApp.instance.GoogleApiKey)"
        //UserDefaults.value(for: .google_api_key) ?? ""
        
        WebServiceHandler.sharedInstance.getThridPartyWebService(wsMethod: urlString, paramDict: [String:Any](), viewController: self, isToShowProgress: true, isToStopInteraction: false) { (responseDict) in
            
                if responseDict.count > 0 {
                    OperationQueue.main.addOperation {
                        self.searchCarView.drawRoute(routeDict: responseDict as NSDictionary)
                    }
                }
        }

        
    }
  
    
    
   
    

    
    
 
    
   

    
 
    
   

    
    
    
    
    

    
    //MARK: - Change Map Style
    /*
     Here we are changing the Map style from "ub__map_style" Json File
     */
    func onChangeMapStyle()
    {
        do
        {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "mapStyleChanged", withExtension: "json") {
                searchCarView.map?.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            }
            else
            {
            }
        }
        catch
        {
        }
    }
}

