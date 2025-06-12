//
//  GroupTableViewCell.swift
//  GoferHandy
//
//  Created by trioangle on 27/08/8.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    enum Position{
        case start,mid,end,single
    }
    @IBOutlet weak var cardView : UIView?
    @IBOutlet weak var cardLeading : NSLayoutConstraint?
    @IBOutlet weak var cardTrailing : NSLayoutConstraint?
    @IBOutlet weak var cardTop : NSLayoutConstraint?
    @IBOutlet weak var cardBottom : NSLayoutConstraint?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setPosition(totalItems itemsCount: Int,forIndex indexPath : IndexPath){
        if itemsCount == 1{
            self.setCell(position: .single)
        }else if indexPath.row == 0{
            self.setCell(position: .start)
        }else if indexPath.row == itemsCount - 1{
            self.setCell(position: .end)
        }else{
            self.setCell(position: .mid)
        }
    }
    func setCell(position : Position){
        self.cardView?.layer.masksToBounds = false
        self.cardLeading?.constant = 8
        self.cardTrailing?.constant = 8
        self.cardTop?.constant = 0
        self.cardBottom?.constant = 0
        
        switch position {
        case .start:
            self.cardTop?.constant = 5
            self.cardBottom?.constant = -5
            if let _cardView = self.cardView{
                
//                _cardView.roundCorners(corners: [.topLeft,.topRight], radius: 8)
                _cardView.cornerRadius = 5
   
            }
            
        case .mid:
            
            self.cardView?.layer.mask = nil
            self.cardView?.cornerRadius = 0

            
        case .end:
        self.cardTop?.constant = -5
            self.cardBottom?.constant = 5
            if let _cardView = self.cardView{
                
//                _cardView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 8)
                _cardView.cornerRadius = 5
            }
            
        case .single:
            self.cardTop?.constant = 5
            self.cardBottom?.constant = 5
            if let _cardView = self.cardView{
                self.cardView?.layer.mask = nil
                _cardView.cornerRadius = 8
          
            }
        }
        self.contentView.layoutIfNeeded()
        self.cardView?.layoutIfNeeded()
        self.contentView.layoutSubviews()
        self.cardView?.layoutIfNeeded()
        
    }
}
class BaseTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
