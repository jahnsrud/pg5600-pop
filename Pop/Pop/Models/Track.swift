//
//  Track.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation

struct Track: Codable {
    let name: String
    let duration: String
    let artist: String
    let videoUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "strTrack"
        case duration = "intDuration"
        case artist = "strArtist"
        case videoUrl = "strMusicVid"
        
    }
    
}

struct TracksResponse: Codable {
    var track: [Track]
}
