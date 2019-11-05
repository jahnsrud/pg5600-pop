//
//  TableViewExtensions.swift
//  Pop
//
//  Created by Markus Jahnsrud on 05/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func reloadData(animated: Bool) {
        
        DispatchQueue.main.async {
            if animated {
                self.reloadSections(IndexSet(integer: 0), with: .automatic)
            } else {
                self.reloadData()
            }
            
        }
        
    }
    
}
