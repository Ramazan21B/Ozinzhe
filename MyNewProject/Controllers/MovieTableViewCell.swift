//
//  MovieTableViewCell.swift
//  MyNewProject
//
//  Created by Aitzhan Ramazan on 26.02.2025.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImageView.layer.cornerRadius = 8
        playView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(movie: String){
        posterImageView.image = UIImage(named: movie)
    }
}
