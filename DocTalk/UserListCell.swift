//
//  UserListCell.swift
//  DocTalk
//
//  Created by Uniqolabel Developer on 19/04/18.
//  Copyright © 2018 GeekGuns. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet var userAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
