//
//  JobImageTVC.swift
//  GoferHandy
//
//  Created by trioangle on 22/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
protocol NavigateGalleryItemProtocol {
    func navigateToGalleryDetail(image : UIImage?,
                                 from frame : CGRect,
                                 with snaps : [String],
                                 selectedIndex : IndexPath)
}
class JobImageTVC: UITableViewCell {

    @IBOutlet weak var collectionView : UICollectionView!
    var navigationDelegate : NavigateGalleryItemProtocol?
    
    var images = [JobSnapImage]()
    var parentTableView : UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerNib(forCell: JobImageCVC.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.ThemeUpdate()
        // Initialization code
    }

    func ThemeUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.collectionView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension JobImageTVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : JobImageCVC = collectionView.dequeueReusableCell(for: indexPath)
        guard let image = self.images.value(atSafe: indexPath.row) else{return cell}
        cell.jobIV.sd_setImage(with: URL(string: image.image), completed: nil)
        cell.jobIV.contentMode = .scaleAspectFill
        cell.ThemeUpdate()
        return cell
    }
    
    
    
}
extension JobImageTVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? JobImageCVC,
            let _parentTableView = self.parentTableView else{return}
        //frame on collection view
        let frame = collectionView.convert(cell.frame, to: _parentTableView)
        self.navigationDelegate?
            .navigateToGalleryDetail(image: cell.jobIV.image,
                                     from: frame,
                                     with: images.compactMap({$0.image}),
                                     selectedIndex: indexPath)
    }
}
extension JobImageTVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 80, height: 80)
    }
}
