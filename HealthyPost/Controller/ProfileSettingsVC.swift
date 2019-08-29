//
//  ProfileSettingsVC.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 7/15/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData

class ProfileSettingsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var userAddImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userLocationTextField: UITextField!
    
   private  var coreDataModel = CoreDataStackClass()
   var userProffileData =  [ProffileData]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
         fetchUserProffileData()
         let imageTapp = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
         self.userAddImage.addGestureRecognizer(imageTapp)
    }
    
    //MARK: TextField Delegate for hide the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: Access to the Camera and Libeary
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
    
    
    func saveProffileData() {
        let managedContext = coreDataModel.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "ProffileData", in:managedContext)
        let newUser = NSManagedObject(entity: entity!, insertInto: managedContext)
        newUser.setValue(userAddImage.image?.pngData(), forKey: "userImage")
        newUser.setValue(userNameTextField.text, forKey: "userName")
        newUser.setValue(userEmail.text, forKey: "userEmail")
        newUser.setValue(userLocationTextField.text, forKey: "userLocation")
        do {
            try managedContext.save()
        } catch  {
            print("can't save proffile data")
        }
    }
    
    func fetchUserProffileData(){
        let request: NSFetchRequest<ProffileData> = ProffileData.fetchRequest()
        do {
            userProffileData = try (managedContexts?.fetch(request))!
            for proffile in userProffileData {
               userAddImage.image = UIImage(data: (proffile.userImage)! as Data)
                userNameTextField.text = proffile.userName
                userEmail.text = proffile.userEmail
                userLocationTextField.text = proffile.userLocation
            }
        }catch{
             print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userLocation" {
            let destVC = segue.destination as! ShareUserLocation
//            destVC.locationDelegate = self
            
        }
    }
    
    //MARK: Return delegate BACK
//    func getUserLocation(location: String) {
//        userLocationTextField.text = location
//    }
    
    
    //MARK: Passing data use Unwind segue
    @IBAction func didUnwindFromLocationVC(_ sender: UIStoryboardSegue) {
        guard let locationVC = sender.source as? ShareUserLocation else {return}
        userLocationTextField.text = locationVC.locationLbl.text
        saveProffileData()
    }
    
    
    //MARK: Go to the ShareLocationVC
    @IBAction func mapViewBtn(_ sender: Any) {
         self.performSegue(withIdentifier: "userLocation", sender: nil)
    }
    
    @IBAction func backBtnPress(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        saveProffileData()
        dismiss(animated: true, completion: nil)
    }
}
