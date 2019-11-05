//
//  ArtistViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 03/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {
    
    var artist: Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = artist?.name
        
    }
    
}
