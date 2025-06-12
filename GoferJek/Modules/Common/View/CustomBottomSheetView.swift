//
//  CustomBottomSheetView.swift
//  GoferHandy
//
//  Created by Trioangle on 05/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

protocol CustomBottomSheetDelegate {
    func TappedAction(indexPath: Int,SelectedItemName: String)
    func ActionSheetCanceled()
}


class CustomBottomSheetView : BaseView {
    
    
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var closeBtn: SecondaryTintButton!
    @IBOutlet weak var containerView: TopCurvedView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var dataTableView: CommonTableView!
    @IBOutlet weak var headerLabel: SecondaryHeaderLabel!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    
    var customBottomSheetVC : CustomBottomSheetVC!
    
    var listTitles: [String] { get { return customBottomSheetVC.detailsArray ?? [] } }
    
    var imageList : [String]  { get { return customBottomSheetVC.ImageArray ?? [] } }
    
    var isUrlImage : Bool { get { return customBottomSheetVC.isImageUrl ?? false } }
    
    var pageTitle : String { get { return customBottomSheetVC.pageTitle ?? "" } }
    
    var selectedItem : String { get { return customBottomSheetVC.selectedItem ?? "" } }
    
    let basicHeight : CGFloat = 60
    
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.customBottomSheetVC = baseVC as? CustomBottomSheetVC
        self.setHeight(data: self.listTitles)
        self.initView()
        self.initGesture()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.containerView.customColorsUpdate()
        self.closeBtn.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.headerLabel.customColorsUpdate()
        self.dataTableView.customColorsUpdate()
        self.dataTableView.reloadData()
    }
    
    func initView() {
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        self.closeBtn.setTitle("", for: .normal)
        self.closeBtn.setImage(UIImage(named: "close_icon_white")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.headerLabel.text = self.pageTitle
    }
    
    func initGesture() {
        self.dismissView.addAction(for: .tap) {
            self.customBottomSheetVC.dismiss(animated: true) {
                self.customBottomSheetVC.delegate.ActionSheetCanceled()
            }
        }
    }
    
    func setHeight(data: [String]) {
        let height = basicHeight * CGFloat(data.count)
        let maxHeight = self.frame.height * 0.75
        self.heightConst.constant = min(height, maxHeight)
        self.dataTableView.layoutIfNeeded()
    }
    
    
}

extension CustomBottomSheetView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.basicHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let cell: CustomBottomSheetTVC = tableView.dequeueReusableCell(for: indexPath)
        cell.titleLbl.text = self.listTitles.value(atSafe: indexPath.row)
        cell.checkBoxImg.image = self.selectedItem == self.listTitles.value(atSafe: indexPath.row) ? UIImage(named: "checkbox_selected") : nil
        cell.setTheme()
        return cell
    }
}

// Gofer Splitup Start

extension CustomBottomSheetView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.customBottomSheetVC.dismiss(animated: true) {
            self.customBottomSheetVC.delegate
                .TappedAction(
                    indexPath: indexPath.row,
                    SelectedItemName: self.listTitles.value(atSafe: indexPath.row) ?? "")
        }
    }
}

// Gofer Splitup end
