//
//  ProfileHelpViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 25/3/2564 BE.
//

import UIKit

class ProfileHelpViewController: UIViewController{
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var strHelpLabel: UILabel!
    
    override func viewDidLoad() {
        setupHeader()
        let text = "Strength: \nThe more strength you have the higher damange you do.\nStrength can be increased by complete stair climb challenge \n\nSpeed: \nThe more speed you have the higher chance you can evade monster attack. \nSpeed can be increased by complete distance travel challenge \n\nDexterirty: \nThe more dexterity you have the higher chance you hit the monster. \nDexterirt can be increased by complete stepcount challenge\n\nHow to increase stat: \nThe challenge starts when tap X button. \nUser can see what it takes to increase the corresponding stat"
        setupLabel(label: strHelpLabel, text: text)
    }
    
    func setupHeader(){
        let title = "Help"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-SemiBold",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
    func setupLabel(label: UILabel, text: String){
        let  attributedText = NSMutableAttributedString(string: text,attributes:
                                                        [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-Regular",size: 15)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        label.attributedText = attributedText

    }

}
