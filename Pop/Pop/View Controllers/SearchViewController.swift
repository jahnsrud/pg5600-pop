//
//  SearchViewController.swift
//  Pop
//
//  Created by Markus Jahnsrud on 29/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var albumResults = [Album]()
    var artistResults = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
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
        
        // Clear old results
        
        self.albumResults.removeAll()
        self.artistResults.removeAll()
        
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
        }
        
        print("Searching for: \(query)")
        
        guard query.count > 0 else {
            print("Stopping")
            return
        }
        
        searchAlbums(query: query)
        searchArtists(query: query)
        
    }
    
    func searchAlbums(query: String) {
        
        let url = "\(musicApiBaseUrl)searchalbum.php?a=\(query)"
        let handler = NetworkClient()
        
        handler.fetch(url: URL(string: url)!, completionHandler: { data, response, error in
            
            if let fetchError = error {
                print("Error: \(fetchError.localizedDescription)")
                return
            }
            
            do {
                
                // TODO: Don't force unwrap
                let response = try JSONDecoder().decode(AlbumSearchResponse.self, from: data!)
                
                if response.album != nil {
                    for album in response.album! {
                        print("Found album: \(album.title)")
                        self.albumResults.append(album)
                    }
                } else {
                    print("Search: Results are empty")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
                }
                
                
            } catch let error {
                print(error)
                
            }
            
            
        })
    }
    
    func searchArtists(query: String) {
        print("Searching for: \(query)")
        
        let url = "\(musicApiBaseUrl)search.php?s=\(query)"
        let handler = NetworkClient()
        
        handler.fetch(url: URL(string: url)!, completionHandler: { data, response, error in
            
            if let fetchError = error {
                print("Error: \(fetchError.localizedDescription)")
                return
            }
            
            do {
                
                let response = try JSONDecoder().decode(ArtistResponse.self, from: data!)
                
                if response.artists != nil {
                    for artist in response.artists! {
                        print("Found artist: \(artist.name) with \(artist.imageUrl)")
                        self.artistResults.append(artist)
                    }
                } else {
                    print("Search: Results are empty")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
                    // self.tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return albumResults.count
        }
                
        return artistResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return albumResults.count > 0 ? "Albums" : ""
        } else {
            return artistResults.count > 0 ? "Artists" : ""
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchCell
        
        if indexPath.section == 0 {
            
            let album = albumResults[indexPath.row]
            cell.setup(album: album)
            
            
        } else {
            let artist = artistResults[indexPath.row]
            cell.setup(artist: artist)
            
            
            
        }
        
        
        
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let album = albumResults[indexPath.row]
            presentAlbum(album)
            
        }
        
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        // Converts our query to an URL friendly format
        let encodedSearchTerm = searchController.searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.lowercased()
        search(query: encodedSearchTerm ?? "")
        
    }
    
}
