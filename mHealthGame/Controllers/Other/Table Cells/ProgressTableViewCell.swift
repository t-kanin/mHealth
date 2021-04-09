//
//  ProgressTableViewCell.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 27/2/2564 BE.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        todayLabel.font = UIFont(name: "MavenPro-Regular", size: 15)
        titleLabel.font = UIFont(name: "MavenPro-Regular", size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  setText(data: Int, textBack: String){
        todayLabel.text = "\(data) \(textBack) "
    }

}
