//
//  FavoriteTableViewCell.swift
//  Pop
//
//  Created by Markus Jahnsrud on 05/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumArtView: AlbumArtView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(favorite: Favorite) {
        
        trackLabel.text = favorite.track
        artistLabel.text = favorite.artist
        
        if let intDuration = Int(favorite.duration ?? "") {
            durationLabel.text = intDuration.convertMillisecondsToHumanReadable()
        } else {
            durationLabel.text = ""
        }
        
        albumArtView.kf.setImage(with: URL(string: favorite.albumArtUrl ?? ""), placeholder: UIImage(named: "placeholder-album"))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
