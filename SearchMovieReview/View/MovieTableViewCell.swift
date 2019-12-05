//
//  MovieTableViewCell.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var movieImageView: AsyncImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(movieDetail: Search) {
        guard let imageUrl = movieDetail.poster,
            let movieTitle = movieDetail.title,
            let movieYear = movieDetail.year else {
                return
                
        }
        
        self.lblYear.text = movieYear
        self.lblTitle.text = movieTitle
        // Sync call for two images
        self.movieImageView.loadImage(urlString: imageUrl, completion: { _ in })
    }
    
}
