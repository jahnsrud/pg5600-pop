//
//  ArtistCell.swift
//  Pop
//
//  Created by Markus Jahnsrud on 03/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.backgroundColor = .black
        iconView.layer.cornerRadius = iconView.bounds.size.width/2
        iconView.layer.masksToBounds = true
        
        imageView.image = #imageLiteral(resourceName: "icon-pop-text")
        imageView.backgroundColor = .clear
        
    }
    
    func setup(artist: Artist) {
        artistLabel.text = artist.name
        
    }
    
}
