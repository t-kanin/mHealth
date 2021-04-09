//
//  MapViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 25/1/2564 BE.
//

import UIKit
import CoreLocation
import SpriteKit
import CoreMotion
class FightArenaViewController: UIViewController{
    let scene = FightScene()
    var monster_img = ""
    var action = 0
    var gameEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!gameEnd){
            setScene()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func setScene(){
        scene.size = self.view.bounds.size
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        scene.monster_img = monster_img
        scene.action = self.action
        skView.presentScene(scene)
    }
}
