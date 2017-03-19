//
//  ViewController.swift
//  SpotifyTest
//
//  Created by Jesus Garcia on 3/16/17.
//  Copyright © 2017 Jesus Garcia. All rights reserved.
//

import UIKit
import SDWebImage

class ArtistListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    // MARK: IBOutlets
    @IBOutlet weak var artistCollectionView: UICollectionView!
    
    // MARK: Properties
    let searchController = UISearchController(searchResultsController: nil)
    var artists = [Artist]()
    var refreshControl: UIRefreshControl!

    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        self.artistCollectionView.register(UINib(nibName: "ArtistCell", bundle: nil), forCellWithReuseIdentifier: "artist cell")
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        artistCollectionView.addSubview(refreshControl)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "artist cell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ArtistCollectionViewCell
        let artist: Artist
            artist = artists[indexPath.row]
        if let artistImage = artist.image {
            cell.artistImage.sd_setImage(with: URL(string: artistImage), placeholderImage: UIImage(named: "spotify_logo"))
        }
        
        cell.artistName.text = artist.name
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let artist = artists[indexPath.row]
        
        self.performSegue(withIdentifier: "show artist detail", sender: artist)
    }
    
    // MARK: UISearchController
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        searchArtist(searchText: searchText)
    }
    
    func searchArtist(searchText:String){
        
        if searchText != "" {
            
            ArtistApi.sharedInstance.getArtisit(query: searchText, {(artists) -> Void in
                
                if(artists != nil ){
                    self.artists = artists!
                    self.artistCollectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                else {
                    let alert = UIAlertController(title: "Oppss", message: "There was an error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Acept", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                
            })
        }
    }
    
    
    // MARK: RefreshControl
    
    func refresh(sender:AnyObject) {
        if searchController.searchBar.text != nil {
            searchArtist(searchText: searchController.searchBar.text!)
        }
        
    }
    
    // MARK: Navegation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "show artist detail" {
            if let artistDetailVC = segue.destination as? ArtistDetailViewController {
                
                if let selectedArtist = sender as? Artist {
                    artistDetailVC.artist = selectedArtist
                }
                
            }
        }
    }
    


}

extension ArtistListViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

