//
//  CollectionViewExtensions.swift
//  Pop
//
//  Created by Markus Jahnsrud on 03/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func reloadData(animated: Bool) {
        
        DispatchQueue.main.async {
            if animated {
                self.reloadSections(IndexSet(integer: 0))
            } else {
                self.reloadData()
            }
            
        }
        
    }
    
}
