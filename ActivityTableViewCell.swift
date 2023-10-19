//
//  ActivityTableViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2019/02/04.
//  Copyright © 2019 park kyung suk. All rights reserved.
//

import UIKit
import Kingfisher

class ActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var notification: Notification? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView() {
        
    }
    
    func setupUserInfo() {
        usernameLabel.text = user?.username
        if let photoUrl = user?.profileImageUrl, let url = URL(string: photoUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImg"))
        }
    }
}
