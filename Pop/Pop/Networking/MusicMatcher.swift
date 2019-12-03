//
//  MusicMatcher.swift
//  Pop
//
//  Created by Markus Jahnsrud on 03/12/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation

let url = "https://itunes.apple.com/search?term=jack+johnson&limit=25"

struct MusicMatcher {
    func tryMatchingTrackWithAppleMusic() {
        
        /**
         WRONG CODE
         */
        
        let url = "\(musicApiBaseUrl)mostloved.php?format=album"
               
               NetworkClient().fetch(url: URL(string: url)!, completionHandler: { data, response, error in
                   
                   if (error != nil) {
                       print("Error: \(error?.localizedDescription ?? "Something went wrong.")")
                       return
                   }
                   
                   do {
                       
                       if let jsonData = data {
                           let response = try JSONDecoder().decode(Response.self, from: jsonData)
                           
                           for album in response.loved {
                               // self.albums.append(album)
                           }
                           
                       }
                       
                       
                   } catch let error {
                       print(error)
                       
                   }
                   
               })
    }
}
