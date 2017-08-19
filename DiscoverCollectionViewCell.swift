//
//  DiscoverCollectionViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/19.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        if let photoUrlString = post?.photoUrl, let url = URL(string: photoUrlString) {
            photoImageView.sd_setImage(with: url)
        }
    }

}
