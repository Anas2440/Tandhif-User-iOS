//
//  MorePopOverView.swift
//  GoferHandy
//
//  Created by trioangle on 13/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
class MorePopOverView: BaseView {
    
    //------------------------------------------
    //MARK:- Outlets
    //------------------------------------------
    
    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var dismissView : UIView!
    @IBOutlet weak var holderView : UIView!
    @IBOutlet weak var dataTableView : CommonTableView!
    
    //------------------------------------------
    //MARK:- LocalVariables
    //------------------------------------------
    
    var morePopOverVC : MorePopOverVC!
    
    //------------------------------------------
    //MARK: - ViewController Life Cycle
    //------------------------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.morePopOverVC  = baseVC as? MorePopOverVC
        self.initView()
        self.initGestures()
        DispatchQueue.main
            .asyncAfter(deadline: .now() + 0.2) {
                self.initLayers()
        }
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.bgView.customColorsUpdate()
        self.dataTableView.customColorsUpdate()
        self.dataTableView.reloadData()
    }
    
    //------------------------------------------
    //MARK:- initializers
    //------------------------------------------
    
    func initView(){
        self.dataTableView.backgroundColor = .PrimaryColor
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        self.dataTableView.tableFooterView = UIView()
    }
    func initLayers(){
        self.holderView.isClippedCorner = true
    }
    func initGestures() {
        
    }
}

//------------------------------------------
//MARK: - dataTableView Data Source
//------------------------------------------

extension MorePopOverView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.morePopOverVC.datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MorePopOverTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let data = self.morePopOverVC.datas.value(atSafe: indexPath.row) else{return cell}
        cell.textLbl.text = data.localizedString
        cell.setTheme()
        return cell
    }
}

//------------------------------------------
//MARK: - dataTableView Delegate
//------------------------------------------

extension MorePopOverView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = self.morePopOverVC.datas.value(atSafe: indexPath.row) else{return}
        self.morePopOverVC.dismiss(animated: false) {
            self.morePopOverVC.delegate.morepopOverSelection(diSelect: MoreOptions(rawValue: data.rawValue) ?? .Call)
        }
        
    }
    
    
}
