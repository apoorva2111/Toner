//
//  CreatePlayListViewController.swift
//  Toner
//
//  Created by Muvi on 17/03/21.
//  Copyright © 2021 Users. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire
class CreatePlayListViewViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate{
    @IBOutlet weak var createPlayListLabel: UILabel!
    @IBOutlet weak var playListNameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewDiscription: UIView!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var imgCreateAlbmum: UIImageView!
    @IBOutlet weak var imgCameraHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblDiscription: UILabel!
    
    @IBOutlet weak var viewDiscriptionHeightCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBrowseOutlet: UIButton!
    
    
    var activityIndicator: NVActivityIndicatorView!
    var artistId: String!
    var artistImage: String!
    var imagData =  Data()
    var strCreate = ""
    var album_id = ""
    var album_name = ""
    var album_description = ""
    var album_image = "image"
    
    var isFromEdit = false
    var viewcontroller = UIViewController()
    

    @IBAction func textFieldEditBegin(_ sender: Any)
    {
       
    }
    
    //@IBOutlet weak var descriptionTextField: UITextField!
    @IBAction func cancelButtonfunc(_ sender: Any)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveButtonFunc(_ sender: Any)
    {
        self.view.endEditing(true)
        if (self.playListNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
        {
            self.view.makeToast(message: "Should not be blank", duration: 4.0, backgroundColor: nil, messageColor: UIColor.red)
        }
        else
        {
            //self.addToAlbum()
            if strCreate == "Playlist"{
                self.createPlaylist()
            }else{
                if album_id != ""{
                    album_description = txtViewDescription.text!
                    album_name = playListNameTextField.text!
                    if isFromEdit{
                    
                    }else{
                        self.imagData = (imgCreateAlbmum.image?.jpegData(compressionQuality: 0.5)!)!
                            print(self.imagData)
                    }
                    editAlbum()
                }else{
                    album_description = txtViewDescription.text!
                    album_name = playListNameTextField.text!
                    self.addToAlbum()
                }
            }
            
        }
    }
    @IBAction func btnImageBrowseAction(_ sender: UIButton) {
        isFromEdit = true
        presentPhoto()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
            return true
       
    }
    
    @objc func dismissFunc()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        self.view.backgroundColor = ThemeColor.backgroundColor

        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        saveButton.layer.borderWidth = 0
        saveButton.layer.cornerRadius = 5
        saveButton.layer.masksToBounds = true
        
        cancelButton.layer.borderWidth = 0
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.masksToBounds = true
        
        viewTitle.layer.borderWidth = 1
        viewTitle.layer.cornerRadius = 5
        viewTitle.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        viewTitle.layer.masksToBounds = true
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "979797") ]
        playListNameTextField.attributedPlaceholder = NSAttributedString.init(string: "Title", attributes: attributes)
        
        viewDiscription.layer.borderWidth = 1
        viewDiscription.layer.cornerRadius = 5
        viewDiscription.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        viewDiscription.layer.masksToBounds = true
        
        
        imgCreateAlbmum.layer.cornerRadius = 10
        imgCreateAlbmum.layer.masksToBounds = true
        
        btnBrowseOutlet.layer.borderWidth = 0
        btnBrowseOutlet.layer.cornerRadius = 5
        btnBrowseOutlet.layer.masksToBounds = true
        
        if strCreate == "Playlist"{
            imgCreateAlbmum.isHidden = true
            btnBrowseOutlet.isHidden = true
            imgCameraHeightConstraint.constant = 0
            viewDiscription.isHidden = true
            viewDiscriptionHeightCOnstraint.constant = 0
            lblDiscription.isHidden = true
        }else{
            imgCreateAlbmum.isHidden = false
            btnBrowseOutlet.isHidden = false
            imgCameraHeightConstraint.constant = 100
            viewDiscription.isHidden = false
            viewDiscriptionHeightCOnstraint.constant = 100
            lblDiscription.isHidden = false
        }
        
        if album_id != "" {
            playListNameTextField.text = album_name
            imgCreateAlbmum.kf.setImage(with: URL(string: album_image ))
            imgCreateAlbmum.contentMode = .scaleToFill

        }
    }
}

//MARK :- Image picker code
extension CreatePlayListViewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhoto() {
        let actionSheet = UIAlertController(title: "Add Image",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera1()
                                                
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                             //   self?.presentPhotoPicker1()
                                                let photoPicker = UIImagePickerController()
                                                    photoPicker.delegate = self
                                                photoPicker.sourceType = .photoLibrary
                                                self!.present(photoPicker, animated: true, completion: nil)

                                            }))
        self.present(actionSheet, animated: true)
        actionSheet.view.superview?.isUserInteractionEnabled = true
        actionSheet.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
    }
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
    func presentCamera1() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imgCreateAlbmum.image = selectedImage
            imagData = selectedImage.jpegData(compressionQuality: 0.5)!
        }
        
        //dismiss(animated: true, completion: nil)
        dismiss(animated: true) {

        }
    }
    func addToAlbum()
    {
        self.activityIndicator.startAnimating()

        if !NetworkReachabilityManager()!.isReachable{
                  return
        }
        let url = "https://tonnerumusic.com/api/v1/create_album"
        var headers = HTTPHeaders()

        
        headers = ["Content-type": "multipart/form-data"]

        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            multipartFormData.append(self.imagData, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
         
            let userID:String = UserDefaults.standard.fetchData(forKey: .userId) //"53"

            multipartFormData.append(userID.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"artist_id")
          
          
            
                multipartFormData.append(self.album_name.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"name")

    
            
                multipartFormData.append(self.album_description.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"description")
            
          

        }, to: url,method:HTTPMethod.post,
           headers:headers,
           encodingCompletion: { encodingResult in
          //  DispatchQueue.main.async {
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        self.activityIndicator.stopAnimating()
                       // self.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true) {
                            self.viewcontroller.viewWillAppear(true)
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.activityIndicator.stopAnimating()

                }
          //  }
        })
      

    }
    func editAlbum() {
        self.activityIndicator.startAnimating()

        if !NetworkReachabilityManager()!.isReachable{
                  return
        }
        let url = "https://tonnerumusic.com/api/v1/edit_album"
        var headers = HTTPHeaders()

        
        headers = ["Content-type": "multipart/form-data"]

        
        
        Alamofire.upload(multipartFormData: { [self] multipartFormData in
            // import image to request
          
            multipartFormData.append(self.imagData, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                // (album_id, name, description, image {FILE})
          
            multipartFormData.append(self.album_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"album_id")
            multipartFormData.append(self.album_name.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"name")
             
                
            multipartFormData.append(self.album_description.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"description")
            
     

        }, to: url,method:HTTPMethod.post,
           headers:headers,
           encodingCompletion: { encodingResult in
          //  DispatchQueue.main.async {
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true) {
                            self.viewcontroller.viewWillAppear(true)
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.activityIndicator.stopAnimating()

                }
          //  }
        })
      

    }
    func createPlaylist(){
        
        self.activityIndicator.startAnimating()
        let bodyParams = [
            "user_id"    : UserDefaults.standard.fetchData(forKey: .userId),
            "name"    : self.playListNameTextField.text! ,
            ] as [String : String]
        self.activityIndicator.startAnimating()
        
        Alamofire.request("https://tonnerumusic.com/api/v1/createplaylist", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
//            self.showAlertForPlaylist(message: resposeJSON["message"] as! String)
            print(resposeJSON)
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true) {
                self.viewcontroller.viewWillAppear(true)
            }
          //  self.allPlayListFunc()
            
        }
    }

}
