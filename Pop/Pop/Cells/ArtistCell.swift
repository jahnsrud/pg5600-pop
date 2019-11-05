//
//  ArtistCell.swift
//  Pop
//
//  Created by Markus Jahnsrud on 03/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: AlbumArtView!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
