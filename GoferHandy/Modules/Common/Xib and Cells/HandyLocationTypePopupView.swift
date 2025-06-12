//
//  HandyLocationTypePopupView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 09/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

protocol DropDownPopTwoActionsDelegate {
    func selectedPopView(index selectedIndex:Int)
   
    func closePopupAction()
}

class HandyLocationTypePopupView: UIView {
    
    var delegate:DropDownPopTwoActionsDelegate?

    enum PopupEnum {
        case firstcase
        case secondcase
    }
    @IBOutlet weak var popUpTableView: CommonTableView!
    @IBOutlet weak var holderViewHeight: NSLayoutConstraint!
    var  tableDataSourceArrStr = [String]()
    @IBOutlet weak var holderView: TopCurvedView!
    @IBOutlet weak var workLocLbl: SecondaryHeaderLabel!
    var selectedIndex:Int?
    @IBOutlet weak var outerView: UIView!
    override  func awakeFromNib() {
        self.outerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.popUpTableView.registerNib(forCell: HandyDeliveryParcelTypeTVC.self)
        self.popUpTableView.dataSource = self
        self.popUpTableView.delegate = self
        self.holderView.isUserInteractionEnabled = true
        self.outerView.addTap {
            self.delegate?.closePopupAction()
            self.removeFromSuperview()
        }
    }
    class func initNib()->HandyLocationTypePopupView {
        let nib = Bundle.main.loadNibNamed("HandyLocationTypePopupView", owner: nil, options: nil)?.first as! HandyLocationTypePopupView
        let frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        nib.frame = frame
        return nib
    }
    func setTheme() {
        self.holderView.customColorsUpdate()
        self.workLocLbl.customColorsUpdate()
        self.popUpTableView.customColorsUpdate()
        self.popUpTableView.reloadData()
    }
    func setupNib(popUpTitle:String, _ popUpArrStr:[String], selectedIndex: Int? = nil) {
        self.workLocLbl.text = popUpTitle
        self.tableDataSourceArrStr = popUpArrStr
        self.selectedIndex = selectedIndex
        self.holderViewHeight.constant = min(CGFloat(popUpArrStr.count * 60), self.frame.height * 0.75)
        self.bringSubviewToFront(holderView)
        self.popUpTableView.reloadData()
    }
}


extension HandyLocationTypePopupView : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSourceArrStr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HandyDeliveryParcelTypeTVC = tableView.dequeueReusableCell(for: indexPath)
        cell.titleLbl.text = self.tableDataSourceArrStr[indexPath.row]
        if let index = self.selectedIndex, index == indexPath.row {
            cell.selectedImgView.image = #imageLiteral(resourceName: "Radio_btn_selected")
        }else {
            cell.selectedImgView.image = #imageLiteral(resourceName: "Radio_btn_unselected")
        }
        cell.setTheme()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.delegate?.selectedPopView(index: self.selectedIndex!)
        self.removeFromSuperview()
    }
    
    
}
