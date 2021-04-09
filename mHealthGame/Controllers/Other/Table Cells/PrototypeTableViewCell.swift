//
//  PrototypeTableViewCell.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 16/2/2564 BE.
//

import UIKit

class PrototypeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var photoView2: UIImageView! // game type icon 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.font = UIFont(name: "MavenPro-Regular", size: 15)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
