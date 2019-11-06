//
//  AlbumSearchCell.swift
//  Pop
//
//  Created by Markus Jahnsrud on 04/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var albumArtView: AlbumArtView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
