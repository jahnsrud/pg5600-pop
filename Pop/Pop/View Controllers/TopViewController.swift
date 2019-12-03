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
        
        collectionView.backgroundColor = UIColor(named: "Background")
        
        configureCollectionView()
        checkFirstLaunch()
        
        updateLayout()
        getTopAlbums()
        
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "AlbumGridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
        collectionView.register(UINib(nibName: "AlbumListCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        
    }
    
    func checkFirstLaunch() {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "firstLaunch") {
            presentFirstLaunch()
            defaults.set(false, forKey: "firstLaunch")
            
        }
        
    }
    
    func getTopAlbums() {
        
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
                        self.albums.append(album)
                    }
                    
                    self.collectionView.reloadData(animated: true)
                }
                
                
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
        
        print("Switching to \(layoutType)")
        
        updateLayout()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.collectionView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
            
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.1, animations: {
                       self.collectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)})
        
        
        // Scroll to top to avoid confusion
        collectionView.setContentOffset(CGPoint.zero, animated: true)
        
    }
    
    func updateLayout() {
        
        let savedLayoutType: String = UserDefaults.standard.object(forKey: "layoutType") as! String
        
        if savedLayoutType == "grid" {
            layoutBarButtonItem.image = UIImage(systemName: "list.bullet")
            layoutType = .grid
            
        } else {
            layoutBarButtonItem.image = UIImage(systemName: "square.grid.2x2")
            layoutType = .list
            
        }
        
        collectionView.reloadData(animated: false)
        
    }
    
    func presentAlbum(_ album: Album) {
        
        let albumVC = self.storyboard?.instantiateViewController(identifier: "AlbumVC") as! AlbumViewController
        albumVC.album = album
        
        navigationController?.pushViewController(albumVC, animated: true)
    }
    
    func presentFirstLaunch() {
        guard let firstLaunch = self.storyboard?.instantiateViewController(identifier: "FirstLaunch") else {
            return
            
        }
        
        present(firstLaunch, animated: true, completion: nil)
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
            return CGSize(width: collectionView.bounds.size.width-30, height: 74)
        } else {
            return CGSize(width: (collectionView.bounds.size.width/2)-24, height: 240)
        }
    }
}
