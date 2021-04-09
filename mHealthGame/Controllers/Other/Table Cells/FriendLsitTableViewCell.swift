//
//  FriendLsitTableViewCell.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 19/2/2564 BE.
//

import UIKit

class FriendLsitTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    func setPhoto(url: String){
        if(url != nil){
            self.photoImg.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo"), options:.continueInBackground, completed: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()// Initialization code
        nameTextField.borderStyle = .none
        nameTextField.isUserInteractionEnabled = false
        nameTextField.font = UIFont(name: "MavenPro-Regular", size: 15)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)









        // Configure the view for the selected state
    }
    
}
