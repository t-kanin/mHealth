 //
//  DemoViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 26/1/2564 BE.
//

import SpriteKit

class RunGameViewController: UIViewController{
    
    var monster_img = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setScene()
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Release any cached data, images, etc that aren't in use.
     }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func setScene(){
        let scene = GameScene()
        scene.monster_img = monster_img
        scene.size = self.view.bounds.size
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
}
