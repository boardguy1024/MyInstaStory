//
//  CommentTableViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/08.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import Kingfisher

protocol CommentTableViewCellDelegate {
    func goToProfileUserVC(withId userId: String)
}


class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var delegate: CommentTableViewCellDelegate?
    
    var comment: Comment? {
        didSet {
            updateComment()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped)))

    }
    @objc func nameLabelTapped() {
        if let userId = user?.id {
            delegate?.goToProfileUserVC(withId: userId)
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImg.png")
    }
    
    private func updateComment() {
        commentLabel.text = comment?.commntText
    }
    
    private func setupUserInfo() {
        nameLabel.text = user?.username
        if let profileImageUrlString = user?.profileImageUrl, let profileImageUrl = URL(string: profileImageUrlString) {
            profileImageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(named: "placeholderImg.png"))
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
