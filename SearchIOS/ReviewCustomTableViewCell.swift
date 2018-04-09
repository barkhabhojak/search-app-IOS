//
//  ReviewCustomTableViewCell.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/9/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewText: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
