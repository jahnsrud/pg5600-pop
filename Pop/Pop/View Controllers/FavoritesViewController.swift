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
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var suggestionsView: UIView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var favorites = [Favorite]()
    var suggestedArtists = [SuggestedArtist]()
    
    var fetchedResultsController: NSFetchedResultsController<Favorite>!
    
    let context = DatabaseManager.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.delegate = self
        
        registerCells()
        
        loadFavorites()
        loadSuggestions()
        
    }
    
    func registerCells() {
        // Our TableView
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // And the CollectionView
        suggestionsCollectionView.register(UINib(nibName: "ArtistCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavorites()
        
    }
    
    // TODO: Improve
    
    func loadFavorites() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        let sort = NSSortDescriptor(key: #keyPath(Favorite.sortId), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchedResultsController = (NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Favorite>)
            try fetchedResultsController.performFetch()
            fetchedResultsController.delegate = self
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    @IBAction func enterEdit(_ sender: Any) {
        
        self.setEditing(!self.isEditing, animated: true)
        
    }
    
    func deleteFavorite(at: IndexPath) {
        
        // TODO: Improve
        
        let favorite = fetchedResultsController.object(at: at)
        
        let alert = UIAlertController(title: "Delete \(favorite.track ?? "track")?", message: "This track will be removed from your favorites", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
            self.context.delete(favorite)
            DatabaseManager.saveContext()
            
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
    
    // Gets the current artists and outputs a string with all artists
    // Formatted for the following API
    // https://tastedive.com/read/api
    
    func getArtistsFormatted() -> String {
        
        guard let mFavorites = fetchedResultsController.fetchedObjects else { return "" }
        
        // TODO: Convert to map,something
        
        var query: String = ""
        
        for favorite in mFavorites {
            if var artist = favorite.artist {
                artist = artist.replacingOccurrences(of: " ", with: "+")
                query += "\(artist)%2C+"
            }
        }
        
        // TODO: DOn't unwrap
        
        query = query.lowercased()
        
        return query
    }
    
    func loadSuggestions() {
        
        let mFavorites = fetchedResultsController.fetchedObjects
        
        if mFavorites?.count ?? 0 > 0 {
            
            print("Loading suggestions based on: \(getArtistsFormatted())")
            
            let url = "\(suggestionsApiBaseUrl)similar?q=\(getArtistsFormatted())?type=music&k=\(suggestionsApiKey)"
            print("Request URL: \(url)")
            
            let handler = NetworkClient()
            
            self.suggestedArtists.removeAll()
            self.suggestionsCollectionView.reloadData(animated: true)
            
            handler.fetch(url: URL(string: url)!, completionHandler: { data, response, error in
                
                if let fetchError = error {
                    print("Error: \(fetchError.localizedDescription)")
                    return
                }
                
                do {
                    
                    let response = try JSONDecoder().decode(SuggestionsResponse.self, from: data!)
                    
                    
                    for suggestion in response.similar.results {
                        print(suggestion)
                        
                        self.suggestedArtists.append(suggestion)
                    }
                    
                    self.suggestionsCollectionView.reloadData(animated: true)
                    
                    
                    
                } catch let error {
                    print(error)
                    
                }
                
            })
            
            
            
            
            
        } else {
            self.suggestedArtists.removeAll()
            self.suggestionsCollectionView.reloadData(animated: true)
        }
        
    }
    
    func openFavorite(_ favorite: Favorite) {
        let navController = self.storyboard?.instantiateViewController(identifier: "TrackVC")
        let vc = navController?.children.first as! TrackViewController
        
        // TODO: FIX Don't unwrap
        
        let convertedTrack = Track(name: favorite.track!,
                                   duration: favorite.duration!,
                                   artist: favorite.artist!,
                                   videoUrl: favorite.videoUrl,
                                   albumArtUrl: favorite.albumArtUrl!,
                                   trackId: favorite.trackId!)
        
        vc.track = convertedTrack
        
        self.present(navController!, animated: true, completion: nil)
        
    }
    
    func displayEmptyState() {
        
        // Workaround to hide our edit button when nothing is added
        
        guard let mFavorites = fetchedResultsController.fetchedObjects else { return }
        
        if mFavorites.count == 0 {
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
        
        guard let mFavorites = fetchedResultsController.fetchedObjects else { return 0 }
        
        return mFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoriteTableViewCell
        let favorite = fetchedResultsController.object(at: indexPath)
        
        cell.setup(favorite: favorite)
        
        
        return cell
    }
    
    
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let mFavorites = fetchedResultsController.fetchedObjects else { return }
        
        let favorite = mFavorites[indexPath.row]
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
        
        // guard let mFavorites = fetchedResultsController.fetchedObjects else { return }
        
        // TODO: Fix. Improve code and avoid force unwrap?
        var mFavorites = self.fetchedResultsController.fetchedObjects!
        
        let favoriteToMove = mFavorites[sourceIndexPath.row]
        mFavorites.remove(at: sourceIndexPath.row)
        mFavorites.insert(favoriteToMove, at: destinationIndexPath.row)
        
        // Update all favorites with new ID
        for (index, favorite) in mFavorites.enumerated() {
            favorite.sortId = Int16(index)
        }
        
        DatabaseManager.saveContext()
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteFavorite(at: indexPath)
            
            
        }
    }
    
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if suggestedArtists.count > 0 {
            suggestionsView.isHidden = false
        } else {
            suggestionsView.isHidden = true
        }
        
        return suggestedArtists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ArtistCell
        
        let artist = suggestedArtists[indexPath.item]
        
        cell.artistLabel.text = artist.name
        
        // cell.imageView.image = #imageLiteral(resourceName: "placeholder-album")
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2
        cell.imageView.layer.masksToBounds = true
        cell.imageView.backgroundColor = .random
        
        return cell
    }
    
    
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // let artist = suggestedArtists[indexPath.item]
        
        // TODO: FIX
        
        /*
         let vc = storyboard?.instantiateViewController(identifier: "ArtistVC") as! ArtistViewController
         vc.artist = artist
         navigationController?.pushViewController(vc, animated: true)
         */
        
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.bounds.size.height)
    }
    
}


// https://medium.com/@KentaKodashima/ios-core-data-tutorial-part-2-41f6740865d5
extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else { return }
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .fade)
            
        default:
            break
        }
        
        // Update our artist suggestions when data changes
        loadSuggestions()
    }
}
