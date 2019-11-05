//
//  TrackViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import WebKit

class TrackViewController: UIViewController {
    
    var track: Track?
    
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
                webView.load(URLRequest(url: URL(string: videoUrl)!))
            }
            
        }
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        addOrDeleteFavorite()
    }
    
    func addOrDeleteFavorite() {
        
        let dbManager = DatabaseManager()
        
        let testFav = Favorite(context: dbManager.persistentContainer.viewContext)
        
        testFav.artist = track?.artist
        testFav.track = track?.name
        testFav.duration = track?.duration
        testFav.albumArtUrl = "COMING_SOON"
        testFav.videoUrl = track?.videoUrl
        
        
        dbManager.saveContext()

        // promptDeletionOfTrack()
        
        
        
        
    }
    
    func promptDeletionOfTrack(_ track: Track) {
        let alert = UIAlertController(title: "Delete \(0)?", message: "This track will be removed from your favorites", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
            // TODO: Delete
            
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
