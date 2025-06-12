//
//  MorePopOverVC.swift
//  GoferHandy
//
//  Created by trioangle on 18/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

protocol MorePopOverProtocol {
    func morepopOverSelection(diSelect data : MoreOptions)
    func morepopOverSelectionCancelled()
}
class MorePopOverVC: BaseViewController {
    
    //------------------------------------------
    //MARK:- Outlets
    //------------------------------------------
    
    @IBOutlet var morePopOverView: MorePopOverView!
    
    //------------------------------------------
    //MARK:- LocalVariables
    //------------------------------------------
    
    fileprivate(set) var fromFrame : CGRect!
    var delegate : MorePopOverProtocol!
    var datas = [MoreOptions]()
    var tableTitle = String()
    
    //------------------------------------------
    //MARK: - ViewController Life Cycle
    //------------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //------------------------------------------
    //MARK:- initWithStory
    //------------------------------------------
    
    class func initWithStory(preferredFrame size : CGSize,on host : UIView,delegate : MorePopOverProtocol,datas : [MoreOptions],button: UIBarButtonItem) -> MorePopOverVC{
        let infoWindow : MorePopOverVC = UIStoryboard.gojekCommon.instantiateViewController()
        infoWindow.datas = datas
        infoWindow.delegate = delegate
        infoWindow.preferredContentSize = size
        infoWindow.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = infoWindow.popoverPresentationController!
        popover.delegate = infoWindow as? UIPopoverPresentationControllerDelegate
        popover.barButtonItem = button
        popover.backgroundColor = .PrimaryColor
        popover.permittedArrowDirections = UIPopoverArrowDirection.down
        return infoWindow
    }
}
    
