//
//  TrackViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class TrackViewController: UIViewController {
    
    var track: Track?
    var isFavorited = false
    var favorite: Favorite?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTrack()
        
    }
    
    func loadTrack() {
        title = track?.name
        
        if var videoUrl = track?.videoUrl {
            
            videoUrl = videoUrl.replacingOccurrences(of: "http://", with: "https://")
            print(videoUrl)
            
            if videoUrl.count > 0 {
                // webView.load(URLRequest(url: URL(string: videoUrl)!))
            }
            
        }
        
        // TODO: Don't force unwrap
        
        checkIfTrackIsFavorited(track!)
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        
        if isFavorited {
            // TODO: Don't force unwrap
            promptDeletionOfFavorite(favorite!)
            
        } else {
            addTrackToDatabase()
            
        }
        
    }
    
    func addTrackToDatabase() {
        
        let favorite = Favorite(context: DatabaseManager.persistentContainer.viewContext)
        
        favorite.artist = track?.artist
        favorite.track = track?.name
        favorite.duration = track?.duration
        favorite.albumArtUrl = track?.albumArtUrl
        favorite.videoUrl = track?.videoUrl
        favorite.trackId = track?.trackId
        favorite.sortId = 9999
        
        
        DatabaseManager.saveContext()
        
        self.checkIfTrackIsFavorited(self.track!)
    }
    
    func checkIfTrackIsFavorited(_ track: Track) {
        
        // TODO: Needs major improvements
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        let sort = NSSortDescriptor(key: #keyPath(Favorite.sortId), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        
        do {
            let result = try DatabaseManager.persistentContainer.viewContext.fetch(fetchRequest)
            
            print("Searching...")
            
            // TODO: improve
            for favorite in result as! [Favorite] {
                print("FOUND FROM SEARCH: \(favorite.trackId)")
                
                if self.track?.trackId == favorite.trackId {
                    print("Is favorited!")
                    self.isFavorited = true
                    self.favorite = favorite
                    
                    break
                    
                }
                
            }
            
            self.displayFavoritedOrNot()
            
        } catch {
            print("Failed")
        }
        
        
    }
    
    func displayFavoritedOrNot() {
        DispatchQueue.main.async {
            if self.isFavorited {
                self.favoriteButton.setTitle("Remove", for: .normal)
            } else {
                self.favoriteButton.setTitle("Favorite", for: .normal)
            }
        }
    }
    
    func promptDeletionOfFavorite(_ favorite: Favorite) {
        
        
        let alert = UIAlertController(title: "Delete \(favorite.track ?? "track")?", message: "This track will be removed from your favorites", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
            
            DatabaseManager.persistentContainer.viewContext.delete(favorite)
            DatabaseManager.saveContext()
            
            // TODO: FIX
            self.checkIfTrackIsFavorited(self.track!)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // The iPad version crashes without a sourceView
        alert.popoverPresentationController?.sourceView = self.view
        
        present(alert, animated: true, completion: nil)
            
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
