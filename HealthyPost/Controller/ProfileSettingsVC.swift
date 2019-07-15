//
//  ProfileSettingsVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/15/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit

class ProfileSettingsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {


    @IBOutlet weak var userAddImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
         let imageTapp = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
         self.userAddImage.addGestureRecognizer(imageTapp)
    }
    
    @objc func userImageTapped(_ sender: UIGestureRecognizer){
        let imagepickerController = UIImagePickerController()
        imagepickerController.delegate = self
        let imageAlert = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        imageAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagepickerController.sourceType = .camera
                self.present(imagepickerController, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }))
        imageAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagepickerController.sourceType = .photoLibrary
            self.present(imagepickerController, animated: true, completion: nil)
        }))
        imageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        self.present(imageAlert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            userAddImage.image = selectedImage
            let dataImage = selectedImage?.pngData()
            UserDefaults.standard.set(dataImage, forKey: "image")
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backToTheMainVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
