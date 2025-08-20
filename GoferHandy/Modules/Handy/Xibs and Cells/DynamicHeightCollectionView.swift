//
//  DynamicHeightCollectionView.swift
//  GoferHandy
//
//  Created by Anas Parekh on 05/08/25.
//


// In a new file: DynamicHeightCollectionView.swift

import UIKit

/// A collection view that automatically adjusts its height to fit its content.
class DynamicHeightCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        // If the bounds have changed, we need to invalidate our intrinsic size
        if !bounds.size.equalTo(intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        // The natural size of this view is the size of its content
        return self.collectionViewLayout.collectionViewContentSize
    }
}