//
//  AlbumDetailViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 28/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var albumArtView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var album: Album?
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        updateInterface()
        loadTracks()
        
    }
    
    func updateInterface() {
        
        title = album?.title
        albumTitleLabel.text = album?.title
        artistLabel.text = album?.artist
        yearLabel.text = album?.yearReleased
        
        if let albumArtUrl = album?.albumArtUrl {
            let url = URL(string: albumArtUrl)
            albumArtView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-album"))
        } else {
            albumArtView.image = UIImage(named: "placeholder-album")
        }
        
    }
    
    func loadTracks() {
        
        if let albumId = album?.identifier {
            
            let url = "\(musicApiBaseUrl)track.php?m=\(albumId)"
            
            let handler = NetworkHandler()
            
            handler.getData(url: URL(string: url)!, completionHandler: { data, response, error in
                
                if (error != nil) {
                    print("Error: \(error?.localizedDescription)")
                    return
                }
                
                do {
                    
                    let response = try JSONDecoder().decode(TracksResponse.self, from: data!)
                    
                    for var track in response.track {
                        // print("Track: \(track.name)")
                        track.albumArtUrl = self.album?.albumArtUrl
                        self.tracks.append(track)
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    }
                    
                    
                } catch let error {
                    print(error)
                    
                }
                
                
                
            })
            
        }
    }
    
    func openTrack(_ track: Track) {
        let navController = self.storyboard?.instantiateViewController(identifier: "TrackVC")
        let vc = navController?.children.first as! TrackViewController
        
        vc.track = track
        
        self.present(navController!, animated: true, completion: nil)
        
    }
    
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrackTableViewCell
        
        let track = tracks[indexPath.row]
        cell.setup(track: track)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Released in \(album?.yearReleased ?? "")"
    }
    
    
}

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let track = tracks[indexPath.row]
        openTrack(track)
        
    }
}

