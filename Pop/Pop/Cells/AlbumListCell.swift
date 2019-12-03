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
    @IBOutlet weak var albumArtView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(album: Album) {
        albumLabel.text = album.title
        artistLabel.text = album.artist
        albumArtView.kf.setImage(with: URL(string: album.albumArtUrl ?? ""), placeholder: UIImage(named: "placeholder-album"))
        albumArtView.layer.cornerRadius = 4
        
        configureUI()
        
        
    }
    
    func configureUI() {
        backgroundColor = UIColor(named: "AlbumCellBackground")
        
        layer.masksToBounds = false
        layer.cornerRadius = 4
        if traitCollection.userInterfaceStyle == .dark {
            addShadow()
        }
        
        
        
        
    }
    
    
    func addShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2.0
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .dark {
            removeShadow()
        } else {
            addShadow()
        }
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0
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
