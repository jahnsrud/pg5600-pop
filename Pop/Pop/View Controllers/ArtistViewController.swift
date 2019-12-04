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
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = artist?.name
        
        collectionView.register(UINib(nibName: "AlbumGridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadDetails()
        
    }
    
    func loadDetails() {
        
        var fetchUrl = ""
        
        if let artistId = artist?.artistId {
            fetchUrl = "\(musicApiBaseUrl)album.php?i=\(artistId)"
            
        } else if var name = artist?.name {
            
            name = name.replacingOccurrences(of: " ", with: "+").lowercased()
            fetchUrl = "\(musicApiBaseUrl)searchalbum.php?s=\(name)"
            
        } else {
            print("Invalid arguments.")
            return
        }
        
        NetworkClient().fetch(url: URL(string: fetchUrl)!, completionHandler: { data, response, error in
            
            if let fetchError = error {
                print("Error: \(fetchError.localizedDescription)")
                return
            }
            
            do {
                
                if let jsonData = data {
                    let response = try JSONDecoder().decode(AlbumSearchResponse.self, from: jsonData)
                    
                    for album in response.album! {
                        self.albums.append(album)
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData(animated: true)
                        
                    }
                    
                }
                
                
            } catch let error {
                print(error)
                
            }
            
            
            
        })
        
    }
 
    func presentAlbum(_ album: Album) {
        
        let albumVC = self.storyboard?.instantiateViewController(identifier: "AlbumVC") as! AlbumViewController
        albumVC.album = album
        
        navigationController?.pushViewController(albumVC, animated: true)

    }
    
}


extension ArtistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! AlbumGridCell
        let album = albums[indexPath.item]
        
        cell.setup(album: album)
        
        return cell
        
        
    }
    
}


extension ArtistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let album = albums[indexPath.item]
        presentAlbum(album)
        
        
    }
}


extension ArtistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.size.width/2)-24, height: 240)
        
    }
}
