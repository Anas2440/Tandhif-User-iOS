//
//  SuccessPopUpView.swift
//  GoferHandy
//
//  Created by trioangle on 10/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SuccessPopUpView: UIView {
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var iconIV : UIImageView!
    @IBOutlet weak var descriptionLbl : UILabel!
    @IBOutlet weak var cancelBtn : UIButton!
    @IBOutlet weak var acceptBtn : UIButton!
    
    //MARK:- actions
    @IBAction
    func doneAction(_ sender : UIButton?){
        self.acceptClosure?()
        self.removeFromSuperview()
    }
    
    @IBAction
    func cancelAction(_ sender : UIButton?){
        self.cancelClosure?()
        self.removeFromSuperview()
    }
    //MARK:-Varaibles
    private var acceptClosure : (()->())? = nil
    private var cancelClosure : (()->())? = nil
    
    static func getView(using parentView : UIView) -> SuccessPopUpView{
        let nib = UINib(nibName: "SuccessPopUpView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! SuccessPopUpView
        view.frame = parentView.bounds
        parentView.addSubview(view)
        parentView.bringSubviewToFront(view)
        view.initView()
        return view
    }
    private func initView(){
        self.backgroundColor = UIColor.PrimaryColor.withAlphaComponent(0.15)
        self.acceptBtn.isHidden = true
        self.cancelBtn.isHidden = true
    }
    func set(title : String,description : String){
        self.titleLbl.text = title
        self.descriptionLbl.text = description
    }
    func addCancel(withTitle title : String, action : @escaping ()->()){
        self.cancelBtn.isHidden = false
        self.cancelBtn.setTitle(title, for: .normal)
        self.cancelClosure = action
    }
    func addSuccess(withTitle title : String, action : @escaping ()->()){
        self.acceptBtn.isHidden = false
        self.acceptBtn.setTitle(title, for: .normal)
        self.acceptClosure = action
    }

}
