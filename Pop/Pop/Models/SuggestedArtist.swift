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
}

struct SuggestionsResponse: Codable {
    var results: [Suggestions]
    
    private enum CodingKeys: String, CodingKey {
        case results = "Similar"
        
    }
}

struct Suggestions: Codable {
    var suggestions: [SuggestedArtist]
    
    private enum CodingKeys: String, CodingKey {
        case suggestions = "Results"
        
    }
}

