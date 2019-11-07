//
//  AlbumListCell.swift
//  Pop
//
//  Created by Markus Jahnsrud on 03/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumListCell: UICollectionViewCell {
    
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumArtView: AlbumArtView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(album: Album) {
        albumLabel.text = album.title
        artistLabel.text = album.artist
        albumArtView.kf.setImage(with: URL(string: album.albumArtUrl ?? ""), placeholder: UIImage(named: "placeholder-album"))
        
        backgroundColor = .white
        
        /*
        Border testing: 
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true;
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false;
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
        */
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                alpha = 0.6
            } else {
                alpha = 1.0
            }
        }
    }
    
}
