//
//  SettingsViewController.swift
//  Toner
//
//  Created by User on 05/08/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import Alamofire
import NVActivityIndicatorView

class SettingsViewController: UIViewController {

    @IBOutlet weak var profileImageBackView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnUploadImage(_ sender: UIButton) {
        presentPhoto()
        
    }
    var settingMenus = [Setting]()
    var imagData =  Data()
    var activityIndicator: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        // Do any additional setup after loading the view.
        self.setNavigationBar(title: "Settings", isBackButtonRequired: false)
        self.view.backgroundColor = ThemeColor.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if (TonneruMusicPlayer.player?.isPlaying ?? false){
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))

        }else{
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        profileImageBackView.layer.cornerRadius = profileImageBackView.frame.height / 2
        profileImageBackView.clipsToBounds = true
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true

    }
    fileprivate func setupView(){
        profileImageBackView.backgroundColor = ThemeColor.buttonColor
        userNameLabel.textColor = .white
        userNameLabel.numberOfLines = 0
        userNameLabel.font = UIFont.montserratMedium.withSize(25)
        userNameLabel.text = UserDefaults.standard.fetchData(forKey: .userFirstName) + " " + UserDefaults.standard.fetchData(forKey: .userLastName)
        
        profileImage.image = UIImage(icon: .FAUser, size: CGSize(width: 40, height: 40), textColor: .black)
        let url:String = UserDefaults.standard.fetchData(forKey: .userImage)
        print(url)
        profileImage.kf.setImage(with: URL(string: UserDefaults.standard.fetchData(forKey: .userImage)))
        profileImage.contentMode = .scaleAspectFill
        let profileMenu = Setting(name: SettingsName.acountOverview, image: SettingsImage.accountoverview)
        self.settingMenus.append(profileMenu)
        
        let EdiProfileMenu = Setting(name: SettingsName.editProfile, image: SettingsImage.editProfile)
        self.settingMenus.append(EdiProfileMenu)
        
        if UserDefaults.standard.fetchData(forKey: .userGroupID) == "3"{
            let editSocial = Setting(name: SettingsName.editSocial, image: SettingsImage.edit_social)
            self.settingMenus.append(editSocial)
        }

        let subscriptionMenu = Setting(name: SettingsName.subscription, image: SettingsImage.subscription)
        self.settingMenus.append(subscriptionMenu)
        
        let changePasswordMenu = Setting(name: SettingsName.changePassword, image: SettingsImage.change_password)
        self.settingMenus.append(changePasswordMenu)
        
        let myAlbumMenu = Setting(name: SettingsName.myAlbum, image: SettingsImage.myalbum)
        self.settingMenus.append(myAlbumMenu)

        let mySongsMenu = Setting(name: SettingsName.mySongs, image: SettingsImage.mysongs)
        self.settingMenus.append(mySongsMenu)
        
        let myCommissionMenu = Setting(name: SettingsName.myCommission, image: SettingsImage.mycommission)
        self.settingMenus.append(myCommissionMenu)
        
        
        let followerMenu = Setting(name: SettingsName.followers, image: SettingsImage.followers)
        self.settingMenus.append(followerMenu)
        
        let myStationMenu = Setting(name: SettingsName.myStation, image: SettingsImage.followers)
        self.settingMenus.append(myStationMenu)
        
        
        let supportMenu = Setting(name: SettingsName.support, image: SettingsImage.support)
        self.settingMenus.append(supportMenu)
        
        let downloadMenu = Setting(name: SettingsName.myDownload, image: SettingsImage.myDownload)
        self.settingMenus.append(downloadMenu)
        
        let logoutMenu = Setting(name: SettingsName.logOut, image: SettingsImage.logOut)
        self.settingMenus.append(logoutMenu)
        
    }
    
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
}
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            profileImage.image = selectedImage
            imagData = selectedImage.jpegData(compressionQuality: 0.5)!
        }
        
        //dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
            self.uploadImage()

        }
    }
}
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenus.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        cell.data = settingMenus[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settingMenus[indexPath.row].name {
        case SettingsName.acountOverview:
            let destination = AcountOverviewViewController(nibName: "AcountOverviewViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
            
        case SettingsName.editProfile:
            let destination = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
        case SettingsName.subscription:
            let destination = SubscriptionViewController(nibName: "SubscriptionViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
        case SettingsName.myStation:
            let destination = MyStationsViewController(nibName: "MyStationsViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
        case SettingsName.changePassword:
            let destination = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
      //=======
        case SettingsName.myAlbum:
            let destination = MyAlbumViewController(nibName: "MyAlbumViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
            
        case SettingsName.mySongs:
            let destination = MySongViewController(nibName: "MySongViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
            
        case SettingsName.myCommission:
            let destination = MyCommission(nibName: "MyCommission", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
       //========
        case SettingsName.followers:
            let destination = FollowingsViewController(nibName: "FollowingsViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
        case SettingsName.editSocial:
            let destination = EditSocialViewController(nibName: "EditSocialViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
        case SettingsName.myDownload:
            let destination = MyDownloadViewController(nibName: "MyDownloadViewController", bundle: nil)
            self.navigationController?.pushViewController(destination, animated: false)
        case SettingsName.logOut:
            let alertController = UIAlertController(title: "Alert!", message: "Are you sure you want to logout?", preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
                UserDefaults.standard.deleteAllData()
                let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.appD.window?.rootViewController = destination
            }
            alertController.addAction(okAlertAction)
            
            let cancelAlertAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertController.addAction(cancelAlertAction)
            
            self.present(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension SettingsViewController{
    //https://tonnerumusic.com/api/v1/profile_image_edit
    
    //body(user_id {number}, image{file})
    func uploadImage()
    {
        self.activityIndicator.startAnimating()

        if !NetworkReachabilityManager()!.isReachable{
                  return
        }
        let url = "https://tonnerumusic.com/api/v1/profile_image_edit"
       
        var headers = HTTPHeaders()

        
        headers = ["Content-type": "multipart/form-data"]

        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            multipartFormData.append(self.imagData, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
         
            let userID:String = UserDefaults.standard.fetchData(forKey: .userId) //"53"

            multipartFormData.append(userID.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"user_id")

        }, to: url,method:HTTPMethod.post,
           headers:headers,
           encodingCompletion: { encodingResult in
            DispatchQueue.main.async {
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        self.activityIndicator.stopAnimating()
                    }
                case .failure(let error):
                    print(error)
                    self.activityIndicator.stopAnimating()

                }
            }
        })
      

    }
}
