//
//  ChatView.swift
//  GoferHandy
//
//  Created by trioangle on 22/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class ChatView: BaseView {
    //MARK: Outlets
    @IBOutlet weak var riderAvatar : UIImageView!
    @IBOutlet weak var chatTableView: CommonTableView!
    @IBOutlet weak var driverName : SecondaryHeaderLabel!
    @IBOutlet weak var driverRating : SecondarySmallBoldLabel!
    @IBOutlet weak var messageTextField: commonTextField!
    @IBOutlet weak var jobIDLbl: SecondarySmallLabel!
    
    @IBOutlet weak var chatPlaceholder: SecondaryView!
    @IBOutlet weak var noChatMessage: SecondarySubHeaderLabel!
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var arrowImg: PrimaryImageView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bottomChatBar: SecondaryView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    
    var chatVC : ChatVC!
    var messages: [ChatModel] = [ChatModel]()
    var firstTime : Bool = true
    var chatInteractor: ChatInteractorProtocol?
    var shouldCloseOnWillApperar = false
    var chatTableRect : CGRect!
    var isKeyboardOpen = false
    let preference = UserDefaults.standard
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.chatVC = baseVC as? ChatVC
        self.initView()
        self.initPipeLines()
        self.initLanguage()
        self.initGesture()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.driverRating.customColorsUpdate()
        if let text = self.driverRating.attributedText {
            let attrStr = NSMutableAttributedString(attributedString: text)
            attrStr.setColorForText(textToFind: "⭑",
                                        withColor: .ThemeYellow)
            self.driverRating.attributedText = attrStr
        }
        self.contentHolderView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.driverName.customColorsUpdate()
        self.jobIDLbl.customColorsUpdate()
        self.backgroundColor = self.isDarkStyle ?
            .DarkModeBackground :
            .SecondaryColor
        self.bottomChatBar.customColorsUpdate()
        self.chatPlaceholder.customColorsUpdate()
        self.messageTextField.customColorsUpdate()
        self.chatTableView.customColorsUpdate()
        self.chatTableView.reloadData()
        self.noChatMessage.customColorsUpdate()
        self.bottomChatBar.transform = .identity
        self.endEditing(true)
    }
    
    override
    func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        ChatInteractor.instance.getAllChats(ForView : self, AndObserve: true)
        if self.shouldCloseOnWillApperar{
            self.shouldCloseOnWillApperar = false
            self.backAction(self.backBtn!)
        }
    }
    
    override
    func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
        Shared.instance.needToShowChatVC = false
        Shared.instance.chatVcisActive = true
    }
    
    override
    func didDisappear(baseVC: BaseViewController) {
        super.didDisappear(baseVC: baseVC)
        Shared.instance.chatVcisActive = false
        ChatVC.currentTripID = nil
    }
    //MARK: initailalizer
    func initView(){
        self.jobIDLbl.setTextAlignment(aligned: .right)
        let image = UIImage(named: "send_arrow")?.withRenderingMode(.alwaysTemplate)
        self.arrowImg.image = image
        self.sendBtn.transform = isRTLLanguage ? CGAffineTransform(scaleX: -1.0, y: 1.0) : .identity
        self.arrowImg.transform = isRTLLanguage ? CGAffineTransform(scaleX: -1.0, y: 1.0) : .identity
        if let dImage = self.chatVC.driverImgLink {
            self.riderAvatar.sd_setImage(with: URL(string: dImage),
                                         placeholderImage: UIImage(named: "user_dummy"),
                                         options: .highPriority,
                                         context: nil)
        }else if let dImage = self.chatVC.driverImage{
            self.riderAvatar.image = dImage
        }else if let thumb_str = preference.string(forKey: "trip_driver_thumb_url"),
            let thumb_url = URL(string: thumb_str) {
            self.riderAvatar.sd_setImage(with: thumb_url,
                                         placeholderImage: UIImage(named: "user_dummy"),
                                         options: .highPriority,
                                         context: nil)
        }else{
            self.riderAvatar.image = UIImage(named: "user_dummy") ?? UIImage()
        }
        if let ID = ChatVC.currentTripID {
            self.jobIDLbl.text = "No #" + ID
        } else {
            self.jobIDLbl.text = "*****"
            print("ID is Missing")
        }
        
        //Set name
//        if !self.drivername.isEmpty && self.drivername != "Driver".localize{
        if !self.chatVC.drivername.isEmpty && self.chatVC.drivername != LangCommon.driver {
            self.driverName.text = self.chatVC.drivername
          }else if let name = preference.string(forKey: "trip_driver_name"){
            self.driverName.text = name
          }else{
            self.driverName.text = LangCommon.driver
         }
       
        //Set Rating
        if self.chatVC.rating != 0.0 {
            self.driverRating.isHidden = false
            let AttrStr = NSMutableAttributedString(string: "\(self.chatVC.rating) ⭑")
            AttrStr.setColorForText(textToFind: "⭑",
                                    withColor: .ThemeYellow)
            self.driverRating.attributedText = AttrStr
        }else if let str_Rating = preference.string(forKey: "trip_driver_rating"),
            let _rating = Double(str_Rating),
            _rating != 0.0{
            self.chatVC.rating = _rating
            self.driverRating.isHidden = false
            let AttrStr = NSMutableAttributedString(string: "\(_rating) ⭑")
            AttrStr.setColorForText(textToFind: "⭑", withColor: .ThemeYellow)
            self.driverRating.attributedText = AttrStr
        }else{
            self.driverRating.isHidden = true
        }
        if self.chatVC.rating == 0.0 {
            self.driverRating.isHidden = true
        }else{
            self.driverRating.isHidden = false
            let AttrStr = NSMutableAttributedString(string: "\(self.chatVC.rating) ⭑")
            AttrStr.setColorForText(textToFind: "⭑",
                                    withColor: .ThemeYellow)
            self.driverRating.attributedText = AttrStr
        }
        self.messageTextField.autocorrectionType = .no
        self.riderAvatar.isRoundCorner = true
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.messageTextField.placeholder =  LangCommon.typeMessage
        self.noChatMessage.text = LangCommon.noMsgYet
        self.bottomChatBar.border(width: 0.5,
                                  color: .gray)
        self.bottomChatBar.cornerRadius = 10
        self.chatTableView.reloadData()
    }
    func initPipeLines(){
        _ = PipeLine.createEvent(withName: "CHAT_OBSERVER") {
            ChatInteractor.instance.getAllChats(ForView : self, AndObserve: true)
        }
    }
    func initLanguage(){
        if self.chatVC.drivername.isEmpty {
            self.chatVC.drivername = LangCommon.driver.capitalized
        }
    }
    func initGesture(){
        self.chatTableView.addAction(for: .tap) {
            self.endEditing(true)
        }
        self.addAction(for: .tap) {
            self.endEditing(true)
        }
        self.bottomChatBar.addAction(for: .tap) {
            
        }
        self.chatTableRect = self.chatTableView.frame
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.chatTableRect = self.chatTableView.frame
        }
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardShowning), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardHidded), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.driverCancelledTrip), name: NSNotification.Name.cancel_Trip, object: nil)
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        guard let msg = self.messageTextField.text,!msg.isEmpty else{return}
        self.chatVC.wsToSentMessage(msg: msg)
    }
    
    @objc
    func driverCancelledTrip(){
        shouldCloseOnWillApperar = true
        self.backAction(self.backBtn!)
    }
    @objc
    func KeyboardShowning(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
 
        UIView.animate(withDuration: 0.15) {
            self.bottomChatBar.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
            
         //   var contentInsets:UIEdgeInsets
            
            if(UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation == UIInterfaceOrientation.portrait) {
                self.chatTableView.frame = CGRect(x: 10, y: 10, width: self.chatTableRect.width, height: self.chatTableRect.height - keyboardFrame.height)
              //  contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0);
            } else {
                //contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.width, right: 0.0);
                self.chatTableView.frame = CGRect(x: 10, y: 10, width: self.chatTableRect.width, height: self.chatTableRect.height - keyboardFrame.width)
            }
        //    self.chatTableView.contentInset = contentInsets
            
            let count = self.messages.count - 1
            if count > 0 {
                self.chatTableView.scrollToRow(at: IndexPath(row: count, section: 0),
                                               at: .bottom,
                                               animated: true)
            }
            self.layoutIfNeeded()
        }
    }
    //hide the keyboard
    @objc
    func KeyboardHidded(notification: NSNotification) {
        UIView.animate(withDuration: 0.15) {
            self.bottomChatBar.transform = .identity
            self.chatTableView.frame = self.chatTableRect
           // self.chatTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0);
            let count = self.messages.count - 1
            if count > 0{
                self.chatTableView.scrollToRow(at: IndexPath(row: count, section: 0),
                                               at: .bottom,
                                               animated: true)
            }
            self.layoutIfNeeded()
        }
    }
}

