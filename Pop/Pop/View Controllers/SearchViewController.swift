//
//  SearchViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 29/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var results = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "AlbumSearchCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        configureSearchController()
        
        
    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search"
        // searchController.automaticallyShowsCancelButton = false
        
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
    }
    
    func search(query: String) {
        
        print("Searching for: \(query)")
        
        // Clear old results
        self.results.removeAll()
        
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        
        guard query.count > 0 else {
            return
        }
        
        let url = "\(musicApiBaseUrl)searchalbum.php?a=\(query)"
        let handler = NetworkHandler()
        
        handler.getData(url: URL(string: url)!, completionHandler: { data, response, error in
            
            if (error != nil) {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            do {
                
                // TODO: Don't force unwrap
                let response = try JSONDecoder().decode(AlbumSearchResponse.self, from: data!)
                
                if response.album != nil {
                    for album in response.album! {
                        print("Found album: \(album.title)")
                        self.results.append(album)
                    }
                } else {
                    print("Search: Results are empty")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
                
                
            } catch let error {
                print(error)
                
            }
            
            
        })
        
    }
    
    func presentAlbum(_ album: Album) {
        
        let albumVC = self.storyboard?.instantiateViewController(identifier: "AlbumVC") as! AlbumViewController
        albumVC.album = album
        
        navigationController?.pushViewController(albumVC, animated: true)
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return results.count > 0 ? "Albums" : ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AlbumSearchCell
        let album = results[indexPath.row]
        
        cell.albumLabel.text = album.title
        cell.artistLabel.text = album.artist
        cell.albumArtView.kf.setImage(with: URL(string: album.albumArtUrl ?? ""), placeholder: UIImage(named: "placeholder-album"))
        
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let album = results[indexPath.row]
        presentAlbum(album)
        
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        // Converts our query to an URL friendly format
        let encodedSearchTerm = searchController.searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.lowercased()
        search(query: encodedSearchTerm ?? "")
        
    }
    
}
