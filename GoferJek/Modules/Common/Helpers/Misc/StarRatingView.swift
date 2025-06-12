//
//  StarRatingView.swift
//  PassUp
//
//  Created by trioangle on 06/01/20.
//  Copyright © 2020 Trioangle Technology. All rights reserved.
//

import UIKit

enum StarRatingEnum: Int {
    case star1 = 1
    case star2 = 2
    case star3 = 3
    case star4 = 4
    case star5 = 5
    case none
}


protocol CustomRatingViewProtocol {
    func updateRatingValue(rating:StarRatingEnum)
}

class StarRatingView: UIView {

    @IBOutlet weak var starBtn1: UIButton!
    
    @IBOutlet weak var starBtn2: UIButton!
    
    @IBOutlet weak var starBtn3: UIButton!
    
    @IBOutlet weak var starBtn4: UIButton!
    
    @IBOutlet weak var starBtn5: UIButton!
    
   
    var delegate:CustomRatingViewProtocol?
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.starBtn1.alpha = 1
        self.starBtn2.alpha = 1
        self.starBtn3.alpha = 1
        self.starBtn4.alpha = 1
        self.starBtn5.alpha = 1
        
        self.unSelectedRate(self.starBtn5)
        self.unSelectedRate(self.starBtn4)
        self.unSelectedRate(self.starBtn3)
        self.unSelectedRate(self.starBtn2)
        self.unSelectedRate(self.starBtn1)
        
        
//        self.starBtn1.
//        self.starBtn2.imageView.con
        
        self.starBtn1.addTarget(self, action: #selector(self.star1Action(_:)), for: .touchUpInside)
        self.starBtn2.addTarget(self, action: #selector(self.star2Action(_:)), for: .touchUpInside)
        self.starBtn3.addTarget(self, action: #selector(self.star3Action(_:)), for: .touchUpInside)
        self.starBtn4.addTarget(self, action: #selector(self.star4Action(_:)), for: .touchUpInside)
        self.starBtn5.addTarget(self, action: #selector(self.star5Action(_:)), for: .touchUpInside)
        
        
    }
    
    
    func unSelectedRate(_ sender:UIButton) {
//        sender.titleLabel?.font = UIFont(name: "makent1", size: 22)
//        sender.setTitle("V", for: .normal)
        sender.setImage(UIImage(named: "StarEmpty")?.withRenderingMode(.alwaysOriginal), for: .normal)
       
        
       
        
        
    }
    
    func selectedRate(_ sender:UIButton) {
//        sender.titleLabel?.font = UIFont(name: "makent1", size: 22)
//        sender.setTitle("U", for: .normal)
        sender.setImage(UIImage(named: "StarFull")?.withRenderingMode(.alwaysTemplate), for: .normal)
        sender.tintColor = UIColor(hex: "F8C109")

        
    }
    
    @objc func star1Action(_ sender:UIButton){
        self.updateStartRatingValue(ratingValue: .star1)
    }
       
    @objc func star2Action(_ sender:UIButton) {
        self.updateStartRatingValue(ratingValue: .star2)
    }
       
    @objc func star3Action(_ sender:UIButton){
        self.updateStartRatingValue(ratingValue: .star3)
    }
       
    @objc func star4Action(_ sender:UIButton){
        self.updateStartRatingValue(ratingValue: .star4)
    }
    
    @objc func star5Action(_ sender:UIButton){
        self.updateStartRatingValue(ratingValue: .star5)
    }
    
    func updateStartRatingValue(ratingValue:StarRatingEnum) {
        
        self.setButtonTitle(rating:ratingValue)
        self.delegate?.updateRatingValue(rating: ratingValue)
        
    }
    
    func setButtonTitle(rating:StarRatingEnum){
        
        switch rating {
       
        case .star1:
            self.selectedRate(starBtn1)
            self.unSelectedRate(starBtn2)
            self.unSelectedRate(starBtn3)
            self.unSelectedRate(starBtn4)
            self.unSelectedRate(starBtn5)
            
        case .star2:
            self.selectedRate(starBtn1)
            self.selectedRate(starBtn2)
            self.unSelectedRate(starBtn3)
            self.unSelectedRate(starBtn4)
            self.unSelectedRate(starBtn5)
            
            
        case .star3:
            self.selectedRate(starBtn1)
            self.selectedRate(starBtn2)
            self.selectedRate(starBtn3)
            self.unSelectedRate(starBtn4)
            self.unSelectedRate(starBtn5)
            
        case .star4:
            self.selectedRate(starBtn1)
            self.selectedRate(starBtn2)
            self.selectedRate(starBtn3)
            self.selectedRate(starBtn4)
            self.unSelectedRate(starBtn5)
            
        case .star5:
           self.selectedRate(starBtn1)
           self.selectedRate(starBtn2)
           self.selectedRate(starBtn3)
           self.selectedRate(starBtn4)
           self.selectedRate(starBtn5)
        case .none:
            self.unSelectedRate(self.starBtn1)
            self.unSelectedRate(self.starBtn2)
            self.unSelectedRate(self.starBtn3)
            self.unSelectedRate(self.starBtn4)
            self.unSelectedRate(self.starBtn5)
        }
    }
}
