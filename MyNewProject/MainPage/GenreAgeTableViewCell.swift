//
//  GenreAgeTableViewCell.swift
//  MyNewProject
//
//  Created by Aitzhan Ramazan on 27.04.2025.
//

import UIKit
import SDWebImage

class GenreAgeTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    var mainMovie = MainMovies()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(mainMovie: MainMovies){
        self.mainMovie = mainMovie
        
        collectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mainMovie.cellType == .ageCategory{
            return mainMovie.categoryAge.count
        }
        return mainMovie.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAge", for: indexPath)
        
        //image view
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.layer.cornerRadius = 8
        
        let nameLabel = cell.viewWithTag(1001) as! UILabel
       
        if mainMovie.cellType == .ageCategory{
            imageview.sd_setImage(with: URL(string: mainMovie.categoryAge[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
            nameLabel.text = mainMovie.categoryAge[indexPath.row].name
        } else{
            imageview.sd_setImage(with: URL(string: mainMovie.genres[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    
    }
}
