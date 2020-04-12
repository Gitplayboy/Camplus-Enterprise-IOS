//
//  AddPostVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import FirebaseStorage

class AddPostVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var imgDescription: UILabel!
    @IBOutlet weak var uploadedImg: UIImageView!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var uploadImgView: UIView!
    @IBOutlet weak var deleteImgBtn: UIButton!
    @IBOutlet weak var publishPostBtn: UIButton!
    
    var imageReference:StorageReference {
        return Storage.storage().reference().child("images")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let imgUploadBorder = CAShapeLayer()
        imgUploadBorder.strokeColor = UIColor.black.cgColor
        imgUploadBorder.lineDashPattern = [5, 5]
        imgUploadBorder.frame = uploadImgView.bounds
        imgUploadBorder.fillColor = nil
        imgUploadBorder.path = UIBezierPath(rect: uploadImgView.bounds).cgPath
        uploadImgView.layer.addSublayer(imgUploadBorder)
        
        deleteImgBtn.layer.cornerRadius = deleteImgBtn.bounds.width / 2
        deleteImgBtn.layer.masksToBounds = true
        postDescription.layer.cornerRadius = 8
        postDescription.layer.borderWidth = 1.0
        let myColor : UIColor = UIColor.gray
        postDescription.layer.borderColor = myColor.cgColor
        postDescription.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onImageUpload))
        uploadImgView.addGestureRecognizer(gesture)
        
        self.navigationController?.navigationBar.topItem?.title = " "
        
        publishPostBtn.layer.cornerRadius = 8
    }
    @objc func onImageUpload(){
        galleryAction()
    }
    @IBAction func onImageDeletion(_ sender: UIButton) {
        uploadedImg.image = nil
        deleteImgBtn.isHidden = true
    }
    
    @IBAction func onPublishPost() {
        if uploadedImg != nil {
            let fileName = "IMG\(generateRandomNumber(numDigits: 3)).jpg"
            //Save image to Firebase storage
            guard let image = uploadedImg.image else {return}
            guard let imageData = image.jpegData(compressionQuality: 1) else { return }
            
            let uploadImgRef = imageReference.child(fileName)
            let uploadTask = uploadImgRef.putData(imageData, metadata: nil) { (metadata, error) in
                print("upload task finished")
                print(error ?? "error \(String(describing: error))")
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                print(snapshot.progress!)
            }
            uploadTask.resume()
        }
        let alert = UIAlertController(title: "Publish Post", message: "Post Published Successfully", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Pictures loading code
    func galleryAction() {
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in}
        
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        photoSourceRequestController.addAction(cancelAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    //Pictures loading code
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgView = UIImageView()
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            deleteImgBtn.isHidden = false
            imgView.image = selectedImage
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            uploadedImg.image = imgView.image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func generateRandomNumber(numDigits:Int) -> Int{
        var place = 1
        var finalNumber = 0;
        for _ in 0..<numDigits {
            place *= 10
            let randomNumber = arc4random_uniform(10)
            finalNumber += Int(randomNumber) * place
        }
        return finalNumber
    }
}
