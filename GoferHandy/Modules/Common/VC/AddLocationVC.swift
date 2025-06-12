/**
 * AddLocationVC.swift
 *
 * @package Gofer
 * @author Trioangle Product Team
 *  
 * @link http://trioangle.com
 */



import UIKit
import Foundation
import CoreLocation

//----------------------------------
//MARK: - AddLocation Delegate
//----------------------------------

protocol addLocationDelegate {
    func onLocationAdded(latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationName: String)
}


class AddLocationVC : BaseViewController {
    
    //----------------------------------
    //MARK: - Outlets
    //----------------------------------
    
    @IBOutlet var addLocationView: AddLocationView!
    
    //----------------------------------
    //MARK: - Local Variables
    //----------------------------------
    
    var searchMapCountdownTimer: Timer?
    var delegate: addLocationDelegate?
    var forLocation: UserLocationType = .Home
    
    //----------------------------------
    // MARK: - ViewController Methods
    //----------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //----------------------------------
    //MARK:- initWithStory
    //----------------------------------
    
    class func initWithStory(_ delegate : addLocationDelegate) -> AddLocationVC{
        let addLocationVC : AddLocationVC = UIStoryboard.gojekCommon.instantiateViewController()
        addLocationVC.delegate = delegate
        return addLocationVC
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - **** Getting Latitude & Longitude from Google Place Search ****
    //-----------------------------------------------------------------------------
    
    func getLocationCoordinates(withReferenceID referenceID: String) {
        var dicts = [AnyHashable: Any]()
        dicts["token"]  = Constants().GETVALUE(keyname: "access_token")
        let paramsComponent: String = "\("https://maps.googleapis.com/maps/api/place/details/json")?key=\(GooglePlacesApiKey)&reference=\(referenceID)&sensor=\("true")"
        WebServiceHandler.sharedInstance.getThridPartyWebService(wsMethod: paramsComponent, paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: false, isToStopInteraction: false) { (responseDict) in
            let gModel =  GoogleLocationModel.generateModel(from: responseDict)
            if gModel.status_code == "1" {
                let dictsTempsss = gModel.dictTemp["result"] as! NSDictionary
                self.addLocationView.googleData(didLoadPlaceDetails: dictsTempsss)
            } else {
                
            }
        }
    }

    func gotoCarAvailblePage(latitude: CLLocationDegrees,
                             longitude : CLLocationDegrees,
                             LocationName : String) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.delegate?.onLocationAdded(latitude: latitude,
                                           longitude: longitude,
                                           locationName: LocationName)
        })
        if self.isPresented(){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: false)
        }
       
        CATransaction.commit()
    }
    
}
