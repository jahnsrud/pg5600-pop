//
//  AlbumSearchCell.swift
//  Pop
//
//  Created by Markus Jahnsrud on 04/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import Kingfisher

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var albumArtView: AlbumArtView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(artist: Artist) {
        titleLabel.text = artist.name
        descriptionLabel.text = artist.name
        albumArtView.kf.setImage(with: URL(string: artist.imageUrl ), placeholder: UIImage(named: "placeholder-album"))
    }
    
    func setup(album: Album) {
        titleLabel.text = album.title
        descriptionLabel.text = album.artist
        albumArtView.kf.setImage(with: URL(string: album.albumArtUrl ?? ""), placeholder: UIImage(named: "placeholder-album"))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
