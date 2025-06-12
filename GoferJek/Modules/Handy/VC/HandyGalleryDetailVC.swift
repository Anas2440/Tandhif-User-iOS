//
//  HandyGalleryDetailVC.swift
//  GoferHandy
//
//  Created by trioangle on 23/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

class HandyGalleryDetailVC: BaseViewController {
    
    //--------------------------------------
    //MARK:- Variables
    //--------------------------------------
    
    var imageListArray:Array<String> = []
    var selectedIndex : IndexPath!
    var fromFrame : CGRect!
    var image : UIImage?
    
    //--------------------------------------
    //MARK:- Outlets
    //--------------------------------------
    
    @IBOutlet var handyGalleryDetailView: HandyGalleryDetailView!
    
    //--------------------------------------
    //MARK:- View cycles
    //--------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //--------------------------------------
    //MARK:- initWithStory
    //--------------------------------------
    
    class func initWithStory(fromFrame : CGRect,
                             image : UIImage?,
                             withItem items : [String],
                             selectedIndex : IndexPath) -> HandyGalleryDetailVC {
      let view : HandyGalleryDetailVC = UIStoryboard.gojekHandyUnique.instantiateViewController()
        view.fromFrame = fromFrame
        view.image = image
        view.imageListArray = items
        view.selectedIndex = selectedIndex
      return view
    }
    
}
