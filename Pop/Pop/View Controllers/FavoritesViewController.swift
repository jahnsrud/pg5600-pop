//
//  FavoritesViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 28/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var suggestionsView: UICollectionView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var favorites = [Favorite]()
    var suggestedArtists = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        suggestionsView.dataSource = self
        suggestionsView.delegate = self
        
        /*
         var testFav = Favorite(context: DatabaseManager.init().persistentContainer.viewContext)
         
         testFav.artist = "test.Artist"
         testFav.track = "test.Track"
         testFav.duration = "123456"
         testFav.albumArtUrl = "https://is4-ssl.mzstatic.com/image/thumb/Music118/v4/18/82/00/18820086-ad63-b51e-f562-d455d6cb8625/source/1200x1200bb.jpg"
         testFav.videoUrl = "https://is4-ssl.mzstatic.com/image/thumb/Music118/v4/18/82/00/18820086-ad63-b51e-f562-d455d6cb8625/source/1200x1200bb.jpg"
         
         favorites.append(testFav)
         */
        
        suggestedArtists.append(Artist(name: "test.Artist", artistId: "000"))
        suggestedArtists.append(Artist(name: "test.cool", artistId: "111"))
        suggestedArtists.append(Artist(name: "test.nice", artistId: "222"))
        suggestedArtists.append(Artist(name: "test.yes", artistId: "333"))
        
        // Our TableView
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // And the CollectionView
        suggestionsView.register(UINib(nibName: "ArtistCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        loadFavorites()
        loadSuggestions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavorites()
        
    }
    
    func loadFavorites() {
        
        // TODO: Improve
        
        let dbManager = DatabaseManager()
        let context = dbManager.persistentContainer.viewContext
                        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do {
            favorites.removeAll()
            favorites = try context.fetch(fetchRequest) as! [Favorite]
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData(animated: true)
        
    }
    
    @IBAction func enterEdit(_ sender: Any) {
        
        self.setEditing(!self.isEditing, animated: true)
        
    }
    
    func deleteFavorite(at: IndexPath) {
        
        let favorite = favorites[at.row]
        
        let alert = UIAlertController(title: "Delete \(favorite.track)?", message: "This track will be removed from your favorites", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
            
            // TODO: Delete
            self.favorites.remove(at: 0)
            self.tableView.reloadData(animated: true)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // The iPad version crashes without a sourceView
        alert.popoverPresentationController?.sourceView = self.view
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        // Notify
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
        
        // Update UI
        if editing {
            self.editBarButtonItem.title = "Done"
            self.editBarButtonItem.style = .done
        } else {
            self.editBarButtonItem.title = "Edit"
            self.editBarButtonItem.style = .plain
        }
        
        
    }
    
    func loadSuggestions() {
        if favorites.count > 0 {
            
            print("Loading suggestions...")
            
            let query = "red+hot+chili+peppers%2C+pulp+fiction"
            let url = "\(suggestionsApiBaseUrl)similar?q=\(query)?type=music"
            let handler = NetworkHandler()
            
            handler.getData(url: URL(string: url)!, completionHandler: { data, response, error in
                
                do {
                    /*
                     
                     // TODO: Don't force unwrap
                     let response = try! JSONDecoder().decode(SuggestionsResponse.self, from: data!)
                     
                     
                     for suggestion in response.results {
                     print(suggestion.suggestions)
                     // self.albums.append(album)
                     }
                     
                     self.suggestionsView.reloadData(animated: true)
                     */
                    
                } catch let error {
                    print(error)
                    
                }
                
            })
            
            
            
            
            
        }
        
    }
    
    func openFavorite(_ favorite: Favorite) {
        let navController = self.storyboard?.instantiateViewController(identifier: "TrackVC")
        let vc = navController?.children.first as! TrackViewController
        
        // TODO: FIX Don't unwrap
        
        let convertedTrack = Track(name: favorite.track!, duration: favorite.duration!, artist: favorite.artist!, videoUrl: favorite.videoUrl!)
        
        vc.track = convertedTrack
        
        self.present(navController!, animated: true, completion: nil)
        
    }
    
    func displayEmptyState() {
        
        // Workaround to hide our edit button when nothing is added
        
        if favorites.count == 0 {
            editBarButtonItem.isEnabled = false
            editBarButtonItem.tintColor = .clear
            emptyStateLabel.isHidden = false
            
        } else {
            editBarButtonItem.isEnabled = true
            editBarButtonItem.tintColor = .black
            emptyStateLabel.isHidden = true
        }
    }
    
    
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        displayEmptyState()
        
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoriteTableViewCell
        
        let favorite = favorites[indexPath.row]
        
        cell.trackLabel.text = favorite.track
        cell.durationLabel.text = favorite.duration
        
        cell.albumArtView.kf.setImage(with: URL(string: favorite.albumArtUrl ?? ""), placeholder: UIImage(named: "placeholder-album"))
        
        
        return cell
    }
    
    
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let favorite = favorites[indexPath.row]
        openFavorite(favorite)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return favorites.count > 0 ? "Tracks" : ""
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print("MOVe IT!")
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteFavorite(at: indexPath)
            
        }
    }
    
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedArtists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ArtistCell
        
        let artist = suggestedArtists[indexPath.item]
        
        cell.artistLabel.text = artist.name
        
        cell.imageView.image = #imageLiteral(resourceName: "icon-grid")
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2
        cell.imageView.layer.masksToBounds = true
        cell.imageView.backgroundColor = .orange
        
        return cell
    }
    
    
    
    
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = suggestedArtists[indexPath.item]
        
        let vc = storyboard?.instantiateViewController(identifier: "ArtistVC") as! ArtistViewController
        vc.artist = artist
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100)
    }
    
}
