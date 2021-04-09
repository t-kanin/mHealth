//
//  LeaderboardTableViewCell.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 22/2/2564 BE.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameLabel.font = UIFont(name: "MavenPro-Regular", size: 15)
        scoreLabel.font = UIFont(name: "MavenPro-Regular", size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPhoto(url: String){
        if(url != nil){
            self.photoImg.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo"), options:.continueInBackground, completed: nil)
        }
    }
    
}
