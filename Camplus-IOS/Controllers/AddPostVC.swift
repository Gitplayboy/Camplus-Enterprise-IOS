//
//  AddPostVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import FirebaseStorage

extension UITextView {

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

class AddPostVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var imgDescription: UILabel!
    @IBOutlet weak var uploadedImg: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var uploadImgView: UIView!
    @IBOutlet weak var deleteImgBtn: UIButton!
    @IBOutlet weak var publishPostBtn: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let feedsSvcImpl = FeedsSvcImpl()
    
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
        postDescription.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        let textColor : UIColor = UIColor.lightGray
        
        postDescription.text = "Description"
        postDescription.textColor = textColor
        
        postDescription.bounds.inset(by: UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 0))
        postDescription.layer.borderColor = UIColor.gray.cgColor
        postDescription.layer.masksToBounds = true
        //postDescription.setLeftPaddingPoints(10)
        postTitle.setLeftPaddingPoints(10)
        postTitle.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onImageUpload))
        uploadImgView.addGestureRecognizer(gesture)
        
        setupNavigationbar()
        
        publishPostBtn.layer.cornerRadius = 8
    }
    @objc func onImageUpload(){
        galleryAction()
    }
    @IBAction func onImageDeletion(_ sender: UIButton) {
        uploadedImg.image = nil
        deleteImgBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if InternetConnectionManager.isConnectedToNetwork() {
            print("connected")
        } else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            navigationController?.pushViewController(noInternetVC, animated: true)
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.postDescription.endEditing(true)
    }
    
    @IBAction func onPublishPost() {
        if uploadedImg != nil && uploadedImg.image != nil{
            let fileName = "IMG\(String(describing: appDelegate.userDetails.userId))_\(generateRandomNumber(numDigits: 3)).jpg"
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
            if postDescription.text!.elementsEqual("Description") {
                postDescription.text = ""
            }
            feedsSvcImpl.saveNewPost(feedPostedBy: appDelegate.userDetails.userName!, feedTitle: postTitle.text!, feedText: postDescription.text!, feedImageUrl: fileName,failure: {(failure) in
                if InternetConnectionManager.isConnectedToNetwork() {
                    print("connected")
                } else {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
                    self.navigationController?.pushViewController(noInternetVC, animated: true)
                }
            })
        } else {
            feedsSvcImpl.saveNewPost(feedPostedBy: appDelegate.userDetails.userName!, feedTitle: postTitle.text!, feedText: postDescription.text!, feedImageUrl: nil,failure: {(failure) in
                if InternetConnectionManager.isConnectedToNetwork() {
                    print("connected")
                } else {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
                    self.navigationController?.pushViewController(noInternetVC, animated: true)
                }
            })
        }
        
        let alert = UIAlertController(title: "Publish Post", message: "Post Published Successfully", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(success) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func setupNavigationbar() {
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.gray
        }
    }
    @objc func editingChanged() {
        if postTitle.text!.isEmpty {
            publishPostBtn.isEnabled = true
            publishPostBtn.alpha = 0.5
        } else {
            publishPostBtn.isEnabled = false
            publishPostBtn.alpha = 1
        }
    }
}
