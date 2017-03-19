
//
//  ArtistDetailViewController.swift
//  SpotifyTest
//
//  Created by Jesus Garcia on 3/18/17.
//  Copyright © 2017 Jesus Garcia. All rights reserved.
//

import UIKit

class ArtistDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    // MARK: Properties
    var albums = [Album]()
    var artist:Artist?
    
    
    // MARK: LifeCiclye
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "album cell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! AlbumCollectionViewCell
        
        cell.albumImage.layer.cornerRadius = cell.albumImage.frame.size.width / 2
        cell.albumImage.clipsToBounds = true
        
        
        let album: Album
        album = albums[indexPath.row]
        if let albumImage = album.image {
            cell.albumImage.sd_setImage(with: URL(string: albumImage), placeholderImage: UIImage(named: "spotify_logo"))
        }
        
        cell.albumName.text = album.name
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: albums[indexPath.row].url)!
        UIApplication.shared.open(url,  options: [:], completionHandler: nil)
    }
    
    
    // MARK: InstanceMethods
    
    func loadUI() {
        
        self.albumCollectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "album cell")
        if let artistDetail = artist {
            artistName.text = artistDetail.name
            followersLabel.text = String(artistDetail.followers)
            popularityLabel.text = String(artistDetail.popularity)
            AlbumApi.sharedInstance.getAlbum(artistId: artistDetail.id, {(albums) -> Void in
                
                if(albums != nil) {
                    self.albums = albums!
                    self.albumCollectionView.reloadData()
                }
                else {
                    let alert = UIAlertController(title: "Oppss", message: "There was an error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Acept", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
