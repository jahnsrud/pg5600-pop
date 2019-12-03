//
//  AlbumGridCell.swift
//  Pop
//
//  Created by Markus Jahnsrud on 29/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumGridCell: UICollectionViewCell {
    
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumArtView: AlbumArtView!
    @IBOutlet weak var chartNumberView: UIView!
    @IBOutlet weak var chartNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(album: Album) {
        albumLabel.text = album.title
        artistLabel.text = album.artist
        albumArtView.kf.setImage(with: URL(string: album.albumArtUrl ?? ""), placeholder: UIImage(named: "placeholder-album"))
        
        configureUI()
        
    }
    
    func configureUI() {
        layer.cornerRadius = 4
        layer.masksToBounds = false
        backgroundColor = .white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2.0
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
        
        chartNumberView.layer.cornerRadius = chartNumberView.bounds.size.width/2
        chartNumberView.isHidden = true

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