extension ChatView : ChatViewProtocol {
    
    func setChats(_ message: [ChatModel]) {
        self.messages = message
        if self.firstTime{
            self.chatTableView.springReloadData()
            self.firstTime = false
        } else {
            self.chatTableView.reloadData()
        }
        let count = self.messages.count - 1
        if count >= 0{
            self.chatTableView.scrollToRow(at: IndexPath(row: count, section: 0),
                                           at: .bottom,
                                           animated: true)
        }
        
    }
    
}

extension ChatView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.messages.count
        if count > 0{
            self.chatTableView.backgroundView = nil
            return count
        } else{
            self.chatTableView.backgroundView = self.chatPlaceholder
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        if message.type == .rider {
            let riderURl = URL(string: Constants().GETVALUE(keyname: "user_image"))
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverCell.identifier) as! ReceiverCell
            cell.setCell(withMessage: message, avatar: self.riderAvatar.image ?? UIImage(named: "user_dummy")!)
            cell.receiverImage.sd_setImage(with: riderURl,
                                           placeholderImage: UIImage(named: "user_dummy"),
                                           options: .highPriority,
                                           context: nil)
            cell.ThemeUpdate()
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderCell.identifier) as! SenderCell
            cell.setCell(withMessage: message,
                         avatar: self.riderAvatar.image ?? UIImage(named: "user_dummy")! )
            cell.ThemeUpdate()
            return cell
        }
    }
}

extension ChatView : UITableViewDelegate {
    
}
