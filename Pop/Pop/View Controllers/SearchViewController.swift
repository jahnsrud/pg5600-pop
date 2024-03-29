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
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func search(query: String) {
        
        // Clear old results
        
        clearResults()
        
        print("Searching for: \(query)")
        
        guard query.count > 0 else {
            print("Stopping")
            return
        }
        
        searchAlbums(query: query)
        searchArtists(query: query)
        
    }
    
    func clearResults() {
        self.albumResults.removeAll()
        self.artistResults.removeAll()
        
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
        }
    }
    
    func searchAlbums(query: String) {
        
        let url = "\(musicApiBaseUrl)searchalbum.php?a=\(query)"
        
        NetworkClient().fetch(url: URL(string: url)!, completionHandler: { data, response, error in
            
            if let fetchError = error {
                print("Error: \(fetchError.localizedDescription)")
                return
            }
            
            do {
                
                if let jsonData = data {
                    
                    let response = try JSONDecoder().decode(AlbumSearchResponse.self, from: jsonData)
                    
                    if response.album != nil {
                        for album in response.album! {
                            self.albumResults.append(album)
                        }
                    } else {
                        print("Search: Results are empty")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
                    }
                    
                }
                
            } catch let error {
                print(error)
                
            }
            
            
        })
    }
    
    func searchArtists(query: String) {
        print("Searching for: \(query)")
        
        let url = "\(musicApiBaseUrl)search.php?s=\(query)"
        
        NetworkClient().fetch(url: URL(string: url)!, completionHandler: { data, response, error in
            
            if let fetchError = error {
                print("Error: \(fetchError.localizedDescription)")
                return
            }
            
            do {
                
                if let jsonData = data {
                    
                    let response = try JSONDecoder().decode(ArtistResponse.self, from: jsonData)
                    
                    if response.artists != nil {
                        for artist in response.artists! {
                            self.artistResults.append(artist)
                        }
                    } else {
                        print("Search: Results are empty")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
                        // self.tableView.reloadData()
                    }
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
    
    func presentArtist(_ artist: Artist) {
        let artistVC = self.storyboard?.instantiateViewController(identifier: "ArtistVC") as! ArtistViewController
        artistVC.artist = artist
        
        navigationController?.pushViewController(artistVC, animated: true)
        
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
            
        } else if indexPath.section == 1 {
            let artist = artistResults[indexPath.row]
            presentArtist(artist)
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
