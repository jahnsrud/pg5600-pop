//
//  TopViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 28/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

enum Layout {
    case grid
    case list
}

class TopViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutBarButtonItem: UIBarButtonItem!
    
    var albums = [Album]()
    
    var layoutType = Layout.grid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "AlbumGridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
        collectionView.register(UINib(nibName: "AlbumListCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        
        updateLayout()
        getData()
        
    }
    
    func getData() {
        
        let url = "\(musicApiBaseUrl)mostloved.php?format=album"
        
        let handler = NetworkHandler()
        
        handler.getData(url: URL(string: url)!, completionHandler: { data, response, error in
            
            if (error != nil) {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            do {
                
                let response = try JSONDecoder().decode(Response.self, from: data!)
                
                for album in response.loved {
                    // print(album.title)
                    self.albums.append(album)
                }
                
                self.collectionView.reloadData(animated: true)
                
                
            } catch let error {
                print(error)
                
            }
            
        })
        
        
    }
    
    @IBAction func switchLayout(_ sender: Any) {
        
        // Saving the selected layout to UserDefaults
        
        switch layoutType {
        case .grid:
            UserDefaults.standard.set("list", forKey: "layoutType")
        case .list:
         UserDefaults.standard.set("grid", forKey: "layoutType")
       
        }
        
        // Scroll to top to avoid confusion
        // TODO: Improve
        
        collectionView.setContentOffset(CGPoint.zero, animated: true)
        
        print("Switching to \(layoutType)")
        
        updateLayout()
        
    }
    
    func updateLayout() {
        
        let savedLayoutType: String = UserDefaults.standard.object(forKey: "layoutType") as! String
        
        if savedLayoutType == "grid" {
            layoutBarButtonItem.image = UIImage(named: "icon-list")
            layoutType = .grid
            
        } else {
            layoutBarButtonItem.image = UIImage(named: "icon-grid")
            layoutType = .list
            
        }
        
        collectionView.reloadData(animated: true)
        
    }
    
    func presentAlbum(_ album: Album) {
        
        let albumVC = self.storyboard?.instantiateViewController(identifier: "AlbumVC") as! AlbumViewController
        albumVC.album = album
        
        navigationController?.pushViewController(albumVC, animated: true)
    }
}

extension TopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch layoutType {
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! AlbumGridCell
            let album = albums[indexPath.item]
            
            cell.setup(album: album)
            
            
            return cell
            
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! AlbumListCell
            let album = albums[indexPath.item]
            cell.setup(album: album)
            
            return cell
        }
    }
    
    
}

extension TopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let album = albums[indexPath.item]
        presentAlbum(album)
        
        
    }
}

extension TopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if layoutType == .list {
            return CGSize(width: collectionView.bounds.size.width, height: 80)
        } else {
            return CGSize(width: (collectionView.bounds.size.width/2)-16, height: 230)
        }
    }
}
