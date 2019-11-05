//
//  AlbumListCell.swift
//  Pop
//
//  Created by Markus Jahnsrud on 03/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class AlbumListCell: UICollectionViewCell {

    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumArtView: AlbumArtView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
