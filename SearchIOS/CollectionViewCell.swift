//
//  CollectionViewCell.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/8/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    func displayContent(image: UIImage) {
        photoImage.image = image
    }
}
