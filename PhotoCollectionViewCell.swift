//
//  PhotoCollectionViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/12.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var delegate: PhotoCollectionViewCellDelegate?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        if let photoUrlString = post?.photoUrl, let url = URL(string: photoUrlString) {
            photoImageView.kf.setImage(with: url)
        }
        
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped)))
    }
    
    @objc func photoImageViewTapped() {
        if let postId = post?.id {
            delegate?.goToDetailVC(postId: postId)
        }
    }
}
