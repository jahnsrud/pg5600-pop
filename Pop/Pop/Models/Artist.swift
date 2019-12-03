//
//  Artist.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation

struct Artist: Codable {
    let name: String
    let artistId: String?
    let imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "strArtist"
        case artistId = "idArtist"
        case imageUrl = "strArtistThumb"
        
    }
}

struct ArtistResponse: Codable {
    let artists: [Artist]?
}
