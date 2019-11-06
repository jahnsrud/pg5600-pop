//
//  Color.swift
//  Pop
//
//  Created by Markus Jahnsrud on 06/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

extension UIColor {
    
    // https://stackoverflow.com/a/43365841
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                             green: .random(in: 0...1),
                             blue: .random(in: 0...1),
                             alpha: 1.0)
    }
}
