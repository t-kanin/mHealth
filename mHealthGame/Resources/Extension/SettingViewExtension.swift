//
//  SettingViewExtension.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 4/12/2563 BE.
//

import UIKit
import FirebaseAuth
extension SettingViewController {
    
    func setupTitleLabel (){
        let title = "Setting"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"Didot",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        titleLabel.attributedText = attributedText
    }
    
    func setupProfilePic (){
        profilePic.layer.cornerRadius = 50
        profilePic.layer.borderWidth = 2.0
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.clipsToBounds = true
        profilePic.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        profilePic.addGestureRecognizer(tapGesture)
    }
    
    func setupLogoutButton(){
        let attributedText = NSMutableAttributedString(string: "Logout ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.red])
        logoutButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    @objc func didTapProfilePic(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            profilePic.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageOriginal
            profilePic.image = imageOriginal
        } // update pic even user did not edit the image

        if let uid = AuthManager.shared.getUID(){
            StorageManager.shared.storeImage(uid: uid, image: image!)
            
        } else {
            print("No user sign in ")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
