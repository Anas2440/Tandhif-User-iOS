//
//  ChatVC.swift
//  Gofer
//
//  Created by Trioangle Technologies on 07/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatVC: BaseViewController {
    
    
    @IBOutlet var chatView: ChatView!
    

    
    var driverImage : UIImage?
    var driverImgLink : String?
    var riderImgLink : String?
    static var currentTripID : String? = nil
    var drivername = String()
    var rating = 0.0
    var driverId : Int!
    var typeCon:ConversationType = .u2d
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self,
                                                  name: .ChatRefresh,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshChat),
                                               name: .ChatRefresh,
                                               object: nil)
    }
    @objc func refreshChat(){
        ChatInteractor.instance.getAllChats(ForView : self.chatView,
                                            AndObserve: true)
    }
    
    //MARK: init with story
    class func initWithStory(withTripId trip_id:String,
                             driverRating : Double?,
                             driver_id : Int,
                             imageURL : String?,
                             name : String?,
                             typeCon:ConversationType) -> ChatVC{
        let view : ChatVC = UIStoryboard.gojekCommon.instantiateViewController()
        ChatVC.currentTripID = trip_id
        ChatInteractor.instance.initialize(withTrip: trip_id,
                                           type: typeCon)
        if let _rating = driverRating{
            view.rating = _rating
        }
        view.typeCon = typeCon
        view.driverId = driver_id
        if let _name = name{
            view.drivername = _name
        }
        view.driverImgLink = imageURL
        
        view.modalPresentationStyle = .fullScreen
        return view
    }
    
    func wsToSentMessage(msg : String) {
        var param = ["receiver_id": self.driverId.description,
                     "message":msg]
        param["job_id"] = ChatVC.currentTripID
        param["type_of_conversation"] = self.typeCon.rawValue
        ConnectionHandler.shared.getRequest(for: .sendMessage,
                                               params: param)
            .responseJSON({ json in
                if json.isSuccess {
                    print(json)
                }
            })
            .responseFailure({ error in
                print(error)
            })
        //to fire base
        let chat = ChatModel(message: msg, type: .rider)
        ChatInteractor.instance.append(message: chat)
        if self.chatView.messages.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ChatInteractor.instance.getAllChats(ForView: self.chatView, AndObserve: true)
            }
        }
        self.chatView.messageTextField.text = String()
    }
    
    
}



//MARK: Cells

class SenderCell : UITableViewCell{
    @IBOutlet weak var messageLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var avatarImage : UIImageView!
    @IBOutlet weak var background : UIView!
    
    static var identifier = "SenderCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageLbl.textColor = .SecondaryTextColor
        self.selectionStyle = .none
        self.ThemeUpdate()
    }
    func ThemeUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    func setCell(withMessage message: ChatModel,avatar : UIImage){
        self.messageLbl.text = message.message
        self.avatarImage.image = avatar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.background.clipsToBounds = true
            self.avatarImage.clipsToBounds = true
            self.avatarImage.cornerRadius = 10
            self.background.cornerRadius = 10
        }
        self.background.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        self.messageLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
}
class ReceiverCell : UITableViewCell{
    @IBOutlet weak var messageLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var background : UIView!
    @IBOutlet weak var receiverImage: UIImageView!
    
    static var identifier = "ReceiverCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.ThemeUpdate()
    }
    
    func ThemeUpdate() {
        self.contentView.backgroundColor  = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.messageLbl.textColor = .PrimaryTextColor
    }
    
    func setCell(withMessage message: ChatModel,avatar : UIImage){
        self.messageLbl.text = message.message
        self.receiverImage.image = avatar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.background.clipsToBounds = true
            self.receiverImage.clipsToBounds = true
            self.receiverImage.cornerRadius = 10
            self.background.cornerRadius = 10
        }
        self.background.backgroundColor = .PrimaryColor
    }
    
}
