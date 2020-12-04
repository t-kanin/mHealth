//
//  SettingViewExtension.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 4/12/2563 BE.
//

import UIKit

extension SettingViewController {
    
    func setUpTitleLabel (){
        let title = "Setting"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"Didot",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        titleLabel.attributedText = attributedText
    }
    
    func setUpProfilePic (){
        profilePic.layer.cornerRadius = 50
        profilePic.clipsToBounds = true
        profilePic.backgroundColor = .black

    }
    
}
