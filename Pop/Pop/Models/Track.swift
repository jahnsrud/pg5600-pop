//
//  Track.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation
import CoreData

struct Track: Codable {
    let name: String
    let duration: String
    let artist: String
    let videoUrl: String?
    var albumArtUrl: String?
    let trackId: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "strTrack"
        case duration = "intDuration"
        case artist = "strArtist"
        case videoUrl = "strMusicVid"
        case albumArtUrl
        case trackId = "idTrack"
        
    }
    
}

struct TracksResponse: Codable {
    var track: [Track]
}

extension Favorite {
    func toTrack() -> Track {
        
        // TODO: FIX Don't unwrap
        
        /* guard let favoriteTrack = favorite.track else {
         
         } */
        
        let convertedTrack = Track(name: self.track ?? "",
                                   duration: self.duration ?? "",
                                   artist: self.artist ?? "",
                                   videoUrl: self.videoUrl,
                                   albumArtUrl: self.albumArtUrl,
                                   trackId: self.trackId ?? "")
        
        return convertedTrack
        
    }
    
}
