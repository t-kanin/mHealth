//
//  HomeViewExtension.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 5/12/2563 BE.
//

import UIKit

extension HomeViewController {
    
    func setupTitleLabel (){
        let title = "Daily Mission"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"Didot",size:20)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        dailyMissionTextField.attributedText = attributedText
    }
    
    func setupHeaderLabel (){
        let title = "Home"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"Didot",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
}
