//
//  SuggestedArtist.swift
//  Pop
//
//  Created by Markus Jahnsrud on 04/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation

struct SuggestedArtist: Codable {
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        
    }
}



struct SuggestionsResponse: Codable {
    let similar: Similar
    
    enum CodingKeys: String, CodingKey {
        case similar = "Similar"
    }
}

struct Similar: Codable {
    let results: [SuggestedArtist]

    enum CodingKeys: String, CodingKey {
        case results = "Results"
    }
}
