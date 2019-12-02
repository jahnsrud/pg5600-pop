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
    private var favorite: Favorite?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayTrack()
        
    }
    
    func displayTrack() {
        
        title = ""
        
        titleLabel.text = track?.name
        artistLabel.text = track?.artist
        
        if let intDuration = Int(track?.duration ?? "") {
            durationLabel.text = intDuration.convertMillisecondsToHumanReadable()
        } else {
            durationLabel.text = ""
        }
        
        if var videoUrl = track?.videoUrl {
            
            videoUrl = videoUrl.replacingOccurrences(of: "http://", with: "https://")
            print(videoUrl)
            
            if videoUrl.count > 0 {
                // webView.load(URLRequest(url: URL(string: videoUrl)!))
            }
            
        }
        
        displayFavoritedStatus()
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        
        if trackIsFavorited() {
            promptDeletionOfFavorite(favorite)
            
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
        
        displayFavoritedStatus()
        
    }
    
    func trackIsFavorited() -> Bool {
        
        // Checks if there are any matching Favorite objects stored to our database
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        let predicate = NSPredicate(format: "trackId == %@", self.track!.trackId)
        fetchRequest.predicate = predicate
        
        var matches = 0
        
        do {
            matches = try DatabaseManager.persistentContainer.viewContext.count(for: fetchRequest)
            
            if matches > 0 {
                let result = try DatabaseManager.persistentContainer.viewContext.fetch(fetchRequest)
                self.favorite = result.first as? Favorite
                
            }
            
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return matches > 0
        
    }
    
    func displayFavoritedStatus() {
        DispatchQueue.main.async {
            if self.trackIsFavorited() {
                self.favoriteButton.setTitle("Remove", for: .normal)
            } else {
                self.favoriteButton.setTitle("Favorite", for: .normal)
            }
        }
    }
    
    func promptDeletionOfFavorite(_ favorite: Favorite?) {
        
        if let fav = favorite {
            
            let alert = UIAlertController(title: "Delete \(fav.track ?? "track")?", message: "This track will be removed from your favorites", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                
                DatabaseManager.persistentContainer.viewContext.delete(fav)
                DatabaseManager.saveContext()
                
                self.displayFavoritedStatus()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // The iPad version crashes without a sourceView
            alert.popoverPresentationController?.sourceView = self.view
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
