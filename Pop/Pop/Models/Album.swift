//
//  Album.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation

struct Album: Codable {
    let title: String
    let artist: String
    let albumArtUrl: String?
    let yearReleased: String
    let identifier: String
    let genre: String?

    
    private enum CodingKeys: String, CodingKey {
        case title = "strAlbum"
        case artist = "strArtist"
        case albumArtUrl = "strAlbumThumb"
        case yearReleased = "intYearReleased"
        case identifier = "idAlbum"
        case genre = "strGenre"
        
    }
    
    
}

struct Response: Codable {
    var loved: [Album]
}

struct AlbumSearchResponse: Codable {
    var album: [Album]?
}

