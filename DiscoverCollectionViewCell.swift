//
//  DiscoverCollectionViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/19.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

protocol DiscoverCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var delegate: DiscoverCollectionViewCellDelegate?

    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        if let photoUrlString = post?.photoUrl, let url = URL(string: photoUrlString) {
            photoImageView.sd_setImage(with: url)
            
            photoImageView.isUserInteractionEnabled = true
            photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped)))
        }
    }
    
    func photoImageViewTapped() {
        if let postId = post?.id {
            delegate?.goToDetailVC(postId: postId)
        }
    }

}
