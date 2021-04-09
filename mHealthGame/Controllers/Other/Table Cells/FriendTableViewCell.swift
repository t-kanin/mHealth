//
//  FriendTableViewCell.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 18/2/2564 BE.
//

import UIKit
import SDWebImage

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var key: String? 
    
    func setPhoto(url: String){
        if(url != nil){
            self.photoImg.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo"), options:.continueInBackground, completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTextField.borderStyle = .none
        nameTextField.isUserInteractionEnabled = false
        nameTextField.font = UIFont(name: "MavenPro-Regular", size: 15)
        yesButton.addTarget(self, action: #selector(acceptFriendRequest), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(rejectFriendRequest), for: .touchUpInside)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func acceptFriendRequest(){
        if(key != nil){
            DatabaseManager.shared.processFriendRequest(friendid: key!, status: "accept")
        }
    }
    
    @objc func rejectFriendRequest(){
        DatabaseManager.shared.processFriendRequest(friendid: key!, status: "reject")
    }
}
