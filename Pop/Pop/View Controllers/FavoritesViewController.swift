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
    var suggestedArtists = [SuggestedArtist]()
    
    var fetchedResultsController: NSFetchedResultsController<Favorite>!
    
    let dbManager = DatabaseManager.sharedInstance
    let context = DatabaseManager.sharedInstance.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        suggestionsView.dataSource = self
        suggestionsView.delegate = self
        
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
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        let sort = NSSortDescriptor(key: #keyPath(Favorite.track), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchedResultsController = (NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Favorite>)
            try fetchedResultsController.performFetch()
            fetchedResultsController.delegate = self
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        /*
         do {
         favorites.removeAll()
         favorites = try context.fetch(fetchRequest) as! [Favorite]
         } catch let error as NSError {
         print("Error: \(error.localizedDescription)")
         }
         
         self.tableView.reloadData(animated: true)*/
        
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
            self.dbManager.saveContext()
            
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
        
        var query:String = ""
        
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
        // if favorites.count > 0 {
        
        print("Loading suggestions based on: \(getArtistsFormatted())")
        
        let url = "\(suggestionsApiBaseUrl)similar?q=\(getArtistsFormatted())?type=music"
        let handler = NetworkHandler()
        
        self.suggestedArtists.removeAll()
        self.suggestionsView.reloadData(animated: true)
        
        handler.getData(url: URL(string: url)!, completionHandler: { data, response, error in
            
            if (error != nil) {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            do {
                
                let response = try JSONDecoder().decode(SuggestionsResponse.self, from: data!)
                
                
                for suggestion in response.similar.results {
                    print(suggestion)
                    
                    self.suggestedArtists.append(suggestion)
                }
                
                self.suggestionsView.reloadData(animated: true)
                
                
                
            } catch let error {
                print(error)
                
            }
            
        })
        
        
        
        
        
        // }
        
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
        
        cell.trackLabel.text = favorite.track
        cell.artistLabel.text = favorite.artist
        
        if let intDuration = Int(favorite.duration ?? "") {
            cell.durationLabel.text = intDuration.convertMillisecondsToHumanReadable()
        } else {
            cell.durationLabel.text = ""
        }
        
        cell.albumArtView.kf.setImage(with: URL(string: favorite.albumArtUrl ?? ""), placeholder: UIImage(named: "placeholder-album"))
        
        
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
        
        print("MOVe IT!")
        
        // Update all favorites with new ID
        
        
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
        
        cell.imageView.image = #imageLiteral(resourceName: "placeholder-album")
        cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2
        cell.imageView.layer.masksToBounds = true
        cell.imageView.backgroundColor = .blue
        
        return cell
    }
    
    
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let artist = suggestedArtists[indexPath.item]
        
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
        return CGSize(width: 200, height: 100)
    }
    
}


// https://medium.com/@KentaKodashima/ios-core-data-tutorial-part-2-41f6740865d5s
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
