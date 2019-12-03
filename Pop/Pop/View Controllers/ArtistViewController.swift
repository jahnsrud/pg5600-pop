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
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = artist?.name
        loadDetails()
        
    }
    
    func loadDetails() {
        
        if let artistId = artist?.artistId {
            
            let url = "\(musicApiBaseUrl)album.php?i=\(artistId)"
            
            NetworkClient().fetch(url: URL(string: url)!, completionHandler: { data, response, error in
                
                if let fetchError = error {
                    print("Error: \(fetchError.localizedDescription)")
                    return
                }
                
                do {
                    
                    if let jsonData = data {
                        let response = try JSONDecoder().decode(AlbumSearchResponse.self, from: jsonData)
                        
                        for album in response.album! {
                            print("Album: \(album.title)")
                            self.albums.append(album)
                            
                        }
                        
                        DispatchQueue.main.async {
                            // self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                        }
                        
                    }
                    
                    
                } catch let error {
                    print(error)
                    
                }
                
                
                
            })
            
        }
        
    }
    
    
}
