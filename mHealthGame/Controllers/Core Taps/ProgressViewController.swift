//
//  ProgressViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 3/12/2563 BE.
//

import UIKit

class ProgressViewController: UIViewController{
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderLabel()
    }
    
    func setupHeaderLabel (){
        let title = "Progression"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"Didot",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
}
