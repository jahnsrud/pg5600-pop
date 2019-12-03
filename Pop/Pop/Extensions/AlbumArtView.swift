//
//  AlbumArtView.swift
//  Pop
//
//  Created by Markus Jahnsrud on 04/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class AlbumArtView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
        
    }
    
    func applyStyle() {
        // self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        // self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "AlbumArtBorder")?.cgColor
        
    }
    
}
