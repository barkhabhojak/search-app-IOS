//
//  CustomTableViewCell.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/7/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import EasyToast

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    //@IBOutlet weak var favorites: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    var placeId = ""
    var fav = false
    @IBOutlet weak var favorites: UIButton!
    
    @IBAction func onClickFav(_ sender: Any) {
        print("click")
        if fav {
            fav = false
            favorites.setImage(UIImage(named: "favorite-empty"), for: [])
            var string = name.text! + " was removed from favorites."
            superview?.showToast(string, position: .bottom, popTime: 2, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
        }
        else {
            fav = true
            var string = name.text! + " was added to favorites."
            superview?.showToast(string, position: .bottom, popTime: 2, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
            favorites.setImage(UIImage(named: "favorite-filled"), for: [])
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

}
