//
//  MovieTableViewCell.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var imgViewMovie: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDate: UILabel!

    var minHeight: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgViewMovie.clipsToBounds = true
        imgViewMovie.contentMode = .scaleAspectFill
        imgViewMovie.layer.cornerRadius = 8.0
        imgViewMovie.layer.borderWidth = 1.0
        imgViewMovie.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    func loadData(facts: Movie) {
        
        if let name = facts.title {
            lblTitle.text = name
        } else {
            lblTitle.text = "-NA-"
        }
        
        if let dateRelease = facts.releaseDate {
            lblDate.text = "Release Date: " + "\(dateRelease)"
        } else {
            lblDate.text = "Release Date: " + "-NA-"
        }
        
        if let imgURL = facts.posterPath {
            
            let formatURL = String(format: "%@/%@", EndPoints.smallImagePath, imgURL)
            imgViewMovie.sd_setImage(with: URL.init(string: formatURL), placeholderImage: UIImage(named: "default_icon"))
        } else {
            imgViewMovie.image = UIImage(named: "default_icon")
        }
     }
}
