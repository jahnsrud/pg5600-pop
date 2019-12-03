//
//  ActionButton.swift
//  Pop
//
//  Created by Markus Jahnsrud on 03/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
        
    }
    
    func applyStyle() {
        layer.cornerRadius = 4
        layer.masksToBounds = true
        backgroundColor = UIColor(named: "ActionColor")
        tintColor = .white
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
    }
    
    
}
