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
        
        backgroundColor = .systemBackground
        
        layer.masksToBounds = false
        backgroundColor = .white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2.0
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
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
