//
//  TrackViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import YoutubePlayerView
import CoreData

class TrackViewController: UIViewController {
    
    var track: Track?
    private var favorite: Favorite?
    
    @IBOutlet weak var playerView: YoutubePlayerView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var metadataView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayTrack()
        metadataView.layer.cornerRadius = 4
        
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
        
        startVideo()
        
        displayFavoritedStatus()
        
    }
    
    func startVideo() {
        if var videoUrl = track?.videoUrl {
            
            videoUrl = videoUrl.replacingOccurrences(of: "http://", with: "https://")
            print(videoUrl)
            
            if videoUrl.count > 0 {
                // webView.load(URLRequest(url: URL(string: videoUrl)!))
                
                let playbackOptions: [String: Any] = [
                    "controls": 0,
                    "modestbranding": 1,
                    "playsinline": 1,
                    "rel": 0,
                    "showinfo": 0,
                    "autoplay": 1,
                    "origin": "https://youtube.com"
                ]
                
                // TODO: IMPROVE
                let videoId = videoUrl.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
                
                playerView.loadWithVideoId(videoId, with: playbackOptions)
                
                
            }
            
        } else {
            playerView.backgroundColor = .black
        }
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        
        if trackIsFavorited() {
            promptDeletionOfFavorite(favorite)
            
        } else {
            addTrackToDatabase()
            
        }
        
    }
    
    @IBAction func openInSpotify(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "spotify://")!, options: [:], completionHandler: nil)
        
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
            print("Something went wrong: \(error)")
        }
        
        return matches > 0
        
    }
    
    func displayFavoritedStatus() {
        DispatchQueue.main.async {
            if self.trackIsFavorited() {
                self.favoriteButton.setTitle("", for: .normal)
                self.favoriteButton.setImage(UIImage(systemName: "star.slash"), for: .normal)
                
                
            } else {
                self.favoriteButton.setTitle("", for: .normal)
                self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
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
