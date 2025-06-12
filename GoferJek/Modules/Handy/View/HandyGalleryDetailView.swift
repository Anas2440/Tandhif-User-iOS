//
//  HandyGalleryDetailView.swift
//  GoferHandy
//
//  Created by trioangle on 23/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

class HandyGalleryDetailView: BaseView{
    
    //----------------------------------------
    //MARK:- Variables
    //----------------------------------------
    
    var viewController : HandyGalleryDetailVC!
    lazy var hoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //----------------------------------------
    //MARK:- Outlets
    //----------------------------------------
    
    @IBOutlet weak var pageControl: CommonPageControl!
    @IBOutlet weak var galleryCollection: UICollectionView!
    @IBOutlet weak var screenTitle: SecondaryHeaderLabel!
    @IBOutlet weak var navView : HeaderView!
    @IBOutlet weak var itemOfLbl : PrimaryColoredHeaderLabel!
    @IBOutlet weak var gradientView : UIView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    
    //----------------------------------------
    //MARK:- Actions
    //----------------------------------------
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.viewController.dismiss(animated: false, completion: nil)
    }
    
    //----------------------------------------
    //MARK:- View Cycles
    //----------------------------------------
    
    override
    func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? HandyGalleryDetailVC
        self.initView()
        self.darkModeChange()
    }
    
    override
    func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.prepareView()
        self.galleryCollection.scrollToItem(at: self.viewController.selectedIndex,
                                            at: .right, animated: false)
        self.pageControl.currentPage = self.viewController.selectedIndex.row
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.contentHolderView.customColorsUpdate()
        self.navView.customColorsUpdate()
        self.screenTitle.customColorsUpdate()
        self.gradientView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.galleryCollection.reloadData()
    }
    
    override
    func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
            self.animateView()
    }
    
    //----------------------------------------
    //MARK:- initializers
    //----------------------------------------
    
    func initView(){
        self.addSubview(self.hoverImageView)
        self.bringSubviewToFront(self.hoverImageView)
        self.galleryCollection.showsHorizontalScrollIndicator = false
        self.galleryCollection.showsVerticalScrollIndicator = false
      self.screenTitle.text = ""
      self.itemOfLbl.text = "\(self.viewController.selectedIndex.item +  1) \(LangCommon.of) \(self.viewController.imageListArray.count)"
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
          self.pageControl.currentPage = self.viewController.selectedIndex.item
        }
        self.galleryCollection.delegate = self
        self.galleryCollection.dataSource = self
        self.pageControl.numberOfPages = self.viewController.imageListArray.count
        self.gradientView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.galleryCollection.reloadData()
    }
    
    //----------------------------------------
    //MARK:- UDF
    //----------------------------------------
    
    func prepareView(){
        self.layoutIfNeeded()
        self.galleryCollection.alpha = 0
        self.hoverImageView.cornerRadius = 8
        self.hoverImageView.frame = self.viewController.fromFrame
        self.hoverImageView.image = self.viewController.image
        self.layoutIfNeeded()
        self.pageControl.alpha = 0
        self.navView.alpha = 0
        self.gradientView.alpha = 0
        self.itemOfLbl.alpha = 0
    }
    
    func animateView(){
        UIView.animateKeyframes(
            withDuration: 0.8,
            delay: 0,
            options: [.layoutSubviews],
            animations: {
                UIView
                    .addKeyframe(
                        withRelativeStartTime: 0.0,
                        relativeDuration: 0.5) {
                            self.hoverImageView.cornerRadius = 0
                            self.hoverImageView.frame = self.galleryCollection.frame
                            self.layoutIfNeeded()
                            self.layoutIfNeeded()
                }
                UIView
                    .addKeyframe(
                        withRelativeStartTime: 0.5,
                        relativeDuration: 0.5) {
                            
                            self.pageControl.alpha = 1
                            self.navView.alpha = 1
                            self.gradientView.alpha = 1
                            self.itemOfLbl.alpha = 1
                }
        }) { (completed) in
            guard completed else{return}
            self.hoverImageView.isHidden = true
            self.galleryCollection.alpha = 1
            self.galleryCollection.reloadData()
        }
    }
}

extension HandyGalleryDetailView : UICollectionViewDelegate,UICollectionViewDataSource{
    
    //--------------------------------------------------
    //MARK:- Collection View delegate and datasource
    //--------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewController.imageListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.viewController.imageListArray.value(atSafe: indexPath.row)
        let cell : GalleryDetailCVC = galleryCollection.dequeueReusableCell(for: indexPath)
        let url = URL(string: model ?? "")
        cell.detailedImage.sd_setImage(with: url, placeholderImage:nil)
        cell.themeUpdate()
        return cell
    }
}

extension HandyGalleryDetailView : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
extension HandyGalleryDetailView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index =  self.galleryCollection.indexPathsForVisibleItems.last ,
           let indexofExact = self.galleryCollection.indexPathForItem(at: scrollView.contentOffset) {
            print("å:: index From Previous : \(index.item)")
            print("å:: index New : \(indexofExact.item)")
            self.itemOfLbl.text = "\(indexofExact.item + 1) \(LangCommon.of) \(self.viewController.imageListArray.count)"
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let index =  self.galleryCollection.indexPathsForVisibleItems.last ,
           let indexofExact = self.galleryCollection.indexPathForItem(at: scrollView.contentOffset) {
            print("å:: index From Previous : \(index.item)")
            print("å:: index New : \(indexofExact.item)")
            self.itemOfLbl.text = "\(indexofExact.item + 1) \(LangCommon.of) \(self.viewController.imageListArray.count)"
        }
    }
    
}
