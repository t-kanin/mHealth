//
//  GameHelpViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 25/3/2564 BE.
//

import UIKit

class FirstTableCell: UITableViewCell{
    @IBOutlet weak var labelText: UILabel!
}

class SecondTableCell: UITableViewCell{
    @IBOutlet weak var labelTextHeader: UILabel!
    @IBOutlet weak var labelExplanation: UILabel!
    
}


class GameHelpViewController: UIViewController{
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        setupHeader()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupHeader(){
        let title = "Help"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-SemiBold",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
    
}

extension GameHelpViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension GameHelpViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstTableCell") as! FirstTableCell
            cell.labelText?.numberOfLines = 0
            cell.labelText?.lineBreakMode = .byWordWrapping
            cell.labelText?.font = UIFont(name: "MavenPro-Regular", size: 15)
            cell.labelText?.text = "How to play:\n\nThe Battle Arena will random the monster list to the users. There are 2 types of activities running and fighting \nEach monster user has defeated, the user gain 10 points. Climb the rank to be the best in the leaderboard"
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableCell") as! SecondTableCell
            cell.selectionStyle = .none
            var pic = UIImage(named: "run")
            pic = resizeImage(image: pic!, targetSize: CGSize(width: 20, height: 20))
            
            let fullStr = NSMutableAttributedString(string: "Running ")
            let imageAtt = NSTextAttachment()
            imageAtt.image = pic
            let imgStr = NSAttributedString(attachment: imageAtt)
            
            fullStr.append(imgStr)
            
            cell.labelTextHeader?.attributedText = fullStr
            cell.labelTextHeader?.font = UIFont(name: "MavenPro-Regular", size: 15)
            
            cell.labelExplanation?.numberOfLines = 0
            cell.labelExplanation?.lineBreakMode = .byWordWrapping
            cell.labelExplanation?.font = UIFont(name: "MavenPro-Regular", size: 15)
            cell.labelExplanation?.text = "User has to run non-stop in order to escape from the monster. When the user stop running, monster will move towards the user. If the user chracters contact the monster. Game is over. However, if the user is able to run until the end, the user gain 10 points"
            
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableCell") as! SecondTableCell
            cell.selectionStyle = .none
            var pic = UIImage(named: "run")
            pic = resizeImage(image: pic!, targetSize: CGSize(width: 20, height: 20))
            
            let fullStr = NSMutableAttributedString(string: "Fighting ")
            cell.labelTextHeader?.attributedText = fullStr
            cell.labelTextHeader?.font = UIFont(name: "MavenPro-Regular", size: 15)
            
            cell.labelExplanation?.numberOfLines = 0
            cell.labelExplanation?.lineBreakMode = .byWordWrapping
            cell.labelExplanation?.font = UIFont(name: "MavenPro-Regular", size: 15)
            cell.labelExplanation?.text = "For each monster on the list, there is an action corresponding to the monster. User has to perform action to do damage to the monster."
            
            return cell
        }
        else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableCell") as! SecondTableCell
            cell.selectionStyle = .none
            var pic = UIImage(named: "doublesword")
            pic = resizeImage(image: pic!, targetSize: CGSize(width: 20, height: 20))
            
            let fullStr = NSMutableAttributedString(string: "Slashing ")
            let imageAtt = NSTextAttachment()
            imageAtt.image = pic
            let imgStr = NSAttributedString(attachment: imageAtt)
            
            fullStr.append(imgStr)
            
            cell.labelTextHeader?.attributedText = fullStr
            cell.labelTextHeader?.font = UIFont(name: "MavenPro-Regular", size: 15)
            
            cell.labelExplanation?.numberOfLines = 0
            cell.labelExplanation?.lineBreakMode = .byWordWrapping
            cell.labelExplanation?.font = UIFont(name: "MavenPro-Regular", size: 15)
            cell.labelExplanation?.text = "User has to perform slashing by holding an iPhone in your hand and slash it in approximately 45 degree"
            
            return cell
        }
        else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableCell") as! SecondTableCell
            cell.selectionStyle = .none
            var pic = UIImage(named: "punch")
            pic = resizeImage(image: pic!, targetSize: CGSize(width: 20, height: 20))
            
            let fullStr = NSMutableAttributedString(string: "Punching ")
            let imageAtt = NSTextAttachment()
            imageAtt.image = pic
            let imgStr = NSAttributedString(attachment: imageAtt)
            
            fullStr.append(imgStr)
            
            cell.labelTextHeader?.attributedText = fullStr
            cell.labelTextHeader?.font = UIFont(name: "MavenPro-Regular", size: 15)
            
            cell.labelExplanation?.numberOfLines = 0
            cell.labelExplanation?.lineBreakMode = .byWordWrapping
            cell.labelExplanation?.font = UIFont(name: "MavenPro-Regular", size: 15)
            cell.labelExplanation?.text = "User has to perform punching by holding an iPhone in your hand and face upward. Then while holding, perform punch action"
            
            return cell
        }
        else if(indexPath.row == 5){
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableCell") as! SecondTableCell
            cell.selectionStyle = .none
            var pic = UIImage(named: "squats")
            pic = resizeImage(image: pic!, targetSize: CGSize(width: 20, height: 20))
            
            let fullStr = NSMutableAttributedString(string: "Squats ")
            let imageAtt = NSTextAttachment()
            imageAtt.image = pic
            let imgStr = NSAttributedString(attachment: imageAtt)
            
            fullStr.append(imgStr)
            
            cell.labelTextHeader?.attributedText = fullStr
            cell.labelTextHeader?.font = UIFont(name: "MavenPro-Regular", size: 15)
            
            cell.labelExplanation?.numberOfLines = 0
            cell.labelExplanation?.lineBreakMode = .byWordWrapping
            cell.labelExplanation?.font = UIFont(name: "MavenPro-Regular", size: 15)
            cell.labelExplanation?.text = "User has to perform squats by puting an iPhone in your pocket facing outward and perform squat"
            
            return cell
        }
        else{
            let cell = UITableViewCell()
            return cell
        }
        /*
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "MavenPro-Regular", size: 15)
        cell.textLabel?.text = "How to play:\nThe Battle Arena will random the monster list to the users. There are 2 types of activities running and fighting \n\nRunning: \nUser has to run non-stop in order to escape from the monster. When the user stop running, monster will move towards the user. If the user chracters contact the monster. Game is over. However, if the user is able to run until the end, the user gain points\n\nFighting: \nFor each monster on the list, there is an action corresponding to the monster. User has to perform action to do damage to the monster."
        return cell*/
    }
}
